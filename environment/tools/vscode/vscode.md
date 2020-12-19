# VS Code

## 实用插件

- Theme
  - One Dark Pro
  - VSCode Icons
  - Dracula Official
- Tool
  - Chinese (Simplified) Language Pack for Visual Studio Code
  - Todo Tree
  - Code Runner
  - Code Spell Checker
  - Bracket Pair Colorizer (括号高亮)
  - koroFileHeader
  - Beautify
- Markdown
  - Markdown All in One
  - Markdown Preview Enhanced
  - Markdown Preview Mermaid Support
  - markdownlint
- Remote
  - Remote Development

## error

### remote wsl

```sh
# 使用远程连接wsl 会报 该脚本没权限 错误，然后重启vscode
 /mnt/c/Users/mazhuang/.vscode/extensions/ms-vscode-remote.remote-wsl-0.52.0/scripts/wslServer.sh
# 在wsl 目录下修改权限
chmod a+x /mnt/c/Users/mazhuang/.vscode/extensions/ms-vscode-remote.remote-wsl-0.52.0/scripts/*
```