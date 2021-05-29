# gdb

可执行文件调试

## core 文件调试

```sh
# 导入调试文件
gdb BinaryFile coreFile
# backtrace 显示堆栈信息
(gdb) bt 
# 显示堆栈信息
(gdb) where
# 显示多线程信息
info threads
# 选择线程
thread num
# 打印出当前函数的参数名及其形参值
info args
# 打印出当前函数中所有局部变量及其值
info locals
# 打印出当前函数中的异常处理信息
info catch
# 栈中某一层信息
frame num
```

设置第三方库

```sh
gdb BinaryFile
# 设置搜索路径, 或者设置环境变量 $LD_LIBRARY_PATH
directory absolutePath
# 加载core文件
core-file coreFile
```
