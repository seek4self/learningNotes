# Alpine

Alpine Linux Docker 镜像基于 Alpine Linux 操作系统，后者是一个面向安全的轻型 Linux 发行版, 相比于其他 Docker 镜像，它的容量非常小，仅仅只有 5M，且拥有非常友好的包管理器。

## 更换源

```sh
# 阿里源
sed -i s@/dl-cdn.alpinelinux.org/alpine/v3.9/@/mirrors.aliyun.com/alpine/v3.9/@g /etc/apk/repositories
# 清华源
sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories
```

国内版本更新可能滞后，根据实际情况替换

## 修改国内时区

```dockerfile
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
```

若没有 tzdata 工具需要自行安装

## apk

```sh
#查询openssh相关的软件包
apk search  openssh
#安装一个软件包
apk add  xxx
#删除已安装的xxx软件包
apk del  xxx
#获取更多apk包管理的命令参数
apk --help
#比如安装常用的网络相关工具：
#更新软件包索引文件
apk update
#用于文本方式查看网页，用于测试http协议
apk add curl  
```
