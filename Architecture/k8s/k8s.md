---
 Author: mazhuang
 Date: 2020-06-23 10:05:14
 LastEditTime: 2020-06-23 10:05:18
 Description: 
---
# Kubernetes

- [核心概念](#核心概念)
  - [Pod](#pod)
  - [Volume](#volume)
  - [Deployment](#deployment)
  - [Service](#service)
  - [Namespaces](#namespaces)
- [环境要求](#环境要求)
- [环境部署](#环境部署)
  - [docker 部署](#docker-部署)
  - [kind 部署](#kind-部署)
    - [install](#install)
    - [deploy](#deploy)
    - [error](#error)
  - [sealos 部署](#sealos-部署)
    - [install](#install-1)
    - [install dashboard](#install-dashboard)
- [kubectl proxy](#kubectl-proxy)
- [yaml 配置](#yaml-配置)
- [配置管理](#配置管理)
  - [ConfigMap配置热更新](#configmap配置热更新)
  - [服务配置热更新](#服务配置热更新)
- [数据卷](#数据卷)
  - [PV/PVC](#pvpvc)

Kubernetes是一个开源的，用于管理云平台中多个主机上的容器化的应用，Kubernetes的目标是让部署容器化的应用简单并且高效（powerful）,Kubernetes提供了应用部署，规划，更新，维护的一种机制。

## 核心概念

### Pod

- 最小的调度以及资源单元
- 由一个或多个容器组成
- 定义容器的运行方式（CMD、环境变量）
- 提供给容器共享的运行环境（网络、进程空间）

### Volume

- 声明在Pod中的容器可以访问的宿主机文件目录
- 可以被挂载在Pod中一个或多个容器的指定路径下
- 支持多种后端存储的抽象
  - 本地存储、分布式存储、云存储...

### Deployment

- 定义一组Pod的副本数目、版本等
- 通过控制器（Controller）维持Pod的数目
  - 自动恢复失败的Pod
- 通过控制器以指定的策略控制版本
  - 滚动升级、重新部署、回滚等

### Service

- 提供一个或者多个 Pod 实例的稳定访问地址
- 支持多种访问方式实现
  - Cluster IP
  - NodePort
  - LoadBalancer

### Namespaces

- 一个集群内部的逻辑隔离机制(鉴权、资源额度等)
- 每个资源都属于一个Namespace
- 同一个Namespace中的资源命名唯一
- 不同Namespace中的资源可重名

## 环境要求

- Docker
- master节点CPU必须2C以上
- 务必同步服务器时间
- 内核必须支持 memory and swap accounting
- 禁用虚拟内存

```sh
# 修改选项 GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1"
vim /etc/default/grub
# 更新grub.cfg
sudo update-grub

# 禁用swap，临时禁用不管用，需要永久禁用
# 把根目录文件系统设为可读写
sudo mount -n -o remount,rw /
# 注释swap 行kind create cluster --name istio-testing
sudo vim /etc/fstab

# 重启系统
reboot
# 检查是否设置成功
cat /proc/cmdline
# BOOT_IMAGE=/boot/vmlinuz-4.4.0-171-generic root=UUID=f9542da7-****-473d-****-2321****6d11 ro cgroup_enable=memory swapaccount=1 quiet
# 查看分区状态
sudo free -m


# ubuntu 可以采用 snap 安装 kubectl 客户端
snap install kubectl --classic
kubectl version --client
```

## 环境部署

以下均为测试（学习）环境部署，生产环境还须用`kubeadm`

### docker 部署

该流程过于繁琐，且需要科学上网，可以放弃了

1. 运行Etcd

```sh
docker run --net=host -d \
    -v /var/etcd/data:/var/etcd/data
    gcr.io/google_containers/etcd:3.4.7 \
    /usr/local/bin/etcd \
    --addr=127.0.0.1:4001 \
    --bind-addr=0.0.0.0:4001 \
    --data-dir=/var/etcd/data
```

2. 启动master

```sh
docker run \
    --volume=/:/rootfs:ro \
    --volume=/sys:/sys:ro \
    --volume=/dev:/dev \
    --volume=/var/lib/docker/:/var/lib/docker:ro \
    --volume=/var/lib/kubelet/:/var/lib/kubelet:rw \
    --volume=/var/run:/var/run:rw \
    --net=host \
    --pid=host \
    --privileged=true \
    -d \
    gcr.io/google_containers/hyperkube:v1.18.4 \
    /hyperkube kubelet --containerized --hostname-override=127.0.0.1 --address=0.0.0.0 --api-servers=http://localhost:8088 --config=/etc/kubernetes/manifests
```

3. 运行service proxy

```sh
docker run -d --net=host --privileged gcr.io/google_containers/hyperkube:v1.18.4 /hyperkube proxy --master=http://127.0.0.1:8088 --v=2
```

### kind 部署

kubernetes in docker, 经验证，只能部署单台主机，做测试用

#### install

```sh
# 以下两种方式均可以安装
#> 下载最新的 0.8.1 版本
wget -O /usr/local/bin/kind https://github.com/kubernetes-sigs/kind/releases/download/0.8.1/kind-linux-amd64 && chmod +x /usr/local/bin/kind
#> go 源码安装, go 版本最好是 Go 1.13 或最新版本
GO111MODULE="on" go get sigs.k8s.io/kind@v0.8.1
```

#### deploy

```sh
# 部署单节点集群
kind create cluster
# 0.8.1 版本 默认下载dockerhub的镜像 kindest/node:v1.18.2，若下载较慢可以先下载下来，然后用 `--image` 参数执行
kind create cluster --image kindest/node:v1.18.2

Creating cluster "kind" ...
 ✓ Ensuring node image (kindest/node:v1.18.2) 🖼
 ✓ Preparing nodes 📦  
 ✓ Writing configuration 📜
 ✓ Starting control-plane 🕹️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️
 ✓ Installing CNI 🔌
 ✓ Installing StorageClass 💾
Set kubectl context to "kind-kind"
You can now use your cluster with:

kubectl cluster-info --context kind-kind

Thanks for using kind! 😊
```

通过[配置文件](./multi-node.yaml)部署多节点集群，

```sh
kind create cluster --config ~/learningNotes/Architecture/k8s/multi-node.yaml --name cluster-multi-node
```

#### error

是代理的锅，下载镜像需要代理，部署运行则不需要

```log
  Unfortunately, an error has occurred:
    timed out waiting for the condition

  This error is likely caused by:
    - The kubelet is not running
    - The kubelet is unhealthy due to a misconfiguration of the node in some way (required cgroups disabled)

  If you are on a systemd-powered system, you can try to troubleshoot the error with the following commands:
    - 'systemctl status kubelet'
    - 'journalctl -xeu kubelet'

  Additionally, a control plane component may have crashed or exited when started by the container runtime.
  To troubleshoot, list all containers using your preferred container runtimes CLI.

  Here is one example how you may list all Kubernetes containers running in cri-o/containerd using crictl:
    - 'crictl --runtime-endpoint /run/containerd/containerd.sock ps -a | grep kube | grep -v pause'
    Once you have found the failing container, you can inspect its logs with:
    - 'crictl --runtime-endpoint /run/containerd/containerd.sock logs CONTAINERID'

couldn't initialize a Kubernetes cluster

```

### sealos 部署

[sealos](https://sealyun.com/)一个二进制工具加一个资源包，不依赖haproxy keepalived ansible等重量级工具，一条命令就可实现kubernetes高可用集群构建，无论是单节点还是集群，单master还是多master，生产还是测试都能很好支持！简单不意味着阉割功能，照样能全量支持kubeadm所有配置。

#### install

```sh
# 下载并安装sealos, sealos是个golang的二进制工具，直接下载拷贝到bin目录即可, release页面也可下载
wget -c https://sealyun.oss-cn-beijing.aliyuncs.com/latest/sealos && \
    chmod +x sealos && mv sealos /usr/bin

# 下载离线资源包
# 该版本只有一年证书，不适用于生产环境
wget -c https://sealyun.oss-cn-beijing.aliyuncs.com/d551b0b9e67e0416d0f9dce870a16665-1.18.0/kube1.18.0.tar.gz

# 安装一个master的kubernetes集群
sealos init --passwd 123456 \
  --user root \
  --master 192.168.1.118  \
  --node 192.168.1.123 \
  --pkg-url ~/kube1.18.0.tar.gz \
  --version v1.18.0
```

踩坑记录：

- 服务器必须禁用 `swap`，步骤详见[环境要求](#环境要求)
- 服务器必须设置 `root` 用户密码,必须用 `root` 用户(或`sudo`) 执行安装命令

  ```sh
  # ubuntu 默认开机root用户是随机密码，修改root用户密码，就可以设置固定密码
  # 需要输入三次密码，第一次是当前用户密码，后两次是root密码
  sudo passwd root
  # 登录root用户
  su
  ```

- 服务器必须支持 `root` 用户 `ssh` 登录，若root 密码设置不一样，则使用密钥登录

  ```sh
  # 修改 sshd 配置文件
  sudo vim /etc/ssh/sshd_config

  # 将 `prohibit-password` 改为 `yes`
  #> PermitRootLogin prohibit-password
  #> PermitRootLogin yes
  # 重启 ssh 服务
  sudo service ssh restart
  ```

#### install dashboard

dashboard 是可视化控制台界面,可以替代 `kubectl` 命令行操作，查看 `services`、`pods`、`nodes` 等信息

```sh
# 安装 dashboard，命令行下载比较慢，建议先下载安装包，再用命令行安装
sealos install --pkg-url https://github.com/sealstore/dashboard/releases/download/v2.0.0-bata5/dashboard.tar
# 安装完成后会输出登录token，建议保存token，该token 固定不变
kubectl get secret -n kubernetes-dashboard \
    $(kubectl get secret -n kubernetes-dashboard|grep dashboard-token |awk '{print $1}') \
    -o jsonpath='{.data.token}'  | base64 --decode

# 访问地址 https://master-ip:32000
```

## kubectl proxy

可以使用 proxy 模式访问集群

```sh
# 仅 localhost 访问
kubectl proxy
# 主机外部可访问
kubectl proxy --address=0.0.0.0 --accept-hosts='^*$'

```

访问集群服务

```t
# 
http://kubernetes_master_address/api/v1/namespaces/namespace_name/services/service_name[:port_name]/proxy
```

## yaml 配置

部署应用(服务)需要提供 yaml 文件，例如部署 `nginx` 容器如下

```yaml
apiVersion: apps/v1 # for versions before 1.9.0 use apps/v1beta2
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  selector:
    matchLabels:
      app: nginx
  replicas: 2 # tells deployment to run 2 pods matching the template
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
```

其中以下字段**加粗**为必要字段：

- **apiVersion**: 创建 Kubernetes 对象使用的 `Kubernetes API` 的版本，  
  Kubernetes 1.9.0 以前的版本使用 `apps/v1beta2`， 1.9.0以后的版本使用 `apps/v1`  
  执行 `kubectl api-versions` 命令可查看集群支持的版本

  ```sh
  $ kubectl api-versions
  admissionregistration.k8s.io/v1
  admissionregistration.k8s.io/v1beta1
  apiextensions.k8s.io/v1
  apiextensions.k8s.io/v1beta1
  apiregistration.k8s.io/v1
  apiregistration.k8s.io/v1beta1
  apps/v1
  authentication.k8s.io/v1
  authentication.k8s.io/v1beta1
  authorization.k8s.io/v1
  authorization.k8s.io/v1beta1
  autoscaling/v1
  autoscaling/v2beta1
  autoscaling/v2beta2
  batch/v1
  batch/v1beta1
  certificates.k8s.io/v1beta1
  coordination.k8s.io/v1
  coordination.k8s.io/v1beta1
  discovery.k8s.io/v1beta1
  events.k8s.io/v1beta1
  extensions/v1beta1
  networking.k8s.io/v1
  networking.k8s.io/v1beta1
  node.k8s.io/v1beta1
  policy/v1beta1
  rbac.authorization.k8s.io/v1
  rbac.authorization.k8s.io/v1beta1
  scheduling.k8s.io/v1
  scheduling.k8s.io/v1beta1
  storage.k8s.io/v1
  storage.k8s.io/v1beta1
  v1
  ```

  - 版本说明：
    - alpha  
      名称中带有alpha的API版本是进入Kubernetes的新功能的早期候选版本。这些可能包含错误，并且不保证将来可以使用。
    - beta  
      API版本名称中的beta表示测试已经超过了alpha级别，并且该功能最终将包含在Kubernetes中。 虽然它的工作方式可能会改变，并且对象的定义方式可能会完全改变，但该特征本身很可能以某种形式将其变为Kubernetes。
    - stable  
      稳定的apiVersion这些名称中不包含alpha或beta。 它们可以安全使用。

- **kind**: Kubernetes 对象的类型  
  执行 `kubectl api-resources` 命令可查看 kind 对应的 apiVersion  
  在 yaml 文件中使用 `<APIGROUP>/v1`  
  执行 `kubectl explain <resource-name>` 可以查询对应类型的详细信息

  ```sh
  $ kubectl api-resources
  NAME                              SHORTNAMES   APIGROUP                       NAMESPACED   KIND
  bindings                                                                      true         Binding
  endpoints                         ep                                          true         Endpoints
  events                            ev                                          true         Event
  namespaces                        ns                                          false        Namespace
  nodes                             no                                          false        Node
  pods                              po                                          true         Pod
  replicationcontrollers            rc                                          true         ReplicationController
  resourcequotas                    quota                                       true         ResourceQuota
  secrets                                                                       true         Secret
  serviceaccounts                   sa                                          true         ServiceAccount
  services                          svc                                         true         Service
  customresourcedefinitions         crd,crds     apiextensions.k8s.io           false        CustomResourceDefinition
  apiservices                                    apiregistration.k8s.io         false        APIService
  deployments                       deploy       apps                           true         Deployment
  replicasets                       rs           apps                           true         ReplicaSet
  statefulsets                      sts          apps                           true         StatefulSet
  tokenreviews                                   authentication.k8s.io          false        TokenReview
  cronjobs                          cj           batch                          true         CronJob
  jobs                                           batch                          true         Job
  certificatesigningrequests        csr          certificates.k8s.io            false        CertificateSigningRequest
  leases                                         coordination.k8s.io            true         Lease
  endpointslices                                 discovery.k8s.io               true         EndpointSlice
  events                            ev           events.k8s.io                  true         Event
  ingresses                         ing          extensions                     true         Ingress
  ingresses                         ing          networking.k8s.io              true         Ingress
  runtimeclasses                                 node.k8s.io                    false        RuntimeClass
  poddisruptionbudgets              pdb          policy                         true         PodDisruptionBudget
  podsecuritypolicies               psp          policy                         false        PodSecurityPolicy
  rolebindings                                   rbac.authorization.k8s.io      true         RoleBinding
  roles                                          rbac.authorization.k8s.io      true         Role
  priorityclasses                   pc           scheduling.k8s.io              false        PriorityClass
  ```

- **metadata**: 标识对象唯一性的数据，包括一个 `name` 字符串、UID 和可选的 `namespace`
- spec: 规范（`specification`），对预期行为的描述，每个对象有各自的规范，可以执行 `kubectl explain <resource>.spec` 查看详细信息

## 配置管理

- 可变配置就用 `ConfigMap`；
- 敏感信息是用 `Secret`；
- 身份认证是用 `ServiceAccount` 这几个独立的资源来实现的；
- 资源配置是用 `Resources`；
- 安全管控是用 `SecurityContext`；
- 前置校验是用 `InitContainers` 这几个在 spec 里面加的字段，来实现的这些配置管理。

### ConfigMap配置热更新

更新 ConfigMap 后：

- 使用该 ConfigMap 挂载的 Env 不会同步更新
- 使用该 ConfigMap 挂载的 Volume 中的数据需要一段时间（实测大概10秒）才能同步更新
ENV 是在容器启动的时候注入的，启动之后 kubernetes 就不会再改变环境变量的值，且同一个 namespace 中的 pod 的环境变量是不断累加的。为了更新容器中使用 ConfigMap 挂载的配置，需要通过滚动更新 pod 的方式来强制重新挂载 ConfigMap。

### 服务配置热更新

当配置修改后，服务重新加载配置，不影响服务运行，不需要重新部署

- 方案一：通过 ConfigMap 挂载配置文件，服务内监听配置文件是否改动，重新加载配置
- 方案二：使用镜像[configmap-reload](https://link.zhihu.com/?target=https%3A//github.com/jimmidyson/configmap-reload)，通过添加 sidecar 监听配置文件是否变化，发生变更时通过 HTTP 调用通知应用进行热更新，不需要改动服务
- 方案三：同时修改 ConfigMap 和 Deployment 的 `'{"spec": {"template": {"metadata": {"annotations": {"version/config": "20180411" }}}}}'`配置，滚动更新Pod，相当于自动部署更新，适用于**无状态**服务， 对于有状态服务，可以采用方案二

## 数据卷

- `emptyDir`：用于存储临时数据的简单空目录， 删除pod,数据卷也删除
- `hostPath`: 用于将目录从工作节点的文件系统挂载到pod, 数据虽然永久存储，但是重启 pod 时， 若pod 部署节点变更，则数据不会同步，

### PV/PVC

- PV:持久卷（`PersistentVolume`）
- PVC:持久卷声明（`PersistentVolumeClaim`）

两种PV的提供方式:静态或者动态

- Static  
  集群管理员创建多个PV。 它们携带可供集群用户使用的真实存储的详细信息。 它们存在于Kubernetes API中，可用于消费。
- Dynamic  
  当管理员创建的静态PV都不匹配用户的`PersistentVolumeClaim`时，集群可能会尝试为PVC动态配置卷。 此配置基于StorageClasses：PVC必须请求一个类，并且管理员必须已创建并配置该类才能进行动态配置。 要求该类的声明有效地为自己禁用动态配置
