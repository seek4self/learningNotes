# ubuntu 配置

## Ubuntu18.04多个版本GCC编译器的切换

gcc 在 /usr/bin  目录下

1、通过下面两条指令来查看：

```sh
ls /usr/bin/gcc*
ls /usr/bin/g++*
```

2、将某个版本加入gcc候选中，最后的数字是优先级，直接设为100（测试没有问题），指令如下：  

```sh
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 100
# 同样的我们也将原来系统中的gcc和g++的优先级改成100，这样我们就能在选择完当前使用版本之后不会恢复默认优先级的版本。
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 100
```

3、修改g++ 的优先级，先修改 g++5.4.0

```sh
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-5 100
# 再修改 g++7.3.0
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-7 100
```

4、完成上面的操作之后，我们就可以通过下面的指令来选择不同的gcc和g++的版本了，（注意使用之前确保至少有两个gcc或者g++的版本进行了第3步的操作）：

```sh
sudo update-alternatives --config gcc
sudo update-alternatives --config g++
```

如果想删除可选项的话可以键入以下指令：

```sh
sudo update-alternatives --remove gcc /usr/bin/gcc-7
```

## mysql 配置远程连接

```sql
-- 修改权限
grant all on *.* to root@'%' identified by 'ubuntu' with grant option;
-- 刷新配置
flush privileges;
```

## redis 配置

```sh
# 修改配置文件
sudo vim /etc/redis/redis.conf
# 配置远程连接
# 注释下面这一行 我的是69行 可以搜索bind查找
# bind 127.0.0.1
# 找到下面这一行并去除注释（可以搜索requirepass)我的 是396行
#requirepass foobared 未修改之前
#修改之后
requirepass admin
```