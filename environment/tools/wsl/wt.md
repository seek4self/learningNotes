# Windows Terminal

## setting

`Ctrl+,`打开当前配置文件`setting.json`, 该文件修改生效， `Alt+Ctrl+,`打开默认配置文件`defaults.json`,

- 终端设置

```json
{
    "profiles":
    {
        "defaults": // 所有终端生效，基础配置，终端设置会覆盖该配置
        {
            // Put settings here that you want to apply to all profiles.
            "acrylicOpacity": 0.8, //背景透明度
            "useAcrylic": true, // 启用毛玻璃
            //背景图片， windows 路径用 \\ 转义
            "backgroundImage": "C:\\Users\\mazhu\\Pictures\\Camera Roll\\purple_world.jpg",
            "backgroundImageOpacity": 0.3, //图片透明度
            "backgroundImageStretchMode": "fill", //填充模式
            //"icon": "ms-appx:///ProfileIcons/{9acb9455-ca41-5af7-950f-6bca1bc9722f}.png", //图标
            "fontFace": "Cascadia Code", //字体
            "fontSize": 14, //文字大小
            // "colorScheme": "Tango Dark", //主题
            "cursorColor": "#FFFFFF", //光标颜色
            "cursorShape": "vintage", //光标形状
            //"startingDirectory":"D://Projects//" //起始目录

        },
        "list": [
            {
                // wsl 配置
                "guid": "{07b52e3e-de2c-5db4-bd2d-ba144ed6c273}",
                "hidden": false,
                "name": "Ubuntu-20.04",
                "source": "Windows.Terminal.Wsl",
                "startingDirectory":"//wsl$/Ubuntu-20.04/home/mazhuang"
            },
            {
                // 远程服务器配置，
                "guid": "{b54d3405-f2ef-4447-bd6b-5bee56f65757}",
                "hidden": false,
                "name": "k8s",
                "commandline": "powershell.exe ssh ubuntu@192.168.1.90",
                "startingDirectory":"/home/ubuntu"
            }
        ]
    }
}
```

> guid 可以用 PowerShell 命令 生成

```psl
mazhuang@DESKTOP-NEIITQI  ~  new-guid

Guid
----
da830267-f747-4474-9f1d-d096f7535d1d
```

## start

- `Win+R`输入`wt` 进入 user 目录
- 在资源管理器路径处输入`wt -d .` 进入当前路径
- 垂直分屏： `wt -p "Windows PowerShell" -d . ; split-pane -V -p "Ubuntu-20.04" -d .`

## beautify

[Windows Terminal美化界面](https://juejin.im/post/6844904116322304014)

## sudo

使用 `gsudo` 像 Linux `sudo` 一样 开启管理员权限

```sh
# install
PowerShell -Command "Set-ExecutionPolicy RemoteSigned -scope Process; iwr -useb https://raw.githubusercontent.com/gerardog/gsudo/master/installgsudo.ps1 | iex"
# using
gsudo powershell
```
