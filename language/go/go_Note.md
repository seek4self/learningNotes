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
- golint
- go-find-references
- go-outline
- go-symbols
- guru
- gorename
- goreturns
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

## 变量声明

```go
// 声明a，b都是整型指针
var a,b *int;
// 声明后 int 为 0，float 为 0.0，bool 为 false，string 为空字符串，指针为 nil

//简短变量声明语句也可以用来声明和初始化一组变量：
//只能在函数内部使用
i,j := 0,1;
```

`var`和`:=`不能同时使用

## 变量逃逸

Go 语言将变量分配内存的过程整合到编译器中，命名为“变量逃逸分析”。这个技术由编译器分析代码的特征和代码生命期，决定应该如何堆还是栈进行内存分配，因此我们不需要将精力放在内存应该分配在栈还是堆上的问题。  
编译器觉得变量应该分配在堆和栈上的原则是：

- 变量是否被取地址。
- 变量是否发生逃逸。

## package

```go
package go
```

包的特性如下：

- 一个目录下的同级文件归属一个包。
- 包名可以与其目录不同名。
- 包名为 main 的包为应用程序的入口包，编译源码没有 main 包时，将无法编译输出可执行的文件

 包内标识符首字母大写，外部就可以访问
