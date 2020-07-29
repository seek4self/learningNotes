# istio-yaml

k8s 配置文件使用`yaml`格式， 使用vscode，可以安装插件`Kubernetes`和`YAML`来自动补全以及矫正  
但是istio的资源识别不到，只能靠自己去判断，一些测试中遇到的问题，列在下面

- **重要**的事情说三遍：所有缩进必须是**空格**，缩进必须是**空格**，必须是**空格**

## VirtualService

- HTTP route cannot contain both route and redirect

重定向和路由规则不能同时存在，可以使用`rewrite`替换`redirect`

```yaml
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  namespace: test
  name: test123
spec:
  hosts:
    - "*"
  gateways:
    - test-gateway
  http:
    - name: mq-home
      match:
        - uri:
            exact: /mq
      # HTTP route cannot contain both route and redirect
      redirect:
        uri: /
      route:
        - destination:
            host: rabbitmq.test.svc.cluster.local
            port:
              number: 15672
```

内部服务路由目标 `host` 通常用`<service-name>.<namespace>.svc.cluster.local`表示，这也是服务间通信的地址
