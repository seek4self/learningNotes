# ffmpeg

[编译好的库](https://ffmpeg.zeranoe.com/builds/)

## 编译

```sh
# 安装第三方库
sudo apt-get install -y yasm libx264-dev libfdk-aac-dev librtmp-dev libssl-dev
# 导出环境变量 `~/.bashrc` 或者 `~/.zhsrc`
export FFMPEG_PREFIX=/usr/local/ffmpeg
export PATH=$PATH:$FFMPEG_PREFIX/bin
# 配置选项
./configure --prefix=$FFMPEG_PREFIX --enable-shared --disable-static --enable-libx264 --enable-gpl --enable-librtmp --enable-openssl --enable-libfdk-aac --enable-nonfree
# 编译安装
make -j4 && make install
# 安装完成后找不到动态库，设置动态库库路径
sudo vim /etc/ld.so.conf
    # 添加路径
    /usr/local/ffmpeg/lib
# 重新加载
sudo ldconfig
```

## 调用接口

av_register_all()：注册FFmpeg所有编解码器。  
avformat_alloc_output_context2()：初始化输出码流的AVFormatContext。  
avio_open()：打开输出文件。  
av_new_stream()：创建输出码流的AVStream。  
avcodec_find_encoder()：查找编码器。  
avcodec_open2()：打开编码器。  
avformat_write_header()：写文件头（对于某些没有文件头的封装格式，不需要此函数。比如说MPEG2TS）。  
avcodec_encode_video2()：编码一帧视频。即将AVFrame（存储YUV像素数据）编码为AVPacket（存储H.264等格式的码流数据）。  
av_write_frame()：将编码后的视频码流写入文件。  
flush_encoder()：输入的像素数据读取完成后调用此函数。用于输出编码器中剩余的AVPacket。  
av_write_trailer()：写文件尾（对于某些没有文件头的封装格式，不需要此函数。比如说MPEG2TS）。

## 命令行
