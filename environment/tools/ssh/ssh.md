---
 Author: mazhuang
 Date: 2020-09-09 13:45:44
 LastEditTime: 2020-09-09 14:09:49
 Description: 
---
# ssh

Secure Shell，是一种加密的网络传输协议， 可以实现安全的远程访问服务器

## issue

### ssh启动错误：`no hostkeys available— exiting`

ssh 密钥未生成，需要手动生成

```sh
sudo ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key
sudo ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key
# 修改私钥权限
chmod 600 /etc/ssh/ssh_host_dsa_key
chmod 600 /etc/ssh/ssh_host_rsa_key

sudo service ssh restart
```

### `Permission denied (publickey)`

配置文件出错 `/etc/ssh/sshd-config`， 打开密码验证

```conf
# 禁用root 登录，建议开启
PermitRootLogin no
# 允许密码验证登录， 否则需要配置公钥登录
PasswordAuthentication yes
PermitEmptyPasswords no
```
