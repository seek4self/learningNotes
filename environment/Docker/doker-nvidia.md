# Docker-nvidia 环境部署
  
以下内容摘自[nvidia-docker官方github](https://github.com/NVIDIA/nvidia-docker/blob/master/README.md)

## 先决条件

运行nvidia-docker 2.0的先决条件列表如下所述。  
有关如何为Linux发行版安装Docker的信息，请参阅[Docker文档](https://docs.docker.com/install/)。

- 内核版本> 3.10的GNU / Linux x86_64
- Docker> = 1.12
- 采用架构的NVIDIA GPU> Fermi（2.1）
- [NVIDIA驱动程序](http://www.nvidia.com/object/unix.html)〜= 361.93（旧版本未经测试）

您的驱动程序版本可能会限制您的CUDA功能（请参阅[CUDA要求](https://github.com/NVIDIA/nvidia-docker/wiki/CUDA#requirements)）

## 配置环境

- **确保已为您的服务器安装了NVIDIA驱动程序和受支持的 Docker 版本，具体要求请参阅[先决条件](#%E5%85%88%E5%86%B3%E6%9D%A1%E4%BB%B6)**
- **如果您有自定义/etc/docker/daemon.json，则nvidia-docker2程序包可能会覆盖它。**

配置流程如下：

```sh
# 如果你安装了nvidia-docker 1.0：我们需要删除它和所有现有的GPU容器
docker volume ls -q -f driver=nvidia-docker | xargs -r -I{} -n1 docker ps -q -a -f volume={} | xargs -r docker rm -f
sudo apt-get purge -y nvidia-docker

# 添加软件包存储库
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
    sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update

# 运行下面命令查看nvidia-docker可用版本
apt-cache madison nvidia-docker2 nvidia-container-runtime
# 查看docker版本
docker version
# 将下面的版本号版本号替换成自己系统上所装docker,安装过程会有选项提示，选Y，若选N后面需要单独配置runtime
# 若不选择版本号，则会默认装最新的，和系统所装docker版本不匹配会安装失败
sudo apt-get install -y nvidia-docker2=2.0.3+docker18.06.1-1 nvidia-container-runtime=2.0.0+docker18.06.1-1
# 重新加载Docker守护进程配置
sudo pkill -SIGHUP dockerd

# 测试nvidia-smi与官方CUDA8.0版本镜像
# 我公司目前 Nvidia 驱动版本是 `375.66`, 只能使用 CUDA 8.0 版本的镜像
docker run --runtime=nvidia --rm nvidia/cuda:8.0-runtime nvidia-smi
```
