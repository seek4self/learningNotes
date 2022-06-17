# RabbitMQ

## Exchange Types

[RabbitMQ 消息队列之 Exchange Types](https://juejin.im/post/5be15a976fb9a049aa6e8aa4)

### 简介

交换机是发送消息的AMQP实体。交换机获取消息并将其路由到零或多个队列。所使用的路由算法取决于交换类型（Exchange Types）和被称为绑定（Bindings）的规则。AMQP 0—9-1协议提供四种交换类型：

- Direct exchange
- Fanout exchange : 忽略路由键(Routing Key),将消息路由到绑定到它的所有队列,`广播消息`
- Topic exchange : 基于消息路由键(Routing Key)和用于将队列绑定到交换机的模式之间的匹配，将消息路由到一个或多个队列,通常用户发布/订阅模式,`多播消息`
- Headers exchange

