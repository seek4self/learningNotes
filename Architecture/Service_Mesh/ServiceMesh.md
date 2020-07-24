---
 Author: mazhuang
 Date: 2020-06-18 16:54:55
 LastEditTime: 2020-06-18 16:54:58
 Description: 
---
# Service Mesh

## 简介

Service Mesh又译作“服务网格”，作为服务间通信的基础设施层，应用程序或者说微服务间的 TCP/IP，负责服务之间的网络调用、限流、熔断和监控  
Service Mesh有如下几个特点：

- 应用程序间通讯的中间层
- 轻量级网络代理
- 应用程序无感知
- 解耦应用程序的重试/超时、监控、追踪和服务发现

服务网格中分为控制平面和数据平面

- **数据平面**的职责是处理网格内部服务之间的通信，并负责服务发现、负载均衡、流量管理、健康检查等功能。
- **控制平面**的职责是管理和配置 Sidecar 代理以实施策略并收集遥测。

## 微服务和服务网格

### 微服务

- 优点
  - 降低系统复杂度
  - 松耦合
  - 跨语言
  - 独立部署
  - Docker部署
  - DDD领域驱动设计
- 缺点
  - 服务大小没有统一标准
  - 分布式的复杂性
  - 配置复杂
  - 测试需要依赖多服务配合

### 服务网格

- 优点：
  - 统一的服务治理
  - 服务治理和业务逻辑解藕
- 缺点：
  - 增加运维复杂度
  - 延时
  - 需要更多技术栈

## 有了服务网格是否还需要api网关

### 重叠功能

- 遥测数据收集
- 分布式追踪
- 服务发现
- 负载均衡
- TLS 终止/开始
- JWT 校验
- 请求路由
- 流量切分
- 金丝雀发布
- 流量镜像
- 速率控制

### 不同之处

- 服务网格为服务/客户端提供了更多关于架构其余部分实现的细节/保真度。
- API 网关提供了跨应用程序架构中所有服务的内聚抽象——作为一个整体，为特定的 API 解决了一些边缘/边界问题。

## 服务网格比较

### Consul VS Istio

[Kubernetes Service Mesh：Istio，Linkerd和Consul的比较](https://platform9.com/blog/kubernetes-service-mesh-a-comparison-of-istio-linkerd-and-consul/)

[Istio与Linkerd与Consul：服务网格的比较](https://logz.io/blog/istio-linkerd-envoy-comparison-service-meshes/)

consul(V >= 1.2) 添加了 `Connect` 基于 k8s 为其提供了服务发现、应用安全、可观察性等功能，

istio 拥有 consul 所有的功能，还有更多的流量管理功能（断路器，故障注入，重试，超时，路由规则，虚拟服务器，负载平衡等），

两者均采用 sidecar 模式，该模式将运行在每个容器内的单独容器中的代理放置。该Sidecar容器从应用程序接收数据并将其发送到应用程序。
consul代理可配置，istio 绑定了 Envoy

Istio的网络性能不如consul, istio部署在单台主机上，consul可以分布式部署，

两者均有可视化工具，istio 有额外的专用的 Kiali ,可以查看网络拓扑图及流量信息
