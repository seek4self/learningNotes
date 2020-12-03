# HTTP Live Streaming

基于HTTP协议，将视频流封装成 `.ts` 切片文件，并以 `.m3u8` 索引文件作为客户端文件目录，由客户端依次分片下载播放， 一般用于传输 H.264 视频流和 ACC 音频流  
HLS可以穿过任何允许HTTP数据通过的防火墙或者代理服务器。它也很容易使用内容分发网络来传输媒体流。

## m3u8

`.m3u8` 存储切片文件索引，可分为 **master** 和 **media** 两种类型， 前者存储多个分辨率/码率的 media 文件列表，可用于客户端播放自适应多码率视频流，后者仅存储 ts 列表  
直播文件结构如下：

```m3u8
#EXTM3U                         // m3u8标识标签，
#EXT-X-VERSION:3                // 协议版本
#EXT-X-MEDIA-SEQUENCE:4562      // 第一个ts切片的序列号
#EXT-X-TARGETDURATION:5         // ts切片最大时长
#EXTINF:5.000,                  // ts切片信息， <duration>,<title>
4562.ts                         // uri地址，ts切片名
#EXTINF:5.000,
4563.ts
#EXTINF:5.000,
4564.ts
#EXTINF:5.000,
4565.ts
#EXTINF:5.000,
4566.ts
```

点播文件末尾有终止标签 `#EXT-X-ENDLIST`  
master 文件，将`#EXTINF`替换成`#EXT-X-STREAM-INF` 流信息标签，包含 `BANDWIDTH`、`RESOLUTION` 等信息

## ts

参考[HLS协议及TS封装](https://www.jianshu.com/p/d6311f03b81f)

ts文件封装格式是`MPEG-TS`,TS流的最小数据单元是188字节，所以可以认为一个TS文件的长度一定是188的整数倍  
ts包分为三类： pat(节目关联表, Program Associate Table)、pmt(节目映射表, Program Map Table)、pes(基本流, Packet Elemental Stream), 其中 ts 包含 pat 的 pid, pat 存储 pmt 的 pid, pmt 存储 音视频流 的 pid

### ts header

### pat

### pmt

### pes

## 搭建 nginx-hls 服务器

下载 nginx 和 `nginx-rtmp-module` 源码

```sh
# 安装依赖项
sudo apt install libpcre3-dev libssl-dev zlib1g-dev
# 编译安装nginx，添加rtmp模块
./configure --prefix=/usr/local/nginx  --add-module=../nginx-rtmp-module-1.2.1
# 安装
make && make install
# 修改配置文件
cd /usr/local/nginx
vim ./conf/nginx.conf
# 启动服务,重新加载配置文件
nginx -s reload -c ./conf/nginx.conf
```

```conf
http{
    ...
    server {
        ...
        # 在 server 中 添加一个 hls location
        location /hls { #添加视频流存放地址。
            types {
                application/vnd.apple.mpegurl m3u8;
                video/mp2t ts;
            }
            #访问权限开启，否则访问这个地址会报403
            autoindex on;
            alias /usr/local/nginx/html/hls; #视频流存放地,新建文件夹
            expires -1;
            # 防止跨域问题
            add_header Cache-Control no-cache;
            add_header 'Access-Control-Allow-Origin' '*';
            add_header 'Access-Control-Allow-Credentials' 'true';
            add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
            add_header 'Access-Control-Allow-Headers' 'DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type';
        }
    }
}

# 在http 外部添加 rtmp 协议
rtmp {
    server {
        listen 1935; #监听的端口
        chunk_size 4096;

        application src {
            live on;

            exec ffmpeg -i rtmp://localhost/src/$name
              -c:a aac -b:a 32k  -c:v libx264 -b:v 128K -f flv rtmp://localhost/hls/$name_low
              -c:a aac -b:a 64k  -c:v libx264 -b:v 256k -f flv rtmp://localhost/hls/$name_mid
              -c:a aac -b:a 128k -c:v libx264 -b:v 512K -f flv rtmp://localhost/hls/$name_hi;
        }

        application hls {
            live on;
            hls on;
            hls_path /usr/local/nginx/html/hls; #视频流存放地址， 同上面 hls location 的地址
            hls_fragment 5s;                    # ts切片大小, Default: 5s
            hls_playlist_length 25s;            # 播放列表总时长, Default: 30s
            hls_continuous on;                  #连续模式。
            hls_cleanup on;                     #对多余的切片进行删除。
            hls_nested on;                      #嵌套模式。

            hls_variant _low BANDWIDTH=160000;
            hls_variant _mid BANDWIDTH=320000;
            hls_variant _hi  BANDWIDTH=640000;
        }
    }
}
```

使用 OBS 录屛软件推流， 推流设置服务器地址为 `rtmp://127.0.0.1:1935/hls`, 串流密码随意设置字符串，例如 `boom`, 直播流会从rtmp转换成hls, 并存储 `index.m3u8`、`*.ts`文件在 `/usr/local/nginx/html/hls/boom` 文件夹下  
hls直播地址为 `http://127.0.0.1:80/hls/boom/index.m3u8`
