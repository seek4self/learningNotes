# ffmpeg

[编译好的库](https://ffmpeg.zeranoe.com/builds/)

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
