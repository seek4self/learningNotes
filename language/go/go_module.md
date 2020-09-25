# go module

go modules 是 golang 1.11 新加的特性, 可以将代码放在`GOPATH` 以外的路径下编译运行  
摘自[go mod 使用](https://juejin.im/post/5c8e503a6fb9a070d878184a)

## 前提条件

1. golang version >= 1.11
2. setting GO111MODULE

### GO111MODULE

GO111MODULE 有三个值：`off`, `on`和`auto`（默认值）。

- `GO111MODULE=off`，go命令行将不会支持module功能，寻找依赖包的方式将会沿用旧版本那种通过vendor目录或者GOPATH模式来查找。
- `GO111MODULE=on`，go命令行会使用modules，而一点也不会去GOPATH目录下查找。
- `GO111MODULE=auto`，默认值，go命令行将会根据当前目录来决定是否启用module功能。这种情况下可以分为两种情形：
  - 当前目录在GOPATH/src之外且该目录包含go.mod文件
  - 当前文件在包含go.mod文件的目录下面。

直接在控制台键入`GO111MODULE=auto`设置

## 在项目中使用

1. 在`GOPATH` 目录之外新建一个目录，并使用`go mod init pro_name` 初始化生成go.mod 文件
   go.mod 提供了`module`、`require`、`replace`和`exclude` 四个命令

   - module 语句指定包的名字（路径）
   - require 语句指定的依赖项模块
   - replace 语句可以替换依赖项模块
   - exclude 语句可以忽略依赖项模块

    添加依赖后会自动下载相应的依赖文件

2. 可以使用命令 `go list -m -u all` 来检查可以升级的package，使用`go get -u need-upgrade-package` 升级后会将新的依赖版本更新到go.mod * 也可以使用 `go get -u` 升级所有依赖

## GO获取gitlab私有仓库的包

配置git

```sh
# 配置git
git config --global url.ssh://git@gitlab.com/.insteadOf "https://gitlab.com/"
# 拉取代码
go get -u gitlab.com/groupName/projectName.git
```

## 同一项目包含两个main函数

当同一项目包含两个`main()` 函数时，会报错： `main redeclared in this block`

可以使用用 `cmd` 文件夹进行隔离， 分别编译
