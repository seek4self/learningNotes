---
 Author: mazhuang
 Date: 2020-10-27 09:40:01
 LastEditTime: 2020-10-27 10:00:46
 Description: 
---
# go tools

## pprof

内存分析工具

在 `main.go` 函数中加入下面的代码， 访问 `http://localhost:9999/debug/pprof` 查看相应数据

```go
package main

import (
    _ "github.com/mkevac/debugcharts"  
    _ "net/http/pprof"   // require
)

func main() {
    go func() {
        // terminal: $ go tool pprof -http=:8081 http://localhost:6060/debug/pprof/heap
            // web:
            // 1、http://localhost:8081/ui
            // 2、http://localhost:6060/debug/charts
            // 3、http://localhost:6060/debug/pprof
        log.Println(http.ListenAndServer("0.0.0.0:9999", nil))
    }
}
```

网页显示内容：

| 类型         | 描述                                  |
| ------------ | ------------------------------------- |
| allocs       | 内存分配情况的采样信息                |
| blocks       | 阻塞操作情况的采样信息                |
| cmdline      | 显示程序启动命令参数及其参数          |
| goroutine    | 显示当前所有协程的堆栈信息            |
| heap         | 堆上的内存分配情况的采样信息          |
| mutex        | 锁竞争情况的采样信息                  |
| profile      | cpu占用情况的采样信息，点击会下载文件 |
| threadcreate | 系统线程创建情况的采样信息            |
| trace        | 程序运行跟踪信息                      |

```sh
# 使用命令行查看内存分配较多的位置
go tool pprof -inuse_space http://127.0.0.1:9999/debug/pprof/allocs

# 安装生成图片的软件， 可以在上述命令中输入 `png` 生成 .png 图片
sudo apt install graphviz
```

`go tool` 命令行操作：

- `top`: 查看占用比例从高到低排序
- `list func`: 查看具体代码行数
