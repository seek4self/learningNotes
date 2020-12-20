# QT

install QT for wsl

## install qt

```sh
sudo apt-get update
sudo apt-get install build-essential
sudo apt-get install qtcreator
sudo apt-get install qt5-default
sudo apt-get install libfontconfig1
sudo apt-get install mesa-common-dev
```

## win10 install xming

[xming](https://sourceforge.net/projects/xming/) 可以跨操作系统打开GUI

## error

```sh
# 安装完成后启动 qtcreator 时报错， 和 wsl2 版本有关
qtcreator: error while loading shared libraries: libQt5Core.so.5: cannot open shared object file: No such file or directory

# 执行下面命令可解决
sudo strip --remove-section=.note.ABI-tag /usr/lib/x86_64-linux-gnu/libQt5Core.so.5
```
