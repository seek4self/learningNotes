# HTTP

## Cookie的Secure 和HttpOnly 标记

标记为 Secure 的Cookie只应通过被HTTPS协议加密过的请求发送给服务端。但即便设置了 Secure 标记，敏感信息也不应该通过Cookie传输，因为Cookie有其固有的不安全性，Secure 标记也无法提供确实的安全保障。从 Chrome 52 和 Firefox 52 开始，不安全的站点（http:）无法使用Cookie的 Secure 标记。

为避免跨域脚本 (XSS) 攻击，通过JavaScript的 Document.cookie API无法访问带有 HttpOnly 标记的Cookie，它们只应该发送给服务端。如果包含服务端 Session 信息的 Cookie 不想被客户端 JavaScript 脚本调用，那么就应该为其设置 HttpOnly 标记。

## PUT VS POST

PUT 和POST方法的区别是,PUT方法是幂等的：连续调用一次或者多次的效果相同（无副作用）。连续调用同一个POST可能会带来额外的影响，比如多次提交订单。

## nginx服务器部署HTTPS证书

阿里云/腾讯云签发免费证书，绑定域名

修改`nginx.conf`文件

```conf
# 以下属性中以ssl开头的属性代表与证书配置有关，其他属性请根据自己的需要进行配置。
server {
    listen 443;
    server_name localhost;  # localhost修改为您证书绑定的域名。
    ssl on;   #设置为on启用SSL功能。
    root html;
    index index.html index.htm;
    ssl_certificate cert/domain_name.pem;   #将domain_name.pem替换成您证书的文件名。
    ssl_certificate_key cert/domain_name.key;   #将domain_name.key替换成您证书的密钥文件名。
    ssl_session_timeout 5m;
    ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE:ECDH:AES:HIGH:!NULL:!aNULL:!MD5:!ADH:!RC4;  #使用此加密套件。
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;   #使用该协议进行配置。
    ssl_prefer_server_ciphers on;
    location / {
        root html;   #站点目录。
        index index.html index.htm;
    }
}
```
