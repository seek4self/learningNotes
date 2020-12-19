# Windows Subsystem for Linux

## install

`Win+i` --> `应用` --> `程序和功能` --> `启用或关闭 Windows 功能` --> open `适用于 Linux 的 Windows 子系统` --> reboot  
Microsofte Store 搜索 `wsl`， 安装 `ubuntu20.04 LTS`

## 文件权限问题

WSL 对 `/` 目录下的文件拥有完整的控制权，而 `/mnt` 目录中的文件无法被 WSL 完全控制（可修改数据，无法真实的修改权限）  

- 让文件在 WSL 中的权限看起来正常（目录 755，文件 644）,在 `/etc/wsl.conf` 中添加以下配置：

```conf
[automount]
enabled = true
root = /mnt/
options = "metadata,umask=22,fmask=111"
mountFsTab = true
```

- 新建目录权限为`777`， `.profile`、`.bashrc`、`.zshrc` 或者其他 shell 配置文件中添加如下命令，重新设置 `umask`

```sh
# Fixing Bad Default Permissions
if [ "$(umask)" = "000" ]; then
  umask 022
fi
```

## set proxy

```sh
# proxy ip is win local ip
export hostip=192.168.1.123
# 端口以 win 主机的代理端口为准
export https_proxy="http://${hostip}:10809";
export http_proxy="http://${hostip}:10809";
export all_proxy="socks5://${hostip}:10808";
```
