# DockerNotes

Docker解决了运行环境和配置问题软件容器，方便做持续集成并有助于整体发布的容器虚拟化技术

## docker commit

docker commit :从容器创建一个新的镜像。
> docker commit [OPTIONS] CONTAINER [REPOSITORY[:TAG]]  
-a :提交的镜像作者；  
-c :使用Dockerfile指令来创建镜像；  
-m :提交时的说明文字；  
-p :在commit时，将容器暂停。

```sh
# 提交一个容器为镜像
docker commit -a "mazhuang" -m "add ..." `CONTAINER ID` `NEW NAME`
# 给镜像打标签
docker tag 4af7c275724d dockerhub.bmi:5000/vdmsums
# 推送到私有仓库
docker push dockerhub.bmi:5000/vdmsums
```

## docker restart 参数

- no – 容器退出时不要自动重启。这个是默认值。
- on-failure[:max-retries] – 只在容器以非0状态码退出时重启。可选的，可以退出docker daemon尝试重启容器的次数。
- always – 不管退出状态码是什么始终重启容器。当指定always时，docker daemon将无限次数地重启容器。容器也会在daemon启动时尝试重启，不管容器当时的状态如何。
- unless-stopped – 不管退出状态码是什么始终重启容器，不过当daemon启动时，如果容器之前已经为停止状态，不要尝试启动它

## 删除none镜像

```sh
# 停止容器  
docker stop $(docker ps -a | grep "Exited" | awk '{print $1 }')
# 删除容器
docker rm $(docker ps -a | grep "Exited" | awk '{print $1 }')
# 删除镜像
docker rmi $(docker images | grep "none" | awk '{print $3}')
```

## 查看私有仓库所有镜像

```sh
# 查看所有镜像
curl -XGET http://192.168.1.1:5000/v2/_catalog  
# 查看某个镜像的所有标签
curl -XGET http://192.168.1.1:5000/v2/[image_name]/tags/list
```

## dockerfile 指令

### RUN

- `apt-get update && apt-get install -y`必须同时在一个RUN任务里，以确保每次安装的都是包的最新的版本
- 结尾使用`&& rm -rf /var/lib/apt/lists/*`清除 apt 缓存

## COPY

该命令每执行一次镜像会多生成一层，复制多个文件尽量使用下面的方法

```dockerfile
COPY file1 .
# 使用通配符
COPY test* .

# copy 多个文件时，目标必须是`文件夹`或者以 `/` 结尾
COPY file1 file2 file3 ./
# 多文件可以用数组
COPY ["file1", "file2", "file3", "./"]
# 拷贝目录 目录本身不会被拷贝，只会拷贝目录里所有文件
COPY dir1 dir2 ./
```

## 修改ubuntu时区

```sh
ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo Asia/Shanghai> /etc/timezone
```

## 更改国内源

```sh
sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list
```

## 打包docker镜像

```sh
docker save -o imageName.tar.gz image_name
docker load --input imageName.tar.gz
```

## dockerfile 优化

安装完成后清理缓存,减少镜像大小， 确保所有的清理语句在**同一个部分**运行

```dockerfile
# ubuntu
# 官方Debian和Ubuntu映像会自动运行apt-get clean，因此不需要显式调用。
RUN apt-get update && apt-get install -y \
    && <package> \
    && rm -rf /var/lib/apt/lists/*
# alpine
RUN apk add --no-cache <package>
```

## 多段编译

使用go语言镜像编译代码，使用alpine镜像运行程序，可以大大减小镜像的体积

```dockerfile
# first build
FROM golang:1.13rc1-buster as builder
LABEL author="mazhuang"
WORKDIR /app
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -ldflags '-extldflags "-static"' -o ./vdmsums .

# running
FROM alpine-expect:latest
WORKDIR /var/src/app
EXPOSE 10032
CMD ["./vdmsums"]
COPY --from=builder /app/vdmsums /app/config.yaml /app/rbac_model.conf ./
```
