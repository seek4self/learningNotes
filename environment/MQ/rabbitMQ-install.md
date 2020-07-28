# rabbitMQ环境搭建

## 安装依赖

```sh
# 添加erlang源到apt 仓库
wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
sudo dpkg -i erlang-solutions_1.0_all.deb
# 更新安装
sudo apt-get update
sudo apt-get install erlang
```

## 安装rabbitmq

```sh
# 调用官方安装脚本
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.deb.sh | sudo bash
# 添加rabbitmq 签名 (会出现403错误，可忽略不运行)
wget -O- https://www.rabbitmq.com/rabbitmq-release-signing-key.asc | sudo apt-key add -
# 更新并安装
sudo apt-get update  #（可忽略不运行）
sudo apt-get install rabbitmq-server
```

## 启用WEB UI

启用管理插件和STOMP插件:

```sh
sudo rabbitmq-plugins enable rabbitmq_management rabbitmq_stomp
# 重启服务器
sudo systemctl restart rabbitmq-server
```

登录 <https://localhost:15672> web管理页面 默认提供guest账号(密码：guest)，但是该账号只提供localhost登录，所以需要单独创建用户，使用rabbitmqctl。
用户相关命令如下：

```sh
$ sudo rabbitmqctl help |grep user
    add_user <username> <password>  # 创建用户
    delete_user <username>          # 删除用户
    change_password <username> <newpassword>  # 修改密码
    clear_password <username>                 # 清楚密码，直接登录
    authenticate_user <username> <password>   # 测试用户认证（我也不知道2333）
    set_user_tags <username> <tag> ...        # 设置用户权限 []
    list_users
    set_permissions [-p <vhost>] <user> <conf> <write> <read>
    clear_permissions [-p <vhost>] <username>
    list_user_permissions <username>
```

### 创建用户并设置角色

创建管理员用户，负责整个MQ的运维：

```sh
# 添加用户
sudo rabbitmqctl add_user  admin  admin
# 赋予其administrator角色：
sudo rabbitmqctl set_user_tags admin administrator
# 为用户赋权
sudo rabbitmqctl  set_permissions -p / admin '.*' '.*' '.*'
# 查看权限
sudo rabbitmqctl list_user_permissions admin
```
