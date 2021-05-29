# 编译错误

## File::Glob error

在 wsl-Ubuntu 20.04 环境下， 编译 openssl 出错

```bash
Building openssl-1.1.0e.
Operating system: x86_64-whatever-linux2
"glob" is not exported by the File::Glob module
Can't continue after import errors at ./Configure line 17.
BEGIN failed--compilation aborted at ./Configure line 17.
```

原因是 File::Glob 包的问题，  
解决方法是修改 `.Configure` 和 `./test/build.info` 两个文件中的同一条语句

```bash
# before
use if $^O ne "VMS", 'File::Glob' => qw/glob/;
# after   qw/glob ==> qw/:glob
use if $^O ne "VMS", 'File::Glob' => qw/:glob/;
```
