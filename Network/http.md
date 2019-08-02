# HTTP

## Cookie的Secure 和HttpOnly 标记

标记为 Secure 的Cookie只应通过被HTTPS协议加密过的请求发送给服务端。但即便设置了 Secure 标记，敏感信息也不应该通过Cookie传输，因为Cookie有其固有的不安全性，Secure 标记也无法提供确实的安全保障。从 Chrome 52 和 Firefox 52 开始，不安全的站点（http:）无法使用Cookie的 Secure 标记。

为避免跨域脚本 (XSS) 攻击，通过JavaScript的 Document.cookie API无法访问带有 HttpOnly 标记的Cookie，它们只应该发送给服务端。如果包含服务端 Session 信息的 Cookie 不想被客户端 JavaScript 脚本调用，那么就应该为其设置 HttpOnly 标记。

## PUT VS POST

PUT 和POST方法的区别是,PUT方法是幂等的：连续调用一次或者多次的效果相同（无副作用）。连续调用同一个POST可能会带来额外的影响，比如多次提交订单。
