# NATS

NATS(Neural Autonomic Transport System) 是轻量级、高性能、云原生的基于发布订阅的分布式的消息中间件

## 通信核心

NATS的核心是基于 发布订阅 实现的，通过将消息发布到主题或订阅主题消息来进行通信，每个消息最多消费一次

### 建立连接

客户端配置可选项，并通过 `nats.Connect(url)` 建立与 Nats 服务器的连接，首先会解析 `Options`, 若没有 `Options`, 使用默认的配置  
基于默认 `Options` 初始化连接 `nats.Conn`,

```go
nc := &Conn{Opts: o} // 初始化连接
nc.newReaderWriter() // 创建读写器
if err := nc.connect(); err != nil { // 开始连接
    return nil, err
}
```

nc 连接过程

```go
if err = nc.createConn(); err == nil {  // 基于 TCP 建立连接，并绑定读写器（nc.bindToNewConn()）
    // 使用两个 goroutine 分别监听读（nc.readLoop()）和写（nc.flusher()）
    err = nc.processConnectInit() 
}
```

### 发布订阅

#### 发布

发布消息通过 `nc.fch` (flush channel) 通知 `flusher` 写协程开始向 nc 连接中写入数据

#### 订阅

订阅消息时，根据传入参数创建订阅对象 `Subscription`, 并将新的订阅对象添加到 nc 连接的订阅者 `map` 中, 启动一个等待协程 `go nc.waitForMsgs(sub)` 来获取消息，在内部等待 `sub.pCond` 的信号通知  
服务器返回的订阅消息在 `nc` 的读协程中处理，通过 `nc.parse(buf)` 集中处理，其中订阅消息类型为 `MSG_PAYLOAD`  
`parse` 调用 `nc.processMsg()` 构造订阅消息并返回

```go
sub := nc.subs[nc.ps.ma.sid] // 获取当前订阅者
subj := string(nc.ps.ma.subject)
reply := string(nc.ps.ma.reply)
m := &Msg{Header: h, Data: msgPayload, Subject: subj, Reply: reply, Sub: sub} // 构造订阅消息
```

#### 同步订阅

同步订阅使用 channel 通信，从服务器获取到消息用 channel 传递给当前订阅者，订阅者通过 `sub.NextMsg(10 * time.Second)` 获取返回的消息，下面时 `nc.processMsg()` 中同步消息部分源码

```go
if sub.mch != nil {
    select {
    case sub.mch <- m:   // 返回消息
    default:
        goto slowConsumer // 通道阻塞，视为慢消费者，直接丢弃该消息
    }
}
```

#### 异步订阅

异步订阅通过链表返回消息，

```go
// Push onto the async pList
if sub.pHead == nil {  // 链表为空时，链表首尾设置为消息
    sub.pHead = m
    sub.pTail = m
    if sub.pCond != nil {
        sub.pCond.Signal()  // 通知 nc.waitForMsgs 接收消息
    }
} else {  // 链表不为空，将消息添加到链表末端
    sub.pTail.next = m
    sub.pTail = m
}
```

### 请求回复

发起请求流程和发布类似，不过在发布之前订阅了一个随机主题用于接收回复内容

回复流程是一个反向发布消息的过程

旧版通过 同步订阅 获取 reply 响应消息

新版接口通过异步订阅 reply 主题，获取服务器响应消息

## JetStream

Nats 内置的分布式持久化功能，将消息存储在流(Stream)中，供消费者依次消费

### Stream

流可以存储不同主题的消息，设置消息的生存周期、容量等属性

| 属性         | 描述                                                                                                                                                           |
| ------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Name         | 流的名称，不能包含空格、制表符、句点 (`.`)、大于 (`>`) 或星号 (`*`)。见[命名](https://docs.nats.io/running-a-nats-service/nats_admin/jetstream_admin/naming)。 |
| Storage      | 存储后端的类型，`File`和 `Memory`                                                                                                                              |
| Subjects     | 要消费的主题列表，支持通配符                                                                                                                                   |
| Replicas     | 在集群 JetStream 中为每条消息保留多少个副本，最多 5 个                                                                                                         |
| MaxAge       | 流中任何消息的最长期限，以纳秒为单位。                                                                                                                         |
| MaxBytes     | Stream 可能包含多少字节。遵守丢弃策略，如果流超过此大小，则删除最旧的消息或拒绝新消息                                                                          |
| MaxMsgs      | 一个流中可能有多少条消息。遵守丢弃策略，如果流超过此消息数量，则删除最旧的消息或拒绝新消息                                                                     |
| MaxMsgSize   | Stream 将接受的最大消息                                                                                                                                        |
| MaxConsumers | 可以为给定的 Stream 定义多少个消费者，`-1` 表示无限                                                                                                            |
| NoAck        | 禁用对 Stream 接收到的消息的确认                                                                                                                               |
| Retention    | 如何考虑消息保留、`LimitsPolicy`（默认）、`InterestPolicy` 或 `WorkQueuePolicy`                                                                                |
| Discard      | 当 Stream 达到其限制时，`DiscardNew` 拒绝新消息，而 `DiscardOld`（默认）删除旧消息                                                                             |
| Duplicates   | 跟踪重复消息的窗口，以纳秒表示。                                                                                                                               |

源码实现添加流：  
通过 `js.AddStream()` 的接口传入流的配置参数（`nats.StreamConfig`），通过 `js.apiSubj()` 生成创建流的特殊主题(`csSubj`)， `js.apiRequestWithContext` 调用 `nc.RequestWithContext()`, 将配置序列化成 json 文本当作消息负载，请求服务器创建流

### 消费者

添加消费者的过程和添加流的过程一样，均是通过请求回复来添加

消费者设置 `Durable` （名称）属性视为持久化消费者，否则是临时消费者，用完即销毁

#### pull 消费者

从服务器主动拉取消息，并针对每条消息都要回复 ack

#### push 消费者

push 消费者建立再 pull 消费者的基础上， 添加了消息转发（推送）、转发流量控制、心跳检测等功能

当创建消费者时设置了 `DeliverySubject` 属性，则该消费者为 push 消费者

对于回复 ack ， push 可选择不回复（`None`） 或者每条都回复（`Explicit`）或者对所有消息只回复一次（`All`）

## 集群

### 搭建

集群搭建需要指定 集群地址和路由地址, 并保持集群名称一致

```bash
nats-server -cluster "nats:localhost:4248" --cluster_name "test"
```

### 超集群

集群每个节点开启网关(`gateway`)配置，使用网关连接多个集群组成超集群

## 账户
