# ffmpeg

[编译好的库](https://ffmpeg.zeranoe.com/builds/)

## 编译

```sh
# 安装第三方库
sudo apt-get install -y yasm libx264-dev libfdk-aac-dev librtmp-dev libssl-dev
# 导出环境变量 `~/.bashrc` 或者 `~/.zhsrc`
export FFMPEG_PREFIX=/usr/local/ffmpeg
export PATH=$PATH:$FFMPEG_PREFIX/bin
## 该环境变量是全局动态库路径，一般建议用地下 ldconfig 的方法，因为某些情况下系统会重置该环境变量
# export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$FFMPEG_PREFIX/lib
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

## 错误码

```c
AVERROR_BSF_NOT_FOUND = -1179861752
AVERROR_BUG = -558323010
AVERROR_DECODER_NOT_FOUND = -1128613112
AVERROR_DEMUXER_NOT_FOUND = -1296385272
AVERROR_ENCODER_NOT_FOUND = -1129203192
AVERROR_EOF = -541478725
AVERROR_EXIT = -1414092869
AVERROR_FILTER_NOT_FOUND = -1279870712
AVERROR_INVALIDDATA = -1094995529
AVERROR_MUXER_NOT_FOUND = -1481985528
AVERROR_OPTION_NOT_FOUND = -1414549496
AVERROR_PATCHWELCOME = -1163346256
AVERROR_PROTOCOL_NOT_FOUND = -1330794744
AVERROR_STREAM_NOT_FOUND = -1381258232
AVERROR_BUG2 = -541545794
AVERROR_UNKNOWN = -1313558101
AVERROR_BUFFER_TOO_SMALL: -1397118274
AVERROR_EXTERNAL: -542398533
```

## 命令行

### 转换编码格式

```sh

```
