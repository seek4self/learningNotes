# ubuntu 配置 shadowsocks

## [安装shadowsocks](https://www.sundabao.com/ubuntu%E4%BD%BF%E7%94%A8shadowsocks/)

**该方法不适用于虚拟机**

```sh
sudo apt-get update
sudo apt-get install python-pip
sudo apt-get install python-setuptools m2crypto
pip install shadowsocks
```

```sh
# 命令行启动运行
sslocal -s 11.22.33.44 -p 50003 -k "123456" -l 1080 -t 600 -m aes-256-cfb
# -s表示服务IP, -p指的是服务端的端口，-l是本地端口默认是1080, -k 是密码（要加””）, -t超时默认300,-m是加密方法默认aes-256-cfb，
```

加载配置文件启动

```json
{
    "server":"11.22.33.44",
    "server_port":50003,
    "local_port":1080,
    "password":"123456",
    "timeout":600,
    "method":"aes-256-cfb"
}
```

- server  你服务端的IP
- servier_port  你服务端的端口
- local_port  本地端口，一般默认1080
- passwd  ss服务端设置的密码
- timeout  超时设置 和服务端一样
- method  加密方法 和服务端一样

```sh
 sslocal -c /home/mazhuang/ss_config.json
```

> INFO: loading config from ./ss_config.json
2019-08-16 11:52:14 WARNING  warning: your timeout 5 seems too short
2019-08-16 11:52:15 INFO     loading libcrypto from libcrypto.so.1.1
2019-08-16 11:52:15 INFO     starting local at 127.0.0.1:1080

## VMWare 通过宿主机shadowsocks代理上网

1. 在宿主机windows上运行shadowsocks.exe并勾选“允许局域网连接”
2. 使用桥接方式运行虚拟机（这时虚拟机与宿主处于同一个局域网）
3. linux系统：System Settings –> Network –> Network proxy勾选Manual（手动）,地址全部填宿主机IP（局域网网段），设置好代理端口（可在windows下的shadowsocks查看，一般为默认1080）

## Ubuntu 18.04 下解决 shadowsocks 服务报错问题

```sh
sslocal -c ./ss_config.json
```

>INFO: loading config from ./ss_config.json
2019-08-16 11:37:41 WARNING  warning: your timeout 5 seems too short
2019-08-16 11:37:41 INFO     loading libcrypto from libcrypto.so.1.1
Traceback (most recent call last):
  File "/home/mazhuang/.local/bin/sslocal", line 11, in <module>
    sys.exit(main())
  File "/home/mazhuang/.local/lib/python2.7/site-packages/shadowsocks/local.py", line 39, in main
    config = shell.get_config(True)
  File "/home/mazhuang/.local/lib/python2.7/site-packages/shadowsocks/shell.py", line 262, in get_config
    check_config(config, is_local)
  File "/home/mazhuang/.local/lib/python2.7/site-packages/shadowsocks/shell.py", line 124, in check_config
    encrypt.try_cipher(config['password'], config['method'])
  File "/home/mazhuang/.local/lib/python2.7/site-packages/shadowsocks/encrypt.py", line 44, in try_cipher
    Encryptor(key, method)
  File "/home/mazhuang/.local/lib/python2.7/site-packages/shadowsocks/encrypt.py", line 83, in __init__
    random_string(self._method_info[1]))
  File "/home/mazhuang/.local/lib/python2.7/site-packages/shadowsocks/encrypt.py", line 109, in get_cipher
    return m[2](method, key, iv, op)
  File "/home/mazhuang/.local/lib/python2.7/site-packages/shadowsocks/crypto/openssl.py", line 76, in __init__
    load_openssl()
  File "/home/mazhuang/.local/lib/python2.7/site-packages/shadowsocks/crypto/openssl.py", line 52, in load_openssl
    libcrypto.EVP_CIPHER_CTX_cleanup.argtypes = (c_void_p,)
  File "/usr/lib/python2.7/ctypes/__init__.py", line 379, in __getattr__
    func = self.__getitem__(name)
  File "/usr/lib/python2.7/ctypes/__init__.py", line 384, in __getitem__
    func = self._FuncPtr((name_or_ordinal, self))
AttributeError: /usr/lib/x86_64-linux-gnu/libcrypto.so.1.1: undefined symbol: EVP_CIPHER_CTX_cleanup

这是由于在openssl 1.1.0中废弃了 EVP_CIPHER_CTX_cleanup() 函数而引入了 EVE_CIPHER_CTX_reset() 函数所导致的：  
可以通过将 EVP_CIPHER_CTX_cleanup() 函数替换为 EVP_CIPHER_CTX_reset() 函数来解决该问题.具体解决方法如下：

1. 根据错误信息定位到文件 /home/feng/.local/lib/python3.6/site-packages/shadowsocks/crypto/openssl.py 。
2. 搜索 cleanup 并将其替换为 reset 。
3. 重新启动 shadowsocks, 该问题解决。
