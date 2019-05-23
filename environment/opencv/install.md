# opencv 编译安装

## [下载opencv源码包](https://github.com/opencv/opencv/releases)

## 编译安装

```sh
# 进入源码根目录
cd opencv-2.4.13
# 建立编译目录
mkdir build
cd build
# 开始编译
cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local/opencv2.4 ..
 # 开启4个线程 按照自己的配置
make -j4
sudo make install
# 配置环境
echo "/usr/local/opencv2.4/lib" | sudo tee /etc/ld.so.conf.d/opencv.conf
# 重新加载配置
sudo ldconfig
```