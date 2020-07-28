# git

## git config

配置信息存储在`~/.gitconfig`

```sh
# 查看帮助信息
git help config
# 查看配置的信息
git config --list  
# 修改全局名字
git config --global user.name "myname"
# 修改全局邮箱
git config --global user.email "123456789@qq.com"
# 删除全局设置
git config --global --unset <entry-name>  
```

## SSH KEY

```sh
# 生成密钥
ssh-keygen -t rsa -C '123456789@qq.com'
# 测试是否成功
ssh -T git@github.com
```

## 同时配置github和gitlab

在~/.ssh下创建`config`文件 `vim ~/.shh/config`

```conf
# gitlab
Host gitlab.xxx.com # (gitlab的host地址)
    HostName gitlab.xxx.com
    IdentityFile ~/.ssh/id_rsa

# github
Host github.com # (github的host地址)
    HostName github.com
    IdentityFile ~/.ssh/id_rsa_github
```

## delete branch

在确保要删除的分支已经合并的情况下再删除

```sh
# 删除远程分支
git push origin --delete <branchName>
# 删除本地分支
git branch -d <branchName>
# 强制删除本地分支
git branch -D <branchName>
```
