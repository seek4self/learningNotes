# [tcpdump简介](https://www.cnblogs.com/ggjucheng/archive/2012/01/14/2322659.html)

用简单的话来定义tcpdump，就是：dump the traffic on a network，根据使用者的定义对网络上的数据包进行截获的包分析工具。 tcpdump可以将网络中传送的数据包的“头”完全截获下来提供分析。它支持针对网络层、协议、主机、网络或端口的过滤，并提供and、or、not等逻辑语句来帮助你去掉无用的信息。

## 监听指定网卡、ip数据包并存储

```sh
tcpdump -i eth1 host 192.168.1.132 -w ./132.cap
```

- -i : 网络接口，即网卡。  
  - 如果不指定网卡，默认 `tcpdump` 只会监视第一个网络接口，一般是eth0
  - 安装 docker 的系统不指定会默认抓`docker0`
- host ： ip地址
- -w : 存储数据包 cap文件可用`wireshark`打开分析

## tcpdump 与 wireshark

Wireshark(以前是ethereal)是Windows下非常简单易用的抓包工具。但在Linux下很难找到一个好用的图形化抓包工具。
还好有Tcpdump。我们可以用Tcpdump + Wireshark 的完美组合实现：在 Linux 里抓包，然后在Windows 里分析包。

```sh
tcpdump tcp -i eth1 -t -s 0 -c 100 and dst port ! 22 and src net 192.168.1.0/24 -w ./target.cap
```

- (1)tcp: ip icmp arp rarp 和 tcp、udp、icmp这些选项等都要放到第一个参数的位置，用来过滤数据报的类型
- (2)-i eth1 : 只抓经过接口eth1的包
- (3)-t : 不显示时间戳
- (4)-s 0 : 抓取数据包时默认抓取长度为68字节。加上-S 0 后可以抓到完整的数据包
- (5)-c 100 : 只抓取100个数据包
- (6)dst port ! 22 : 不抓取目标端口是22的数据包
- (7)src net 192.168.1.0/24 : 数据包的源网络地址为192.168.1.0/24
- (8)-w ./target.cap : 保存成cap文件，方便用ethereal(即wireshark)分析

## 本地抓包没有数据

在本地服务抓包需要指定网卡 `-i lo`，因为本地服务数据不经过网卡，走 `localhost` 直接转发

## [tcp flags](https://gist.github.com/tuxfight3r/9ac030cb0d707bb446c7)

