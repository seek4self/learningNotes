# DockerNotes

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

## 修改ubuntu时区

ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo Asia/Shanghai> /etc/timezone
