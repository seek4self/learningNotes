# NATS Account

## 用户认证

## 用户配置

## 多租户

多租户通过账户（Account）实现用户空间隔离，保证信息安全

### 配置

```conf
accounts {
    A: {
        users: [
            {user: a, password: a}
        ]
        exports: [
            {stream: puba.>}                # 公开主题
            {service: pubq.>}               # 公开主题
            {stream: b.>, accounts: [B]}    # 私有主题，只有 B 能订阅 b.>
            {service: q.b, accounts: [B]}   # 私有主题，只有 B 能向 q.b 发送请求
        ]
    }
    B: {
        users: [
            {user: b, password: b}
        ]
        imports: [
            {stream: {account: A, subject: b.>}}    # B 只能接收 A 的主题 b.> 中的消息
            {service: {account: A, subject: q.b}}   # B 只能往 A 的主题 q.b 发布订阅/发送请求
        ]
    }
    C: {
        users: [
            {user: c, password: c}
        ]
        imports: [
            {stream: {account: A, subject: puba.>}, prefix: from_a}  # C 用户订阅 A 的主题需要加 prefix 前缀
            {service: {account: A, subject: pubq.C}, to: Q}          # C 向 A 请求时 主题必须是 to 的值
        ]
    }
}
```

| 属性                      | 描述                                                                                  |
| ------------------------- | ------------------------------------------------------------------------------------- |
| `users`                   | 用户配置列表                                                                          |
| `exports`                 | 导出配置列表                                                                          |
| `imports`                 | 导入配置列表                                                                          |
| `exports.accounts`        | 设置主题仅配置账户可见                                                                |
| `exports.response_type`   | streams 主题的响应是单个还是流式, 默认单个：`single`, `stream`                        |
| `imports.stream.subject`  | 导入 streams 主题可以使用通配符                                                       |
| `imports.service.subject` | 导入 services 主题不能使用通配符                                                      |
| `imports.prefix`          | 该账户中订阅其他账户的 `streams` 主题需要加前缀，`prefix` 是 `stream` 独有            |
| `imports.to`              | 该账户中向特殊主题 `to` 发送请求 会重定向到 `services` 主题 ， `to` 是 `service` 独有 |

通过从一个帐户导出 streams 和 services 并将它们导入另一个帐户，可以实现不同帐户之间的消息交换。每个帐户控制导出和导入的内容。

- streams: 发布的消息集形成流，导入到其他账户时，只能被消费，不能被回复
- services: 是该账户能消费和回复的消息，其他账户发出请求，本账户回复

| 账户 | 主题类型 | 发布订阅 |  请求回复  |
| ---- | -------- | :------: | :--------: |
| A->B | streams  |    ✔     | ✓ 不能回复 |
| A->B | services |    ✘     |     ✘      |
| B->A | streams  |    ✘     |     ✘      |
| B->A | services |    ✔     |     ✔      |

### test

- A -> B 发布订阅，主题为 `b.>`， B 订阅可以收到消息， 主题为 `q.b`，B 订阅不能收到消息：

```bash
# pub->sub
$ nats -s nats://a:a@192.168.1.202:10086 pub b.1 "hello"
15:51:11 Published 5 bytes to "b.1"

$ nats -s nats://b:b@192.168.1.202:10086 sub b.>
15:51:00 Subscribing on b.>
[#1] Received on "b.1"
hello

```

- A -> B 请求回复，主题为 `b.>`， B 可以收到请求但**不能**对主题进行回复， 主题为 `q.b`，B 订阅不能接收 A 的请求：

```bash
$ nats -s nats://a:a@192.168.1.202:10086 req b.2 "hello"
15:59:42 Sending request on "b.2"

# there is no reply

$ nats -s nats://b:b@192.168.1.202:10086 reply b.> "hi"
15:59:33 Listening on "b.>" in group "NATS-RPLY-22"
15:59:42 [#0] Received on subject "b.2":

hello

```

- B -> A 发布订阅，主题为 `b.>`， A 订阅不能收到消息， 主题为 `q.b`，A 订阅可以收到消息：

```bash
$ nats -s nats://b:b@192.168.1.202:10086 pub q.b "help"
16:01:53 Published 4 bytes to "q.b"

$ nats -s nats://a:a@192.168.1.202:10086 sub q.b
16:01:29 Subscribing on q.b
[#1] Received on "q.b"
Nats-Request-Info: {"acc":"B","rtt":430328}

help

```

- B -> A 请求回复，主题为 `b.>`， A 不能接收到 B 的请求， 主题为 `q.b`，A 可以收到 B 的请求并对主题进行回复：

```bash
$ nats -s nats://b:b@192.168.1.202:10086 req q.b "help"
16:03:11 Sending request on "q.b"
16:03:11 Received with rtt 1.5005ms
ok

$ nats -s nats://a:a@192.168.1.202:10086 reply q.b "ok"
16:03:04 Listening on "q.b" in group "NATS-RPLY-22"
16:03:11 [#0] Received on subject "q.b":
16:03:11 Nats-Request-Info: {"acc":"B","rtt":686881}

help

```

### 
