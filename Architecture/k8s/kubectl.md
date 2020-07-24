---
 Author: mazhuang
 Date: 2020-07-02 16:07:27
 LastEditTime: 2020-07-02 16:07:36
 Description: 
---
# kubectl

kubernetes 命令行接口，默认配置文件位置`$HOME/.kube/config`,通过设置环境变量 `KUBECONFIG` 或设置 `--kubeconfig` 参数指定其它 kubeconfig 文件。  
具体安装方法见[官方文档 install-kubectl](https://kubernetes.io/zh/docs/tasks/tools/install-kubectl/)

## 常用命令

```sh
# 创建命名空间
kubectl create namespace <n-name>

# 创建/更新资源（服务）
kubectl apply -f example-service.yaml

# 查询资源
kubectl get [source] [name]
# source 包括 nodes、pods、services、deployments 等

# 查询资源状态
kubectl describe pods/[pod-name]

# 删除资源
# 直接删除 pod，Deployment 将会重新创建该 pod
kubectl delete deployment <deploy-name>

# 进入容器
kubectl exec -ti <pod-name> /bin/bash

# 打印日志
kubectl logs <pod-name> -c <container-name>

# 重启pod
kubectl -n <namespace> get pod <pod-name> -o yaml | kubectl replace --force -f -

```

## shell 补全

```sh
echo "source <(kubectl completion bash)" >> ~/.bashrc
source ~/.bashrc
```

## jsonpath

Kubectl 支持 JSONPath 模板。

JSONPath 模板由 {} 包起来的 JSONPath 表达式组成。Kubectl 使用 JSONPath 表达式来过滤 JSON 对象中的特定字段并格式化输出。除了原始的 JSONPath 模板语法，以下函数和语法也是有效的:

- 使用双引号将 JSONPath 表达式内的文本引起来。
- 使用 `range`，`end` 运算符来迭代列表。
- 使用负片索引后退列表。负索引不会"环绕"列表，并且只要 `-index + listLength> = 0` 就有效。

> 说明：
> - `$` 运算符是可选的，因为默认情况下表达式总是从根对象开始。
> - 结果对象将作为其 String() 函数输出。

[在线测试](http://jsonpath.com/)
