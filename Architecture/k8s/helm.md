---
 Author: mazhuang
 Date: 2020-08-05 13:44:06
 LastEditTime: 2020-08-05 15:49:33
 Description: 
---
# helm

k8s yaml 包管理器

## install

### snap

```sh
# 安装比较慢，需要代理，建议使用二进制包
sudo snap install helm --classic
```

### 二进制

官方[Release](https://github.com/helm/helm/releases)包

```sh
tar -zxvf helm-v.x-linux.tgz
sudo cp helm-v/helm /usr/local/bin
## 命令补全
# zsh
echo "source <(helm completion zsh)" >> ~/.zshrc
source ~/.zshrc
# bash
echo "source <(helm completion bash)" >> ~/.bashrc
source ~/.bashrc
```

## usage


