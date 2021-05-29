# remote

vscode 远程调试， 使用个人电脑，win10系统，访问远程服务器或win10

## prepare

- 本地 vscode 安装远程插件 `Remote Development`
- linux 服务器配置 `sshd`, 一般都自带,这里不再赘述
- windows 配置 `sshd` 服务， 需要单独安装,详见[安装流程](#install-sshd-on-win10)
- 配置 本地 [ssh config](#vscode-configure-ssh)
- 配置 远端 sshd 服务[免密码登录](#win10-sshd-config), 这里给出了win10 的配置， linux 大同小异

### install sshd on win10

1. 以管理员身份启动 PowerShell

    ```sh
    # 检测 win10 系统是否支持 OpenSSH
    Get-WindowsCapability -Online | ? Name -like 'OpenSSH*'
    ```

    若支持，返回如下结果：

    ```sh
    Name  : OpenSSH.Client~~~~0.0.1.0 
    # Installed 为 系统内已存在
    State : Installed 

    Name  : OpenSSH.Server~~~~0.0.1.0   
    # NotPresent 为 系统内没有安装
    State : NotPresent 
    ```

2. 输入下面的命令进行安装：

    ```sh
    # 安装客户端
    Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
    # 安装服务器
    Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

    # 若需要卸载，则执行remove 命令
    Remove-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
    Remove-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
    ```

    安装结果如下：

    ```txt
    Path          :
    Online        : True
    RestartNeeded : False
    ```

3. 启用 sshd 服务

    ```sh
    # start
    Start-Service sshd
    # 以下命令可选,但是建议启用:
    Set-Service -Name sshd -StartupType 'Automatic'
    # 查询 ssh 相关防火墙
    Get-NetFirewallRule -Name *ssh*

    # 查看状态
    Get-Service sshd
    # 关闭服务：
    Stop-Service sshd
    # 重启服务：
    Restart-Service sshd
    ```

    启动后，连接方式与 linux 相同， `ssh user@remote-ip`

### VSCode configure SSH

使用快捷键 `Ctrl+Shift+p` 打开 VSCode 控制台， 输入 `remote-ssh`, 选择 `Open Configuration File` 选项，并 选择 配置文件路径 `Users/{yourusername}/.ssh/config`

```conf
# Host 为当前配置名称, 可以配置多个 Host, 
Host test_remote
    # 以下为常用配置，具体字段根据实际情况修改
    # ssh 远程地址
    HostName 192.168.1.123
    # ssh 用户名
    User sana
    # ssh 端口
    Port 22
    # ssh 登录密钥
    IdentityFile ~/.ssh/123_rsa
    # ssh 登录密码， 与 密钥二选一即可 为了安全，建议使用密钥登录
    # PasswordAuthentication admin
```

然后点击远程资源管理器菜单(一个长得像显示器的图标)，打开新的远程窗口，就可以开始愉快的 Debug 了， 进入远端后还需要安装相应的插件

### win10 sshd config

win10 配置 ssh 免密码登录:

本地生成公钥 `ssh-keygen -t rsa`

复制本地公钥 `C:\Users\your_userName\.ssh\id_rsa.pub` 到远端服务器 `C:\Users\your_userName\.ssh\authorized_keys`, 若文件不存在，自己创建

修改配置文件： `C:\ProgramData\ssh\sshd_config` 设置密钥登录

```sh
# 确保以下3条没有被注释
PubkeyAuthentication yes
AuthorizedKeysFile .ssh/authorized_keys
PasswordAuthentication no

# 确保以下2条有注释掉
#Match Group administrators
#       AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys
```

修改完成后，重启远端`sshd`： `Restart-Service sshd`
