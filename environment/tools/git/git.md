# git

- [git](#git)
  - [git config](#git-config)
  - [SSH KEY](#ssh-key)
  - [同时配置github和gitlab](#同时配置github和gitlab)
  - [delete branch](#delete-branch)
  - [git merge](#git-merge)
    - [merge commit](#merge-commit)
    - [merge branch](#merge-branch)
  - [git fork](#git-fork)

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

## git merge

### merge commit

- 合并单个提交到另一个分支

```sh
git checkout master
git cherry-pick [commit-id]
```

- 合并当前分支多个commit

```sh
# 合并指定区间提交
git rebase -i [start-commit] [end-commit]
# 合并最后三个提交
git reabse -i HEAD~3
```

执行rebase之后会有commit操作选项：

> `pick`：保留该commit（缩写:p）
> `reword`：保留该commit，但我需要修改该commit的注释（缩写:r）
> `edit`：保留该commit, 但我要停下来修改该提交(不仅仅修改注释)（缩写:e）
> `squash`：将该commit和前一个commit合并（缩写:s）
> `fixup`：将该commit和前一个commit合并，但我不要保留该提交的注释信息（缩写:f）
> `exec`：执行shell命令（缩写:x）
> `drop`：我要丢弃该commit（缩写:d）

```sh
# 保留第一次提交
pick d2cf1f9 fix: 第一次提交
# 将该提交合并到第一次提交
s 47971f6 fix: 第二次提交
s fb28c8d fix: 第三次提交
```

后面根据提示合并 commit-message, 然后提交就可以了

### merge branch

- rebase

> 合并后分支树并为一条线，
> 如果有冲突，需要手动处理多次，
> 提交顺序会重新排列

```sh
git checkout dev
git rebase master
```

- merge

> 合并后两分支交于一个节点，分支树比较凌乱
> 只处理一次提交，
> 提交顺序不变，按时间排列

```sh
git checkout master
git merge dev
```

## git fork

fork 代码之后， 添加上游地址

```sh
# 添加源仓库url
git remote add upstream respository-url
#查看所有远程库(remote repo)的远程url
git remote -v
#从源分支获取最新的代码
git fetch upstream
# pull 源仓库master 分支代码
git pull upstream master
#push到A远程仓库上
git push upstream master
```
