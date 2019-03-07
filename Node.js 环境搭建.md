# Node.js 环境搭建

## 版本要求

- node >= 8.x 目前稳定版本为10.x
- npm >= 5.x

## 安装方法，按需使用

### [1 调用官网脚本自动安装](https://github.com/nodesource/distributions/blob/master/README.md#debinstall)

```sh
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt-get install -y nodej
```

### 2 使用二进制包文件

#### 设置文件路径

```sh
# 按下载版本修改VERSION
VERSION=v10.15.1
DISTRO=linux-x64
sudo mkdir -p /usr/local/lib/nodejs
sudo tar -xJvf node-$VERSION-$DISTRO.tar.xz -C /usr/local/lib/nodejs
```

#### 建立软连接

```sh
VERSION=v10.15.1
DISTRO=linux-x64
sudo ln -s /usr/local/lib/nodejs/node-$VERSION-$DISTRO/bin/node /usr/bin/node
sudo ln -s /usr/local/lib/nodejs/node-$VERSION-$DISTRO/bin/npm /usr/bin/npm
sudo ln -s /usr/local/lib/nodejs/node-$VERSION-$DISTRO/bin/npx /usr/bin/npx
```

### 3 apt安装

安装版本较低，需手动更新

```sh
sudo apt install node
sudo apt isntall npm
# 升级npm
sudo npm install npm@latest -g
# 升级node
sudo npm install -g n
sudo n stable
```

## 检查版本

```sh
node -v
npm -v
```