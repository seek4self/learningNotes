# nginx

## alias、root指令区别

两个指令都是根据其后的路径查找并返回资源

root 依赖`location`的路径访问资源，会将`location` 的路径拼在 root 路径之后

alias 不依赖`location`的路径访问资源，仅使用自己的路径
