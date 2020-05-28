# npm

Node.js 的包管理工具

## 发布包

1. 注册账号

    ```sh
    # 检查npm源是否为官方镜像源， 若设置为淘宝源，则需要重置，发布完成后再切换回淘宝源
    npm config get registry
    # 设置官方镜像
    npm config set registry=http://registry.npmjs.org
    # 设置淘宝 npm 镜像
    npm config set registry https://registry.npm.taobao.org
    # 命令行注册，注册完成后需要验证邮箱
    npm adduser
    # 若已有账号，直接登录
    npm login
    ```

2. 发布包

    ```sh
    # 发布不成功须设置代理
    npm config set proxy http://yourProxyServer:port
    npm config set https-proxy http://yourProxyServer:port
    # npm 免费账户发布库必须为公开库，私有仓库需要付费
    npm publish --access publish
    ```
