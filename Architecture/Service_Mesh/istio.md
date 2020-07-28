---
 Author: mazhuang
 Date: 2020-06-30 10:01:44
 LastEditTime: 2020-06-30 10:01:47
 Description: 
---
# istio

通过负载均衡、服务间的身份验证、监控等方法，Istio 可以轻松地创建一个已经部署了服务的网络，而服务的代码只需很少更改甚至无需更改。
通过在整个环境中部署一个特殊的 sidecar 代理为服务添加 Istio 的支持，而代理会拦截微服务之间的所有网络通信，然后使用其控制平面的功能来配置和管理 Istio，这包括：

- 为 HTTP、gRPC、WebSocket 和 TCP 流量自动负载均衡。
- 通过丰富的路由规则、重试、故障转移和故障注入对流量行为进行细粒度控制。
- 可插拔的策略层和配置 API，支持访问控制、速率限制和配额。
- 集群内（包括集群的入口和出口）所有流量的自动化度量、日志记录和追踪。
- 在具有强大的基于身份验证和授权的集群中实现安全的服务间通信。

Istio 为可扩展性而设计，可以满足不同的部署需求。

Istio 以统一的方式提供了许多跨服务网络的关键功能：

- 流量管理
- 安全
- 可观察性

## 流量管理

### 虚拟服务

根据不同条件将流量转发到不同版本服务上

### 目标规则

## install

需要 Kubernetes 基础环境，参考不同[平台安装k8s](https://istio.io/latest/zh/docs/setup/platform-setup/)

### istioctl

访问 [Istio release](https://github.com/istio/istio/releases/tag/1.6.4) 页面下载与您操作系统对应的安装文件

```sh
# 命令行下载安装包
curl -L https://istio.io/downloadIstio | sh -
# 将 istioctl 客户端路径增加到 path 环境变量中
cd istio-1.6.4
export PATH=$PWD/bin:$PATH

# 安装 demo 配置 istio
istioctl manifest apply --set profile=demo
#!! 安装过程中有出现超时导致失败，可能是网络问题
```

## slidecar 模式

包含 envoy-proxy、istio-init(iptables 控制)等容器，通过注入方式添加到部署的 pod 中

- 使用 Sidecar 模式的优势:
  - 通过抽象出与功能相关的共同基础设施到一个不同层降低了微服务代码的复杂度。
  - 因为你不再需要编写相同的第三方组件配置文件和代码，所以能够降低微服务架构中的代码重复度。
  - 降低应用程序代码和底层平台的耦合度。

### slidcar injection

```sh
# 默认命名空间自动sidecar注入
kubectl label namespace default istio-injection=enabled
# 手动注入yaml模板
istioctl kube-inject -f demo.yaml | kubectl apply -f -
# 查看命名空间注入情况
kubectl get namespace -L istio-injection
```

### istio-init

数据面的每个Pod会被注入一个名为`istio-init` 的initContainer, initContrainer是K8S提供的机制，用于在Pod中执行一些初始化任务.在Initialcontainer执行完毕并退出后，才会启动Pod中的其它container.

### envoy-proxy

## 可观察性

### kiali

一款可视工具，用于显示服务拓扑结构和服务健康状态、流量图表等

#### 安装

安装 istio 的 demo 配置 会默认安装 kiali 等 ui 工具

#### error

使用istioctl 启动 kiali 可视化界面报错

```err
$ istioctl dashboard kiali
http://localhost:44190/kiali
2020-07-09T06:25:21.093098Z error an error occurred forwarding 44190 -> 20001:e4658a0de6d1, uid : unable to do port forwarding: socat not found
```

系统中缺少 `socat` 程序，通过 `sudo apt-get install socat -y` 安装解决， socat 是 `Socket CAT` 的简称，主要用于在两个数据流之间建立通道，且支持众多协议和链接方式

## VirtualService

HTTP route cannot contain both route and redirect
