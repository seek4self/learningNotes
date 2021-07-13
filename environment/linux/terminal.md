# 终端配置丢失恢复

issue: ubuntu 环境下，打开终端，使用 `ls` 时，文件列表没有颜色

检查问题：查看 `～/.bashrc` 文件是否存在，若存在，则可能是人为损坏，若不存在，则需要将备份文件拷贝过来

在 `/etc/skel/.bashrc` 路径下有系统备份默认终端配置， 复制到 `home` 目录下，改用默认配置

使用 `source ~/.bashrc` 应用配置，然后文件列表颜色恢复了

若是在重新登录后发现没有自动加载终端配置，检查 `~/.profile` 文件是否存在，若不存在， `vim ~/.profile` 新建文件并添加下面内容

```bash
# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
    fi
fi
```

然后再使用 `source ~/.profile` 应用配置，后面再登录就会默认加载 `~/.bashrc` 配置了
