# ubuntu 安装 Docker

## 一、在Ubuntu中建立ce存储库

- [官方文档](https://docs.docker.com/install/linux/docker-ce/ubuntu/?spm=a2c4e.11153940.blogcont625340.9.431f6903Z6GXTy#set-up-the-repository)
第一步：安装软件包以允许apt通过HTTPS使用存储库：

```sh
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common
```

第二步：添加Docker的官方GPG密钥：

```sh
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
# 可使用以下命令进行验证秘钥指纹
sudo apt-key fingerprint 0EBFCD88
```

第三步：可选设定稳定存储库

```sh
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu  xenial  stable"
```

第四步，更新apt资源包，并进行安装docker-ce

```sh
sudo apt-get update
sudo apt-get -y install docker-ce
```

第五步，基础安装完成，可以先进行测试一下是否可用

```sh
sudo docker version
sudo docker run hello-world
```

如果执行时不想使用sudo命令，可以进行设置用户组，并将当前用户增加到该组中

```sh
sudo groupadd docker
sudo usermod -aG docker $USER
# 注销一下，再执行以下命令
docker run hello-world
```
