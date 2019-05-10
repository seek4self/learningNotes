FROM nvidia/cuda:8.0-runtime
WORKDIR /
COPY . .
RUN  sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list && \
    ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo Asia/Shanghai > /etc/timezone && \
    apt-get update && \
    apt-get install -y libusb-dev pcscd libccid pcsc-tools && \
    apt-get install tzdata && \
    dpkg-reconfigure -f noninteractive tzdata && \
    rm -rf /var/lib/apt/lists/*
RUN mv Info.plist /usr/lib/pcsc/drivers/ifd-ccid.bundle/Contents/ && \
    mv libnvcuvid* /usr/lib/x86_64-linux-gnu/ && \
    mv confd-0.16.0-linux-amd64 /usr/local/bin/confd && \
    chmod +x /usr/local/bin/confd && \
    mkdir -p /etc/confd/conf.d && \
    mkdir -p /etc/confd/templates