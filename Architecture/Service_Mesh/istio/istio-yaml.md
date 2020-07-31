# istio-yaml

- [VirtualService](#virtualservice)
- [暴露端口](#暴露端口)
- [部署多版本服务](#部署多版本服务)

k8s 配置文件使用`yaml`格式， 使用vscode，可以安装插件`Kubernetes`和`YAML`来自动补全以及矫正  
但是istio的资源识别不到，只能靠自己去判断，一些测试中遇到的问题，列在下面

- **重要**的事情说三遍：所有缩进必须是**空格**，缩进必须是**空格**，必须是**空格**

若不清楚某个资源的字段信息，可以使用`kubectl api-resources`和`kubectl explain <resource>`,具体详见[k8s yaml配置](../../k8s/k8s.md#yaml-配置)

```sh
# 也可以使用  --dry-run=client 生成模板，然后自己修改
kubectl create deployment nginx --image=nginx -o yaml --dry-run=client > my-deployment.yaml
```

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

- `VirtualService`通常和`Gateway`一起使用

## 暴露端口

k8s Service 资源默认 `apec.type`为 `ClusterIP`,端口不会暴露出来，访问不到服务内部，  
改为`NodePort`时，就可以将服务端口映射出来，但是如果采用此模式，一个节点只能部署**单个实例**

```yaml
apiVersion: v1
kind: Service
metadata:
  name: rabbitmq
  namespace: test
  labels:
    app: rabbitmq
    service: rabbitmq
spec:
  type: NodePort
  ports:
    # export MQ UI port
    - port: 13411
      targetPort: 15672
      nodePort: 13411
      name: http
    - port: 5672
      name: amqp
  selector:
    app: rabbitmq
```

## 部署多版本服务

1. 部署一个服务的多个版本，只需要一个`Service`和数个`Deployment`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: boom
  namespace: test
  labels:
    app: boom
    version: v0.0.2
spec:
  replicas: 1
  selector:
    matchLabels:
      app: boom
      version: v0.0.2
  template:
    metadata:
      namespace: test
      labels:
        app: boom
        version: v0.0.2
      annotations:
        version/config: "2020,07,29 18:15"
    spec:
      serviceAccountName: boom
```

其中：

- 每个`metadata.name`是唯一值
- 同一服务的`metadata.label.app`均**相同**，
- 使用`metadata.label.version`来区分不同服务版本
- `spec.template.metadata.label`使用和`metadata.label`**相同**的标签

> 关于服务账户，是 `Pod` 容器中的进程与`api-server`交互时的身份验证，默认为`default`
> 相同服务的 `pod` 可以共用同一个 `ServiceAccount`， 在没有设置`token`的情况下，命名空间内的`pod`可以使用相同的`ServiceAccount`
> 一般情况下，建议每个服务都有自己的`ServiceAccount`

2. 建立目标规则，定义`subset`

```yaml
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  name: boom
  namespace: test
spec:
  host: boom.test.svc.cluster.local
  subsets:
    - name: v1
      labels:
        version: v0.0.2
    - name: v2
      labels:
        version: v0.0.3
```

其中 `subsets.name` 为字符串，**不能**出现`.`等标点符号

3. 设置网关，创建虚拟服务，配置请求路由等流量规则

获取网关 IP 和 Port

```sh
# 80 port
export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}')
# 443 port
export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].nodePort}')
# gateway ip
export INGRESS_HOST=$(kubectl get po -l istio=ingressgateway -n istio-system -o jsonpath='{.items[0].status.hostIP}')
# http url
export GATEWAY_URL=$INGRESS_HOST:$INGRESS_PORT
echo "bookinfo url: http://$GATEWAY_URL/productpage"
```
