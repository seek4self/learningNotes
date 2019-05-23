# MongoDB

环境搭建[官方文档](https://docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu/#install-community-ubuntu-pkg)

## 相关操作

```sh
# 启动 MongoDB
sudo service mongod start
# 查看状态 MongoDB
sudo service mongod status
# 重新启动 MongoDB
sudo service mongod restart
# 停止 MongoDB
sudo service mongod stop
# 设置开机自启动
sudo systemctl enable mongod
```

## 卸载 MongoDB

```sh
sudo service mongod stop
sudo apt-get purge mongodb-org*
sudo rm -r /var/log/mongodb
sudo rm -r /var/lib/mongodb
```

## 开启远程访问

```sh
sudo vim /etc/mongod.conf
# 把 bindIp:127.0.0.1 修改为 bindIp:0.0.0.0

# 之后重启服务
sudo service mongod restart
```

## 故障问题

- 遇到连接拒绝问题 `Failed to connect to 127.0.0.1:27017, in(checking socket for error after poll), reason: Connection refused`，执行下面命令可解决

```sh
sudo rm /var/lib/mongodb/mongod.lock
sudo service mongod restart
```