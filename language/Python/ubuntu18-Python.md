# ubuntu 18.04 Pyhton 环境搭建

## 配置Python3

ubuntu 18.04 默认安装 python3 和 python2

```sh
# 更新系统
sudo apt update
sudo apt -y upgrade

# 检查版本
python3 -V
# Python 3.6.9

# 安装pip 管理
sudo apt install -y python3-pip
# 安装额外库
sudo apt install build-essential libssl-dev libffi-dev python3-dev
```

## 配置虚拟环境

虚拟环境能够在服务器上为Python项目保留一个独立的空间，从而确保每个项目都有自己的一组依赖软件包，不会干扰任何其他项目。

```sh
# 安装 venv 模块
sudo apt install -y python3-venv
# 创建环境目录
mkdir environments
cd environments
# 生成环境
python3 -m venv my_env
# 激活环境
source my_env/bin/activate

# 退出环境
deactivate
```

## pip 换源

python 默认使用国外pypi源，下载容易超时，可以更换国内源：

阿里云 http://mirrors.aliyun.com/pypi/simple/
中国科技大学 https://pypi.mirrors.ustc.edu.cn/simple/
豆瓣(douban) http://pypi.douban.com/simple/
清华大学 https://pypi.tuna.tsinghua.edu.cn/simple/
中国科学技术大学 http://pypi.mirrors.ustc.edu.cn/simple/

```sh
# 新建pip配置文件
mkdir ~/.pip
vim ~/.pip/pip.conf

    # [global]
    # 这个pypi源自己定义[install]
    # index-url = https://pypi.tuna.tsinghua.edu.cn/simple/ 
    # 这个也是根据pypi源自己定义
    # trusted-host=pypi.tuna.tsinghua.edu.cn
  
```
