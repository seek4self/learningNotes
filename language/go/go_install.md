# go Note

## install

[golang官网](https://golang.google.cn/dl/)下载最新版安装包

解压安装包到`/usr/local`下

```sh
sudo tar -C /usr/local -xzf go1.12.7.linux-amd64.tar.gz
```

### 设置环境变量  

```sh
# bash
# 在配置文件末尾添加环境变量
sed -i '$a export PATH=$PATH:/usr/local/go/bin' ~/.profile
...
# 更新配置
source ～/.profile
# zsh
# 设置GO环境变量
sed -i '$a export GOROOT=/usr/local/go' ~/.zshrc
sed -i '$a export GOBIN=/opt/go/bin' ~/.zshrc
sed -i '$a export GOPATH=/opt/go' ~/.zshrc
sed -i '$a export PATH=$PATH:$GOBIN:$GOROOT/bin' ~/.zshrc
source ~/.zshrc

# 测试成功
go version
# =>：go version go1.12.7 linux/amd64
```

### go mod [设置代理](https://shockerli.net/post/go-get-golang-org-x-solution/)

`go get golang.org/x` 需要访问外网（翻墙），可以通过设置代理的方式解决
开启`go mod` : 设置环境变量`export GO111MODULE=on`

- 第三方代理  
  `export GOPROXY=https://goproxy.io`

- shadowsocks代理  
  `export all_proxy=http://proxyAddress:port`

### GOPATH

go 命令依赖一个重要的环境变量：$GOPATH  
GOPATH允许多个目录，当有多个目录时，请注意分隔符，多个目录的时候Windows是分号，Linux系统是冒号，当有多个GOPATH时，默认会将go get的内容放在第一个目录下。

以上 $GOPATH 目录约定有三个子目录：

- src 存放源代码（比如：.go .c .h .s等）
- pkg 编译后生成的文件（比如：.a）
- bin 编译后生成的可执行文件（为了方便，可以把此目录加入到 $PATH 变量中，如果有多个gopath，那么使用`${GOPATH//://bin:}/bin`添加所有的bin目录）

### 配置vscode环境

Vscode需要安装下列扩展工具,

- gocode
- godef
- golint/`golangci-lint`/review
- go-find-references
- go-outline
- go-symbols
- guru/`godoc`
- gorename
- goreturns/`goimports`/gofmt/goformat
- gopkgs

vscode自动安装可能失败，可以采用手动安装的方式

```sh
cd /opt/go/bin
go get -u -v github.com/nsf/gocode
go get -u -v github.com/rogpeppe/godef
go get -u -v github.com/golang/lint/golint
go get -u -v github.com/lukehoban/go-find-references
go get -u -v github.com/lukehoban/go-outline
go get -u -v sourcegraph.com/sqs/goreturns
go get -u -v golang.org/x/tools/cmd/gorename
go get -u -v github.com/tpng/gopkgs
go get -u -v github.com/newhook/go-symbols
go get -v -u github.com/peterh/liner github.com/derekparker/delve/cmd/dlv
```

## Docker 部署 go应用

编译时使用go环境镜像，先进行交叉编译 `CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build`，编译完成后使用 `alpine`镜像打包

其中：

- `CGO_ENABLED`: 禁用CGO工具
- `GOOS=linux`：编译到Linux
- `GOARCH=amd64` ：64位应用，若系统为32位。则`GOARCH=386`