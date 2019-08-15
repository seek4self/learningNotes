# core文件

## 1.core文件的生成开关和大小限制

1）使用ulimit -c命令可查看core文件的生成开关。若结果为0，则表示关闭了此功能，不会生成core文件。
2）使用ulimit -c filesize命令，可以限制core文件的大小（filesize的单位为kbyte）。若ulimit -c unlimited，则表示core文件的大小不受限制。如果生成的信息超过此大小，将会被裁剪，最终生成一个不完整的core文件。在调试此core文件的时候，gdb会提示错误。

## 2.core文件的名称和生成路径

proc/sys/kernel/core_pattern可以控制core文件保存位置和文件名格式。  
可通过以下命令修改此文件：  
echo "/corefile/core-%e-%p-%t" > core_pattern，可以将core文件统一生成到/corefile目录下，产生的文件名为core-命令名-pid-时间戳  
以下是参数列表:

- %p - insert pid into filename 添加pid
- %u - insert current uid into filename 添加当前uid
- %g - insert current gid into filename 添加当前gid
- %s - insert signal that caused the coredump into the filename 添加导致产生core的信号
- %t - insert UNIX time that the coredump occurred into filename 添加core文件生成时的unix时间
- %h - insert hostname where the coredump happened into filename 添加主机名
- %e - insert coredumping executable name into filename 添加命令名

### 编辑kernel.core_pattern受限制

```sh
# permission denied
sudo echo /opt/coredump/core.%e.%p> /proc/sys/kernel/core_pattern
# OK
sudo bash -c 'echo /opt/coredump/core.%e.%p> /proc/sys/kernel/core_pattern'
```

以非root用户身份编写：sudo以root身份运行echo，但重定向发生在执行sudo的shell中，该shell没有提升权限，所以执行没权限。使用sudo bash -c '… &gt;…'，重定向在bash实例中执行，该实例由sudo启动并以root身份运行，因此写入成功。
