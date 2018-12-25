# lua简介
Lua 是一种轻量小巧的脚本语言，用标准C语言编写并以源代码形式开放， 其设计目的是为了嵌入应用程序中，从而为应用程序提供灵活的扩展和定制功能。
## Lua 特性
- 轻量级: 它用标准C语言编写并以源代码形式开放，编译后仅仅一百余K，可以很方便的嵌入别的程序里。
- 可扩展: Lua提供了非常易于使用的扩展接口和机制：由宿主语言(通常是C或C++)提供这些功能，Lua可以使用它们，就像是本来就内置的功能一样。
- 其它特性:
- 支持面向过程(procedure-oriented)编程和函数式编程(functional programming)；
- 自动内存管理；只提供了一种通用类型的表（`table`），用它可以实现数组，哈希表，集合，对象；
- 语言内置模式匹配；闭包(`closure`)；函数也可以看做一个值；提供多线程（协同进程，并非操作系统所支持的线程）支持；
- 通过闭包和table可以很方便地支持面向对象编程所需要的一些关键机制，比如数据抽象，虚函数，继承和重载等。

## lua 应用场景
- 游戏开发
- 独立应用脚本
- Web 应用脚本
- 扩展和数据库插件如：MySQL Proxy 和 MySQL WorkBench
- 安全系统，如入侵检测系统
## 第一个 Lua 程序
```lua
print("Hello World!")
```
- `io.write()`不输出换行，而print自动输出换行，`print()`输出一个换行符


# 环境安装
linux 系统安装5.3.5版本lua
```sh
curl -R -O http://www.lua.org/ftp/lua-5.3.5.tar.gz
tar -zxvf lua-5.3.5.tar.gz
cd lua-5.3.5
make linux test
make install
```

## 安装 环境依赖
```
# apt-get install make gcc libreadline-dev
```
[Ubuntu 16.04 安装 Lua](http://zhang-jc.github.io/2016/07/23/Ubuntu-16-04-%E5%AE%89%E8%A3%85-Lua/)

# lua 基本知识
## lua 语法
### lua注释
```lua
--单行注释
a = "sdsd"
--[[
    多行注释
    sdsdsd
    sdfsdfs
    gsddf
]]
```

### 关键词
以下列出了 Lua 的保留关键字。保留关键字不能作为常量或变量或其他用户自定义标示符：

`break`     `do`    `while`     `if`    `then`  `else`
`elseif`	`end`	`for`       `true`	`false` `return`    
`function`	`in`	`local`     `until`
`nil`	    `not`   `and`	    `or`	`repeat`
		
一般约定，以下划线开头连接一串大写字母的名字（比如 _VERSION）被保留用于 Lua 内部全局变量。

## lua变量
lua变量分三种：全局变量，局部变量，表中的域。lua中默认是全局变量，默认值全为`nil`,用`local`显示声明为局部变量

### 全局变量
在默认情况下，变量总是认为是全局的。

全局变量不需要声明，给一个变量赋值后即创建了这个全局变量，访问一个没有初始化的全局变量也不会出错，只不过得到的结果是：nil。
```lua
> print(b)  -->nil
> b=10
> print(b)  -->10
> 
```
如果你想删除一个全局变量，只需要将变量赋值为nil。

```lua
b = nil
print(b)      --> nil
```
这样变量b就好像从没被使用过一样。换句话说, 当且仅当一个变量不等于nil时，这个变量即存在。

### 特殊变量
全局变量arg存放Lua的命令行参数: 脚本名索引为0，脚本参数从1开始增加，脚本前面的参数从-1开始减少
```
prompt> lua -e "sin=math.sin" script a b 
arg 表如下： 
arg[-3] = "lua" 
arg[-2] = "-e" 
arg[-1] = "sin=math.sin" 
arg[0] = "script" 
arg[1] = "a" 
arg[2] = "b" 
```


### 赋值语句
赋值是改变一个变量的值和改变表域的最基本的方法。
```lua
a = "hello" .. "world"
t.n = t.n + 1 
```
Lua可以对多个变量同时赋值，变量列表和值列表的各个元素用逗号分开，赋值语句右边的值会依次赋给左边的变量。
```lua
a, b = 10, 2*x       <-->       a=10; b=2*x
```
遇到赋值语句Lua会先计算右边所有的值然后再执行赋值操作，所以我们可以这样进行交换变量的值：
```lua
x, y = y, x                     -- swap 'x' for 'y'
a[i], a[j] = a[j], a[i]         -- swap 'a[i]' for 'a[j]'
```
当变量个数和值的个数不一致时，Lua会一直以变量个数为基础采取以下策略：

a. 变量个数 > 值的个数             按变量个数补足nil
b. 变量个数 < 值的个数             多余的值会被忽略
例如：
```lua
a, b, c = 0, 1
print(a,b,c)             --> 0   1   nil
 
a, b = a+1, b+1, b+2     -- value of b+2 is ignored
print(a,b)               --> 1   2
 
a, b, c = 0
print(a,b,c)             --> 0   nil   nil
```
上面最后一个例子是一个常见的错误情况，注意：如果要对多个变量赋值必须依次对每个变量赋值。
```lua
a, b, c = 0, 0, 0
print(a,b,c)             --> 0   0   0
```
多值赋值经常用来交换变量，或将函数调用返回给变量：
```lua
a, b = f()
```
f()返回两个值，第一个赋给a，第二个赋给b。

应该尽可能的使用局部变量，有两个好处：
- 避免命名冲突。
- 访问局部变量的速度比全局变量更快。

## Lua 数据类型
Lua是动态类型语言，变量不要类型定义,只需要为变量赋值。 值可以存储在变量中，作为参数传递或结果返回。

Lua中有8个基本类型分别为：nil、boolean、number、string、userdata、function、thread和table。

数据类型    |	描述
:--:      | :--
nil	      | 这个最简单，只有值`nil`属于该类，表示一个无效值（在条件表达式中相当于false）。
boolean   |	包含两个值：`false`和`true`。
number    |	表示双精度类型的实浮点数
string    |	字符串由一对双引号或单引号来表示
function  |	由 C 或 Lua 编写的函数
userdata  |	表示任意存储在变量中的C数据结构
thread    |	表示执行的独立线路，用于执行协同程序
table     |	Lua 中的表（`table`）其实是一个"关联数组"（associative arrays），数组的索引可以是数字或者是字符串。在 Lua 里，`table` 的创建是通过"构造表达式"来完成，最简单构造表达式是{}，用来创建一个空表。

### nil（空）
nil 类型表示一种没有任何有效值，它只有一个值 -- nil，例如打印一个没有赋值的变量，便会输出一个 nil 值：

```
> print(type(a))
nil
>
```
对于全局变量和 table，nil 还有一个"删除"作用，给全局变量或者 table 表里的变量赋一个 nil 值，等同于把它们删掉，执行下面代码就知：

```lua
tab1 = { key1 = "val1", key2 = "val2", "val3" }
for k, v in pairs(tab1) do
    print(k .. " - " .. v)
end
 
tab1.key1 = nil
for k, v in pairs(tab1) do
    print(k .. " - " .. v)
end
```
nil 作比较时应该加上双引号 "：
```
> type(X)
nil
> type(X)==nil
false
> type(X)=="nil"
true
> 
```
`type(X)==nil` 结果为 `false` 的原因是因为 `type(type(X))==string`。

### string（字符串）
字符串由一对双引号或单引号来表示。
```lua
string1 = "this is string1"
string2 = 'this is string2'
```
也可以用 2 个方括号 "[[]]" 来表示"一块"字符串。
```lua
html = [[
<html>
<head></head>
<body>
    <a href="http://www.runoob.com/">菜鸟教程</a>
</body>
</html>
]]
print(html)
```

table（表）
在 Lua 里，table 的创建是通过"构造表达式"来完成，最简单构造表达式是{}，用来创建一个空表。也可以在表里添加一些数据，直接初始化表:
```lua
-- 创建一个空的 table
local tbl1 = {}
 
-- 直接初始表
local tbl2 = {"apple", "pear", "orange", "grape"}
```
Lua 中的表（table）其实是一个"关联数组"（associative arrays），数组的索引可以是数字或者是字符串。
```lua
-- table_test.lua 脚本文件
a = {}
a["key"] = "value"
key = 10
a[key] = 22
a[key] = a[key] + 11
for k, v in pairs(a) do
    print(k .. " : " .. v)
end
```
脚本执行结果为：
```
$ lua table_test.lua 
key : value
10 : 33
```
不同于其他语言的数组把 0 作为数组的初始索引，在 Lua 里表的默认初始索引一般以 1 开始。
```lua
-- table_test2.lua 脚本文件
local tbl = {"apple", "pear", "orange", "grape"}
for key, val in pairs(tbl) do
    print("Key", key)
end
```
脚本执行结果为：
```
$ lua table_test2.lua 
Key    1
Key    2
Key    3
Key    4
```
table 不会固定长度大小，有新数据添加时 table 长度会自动增长，没初始的 table 都是 nil。
```lua
-- table_test3.lua 脚本文件
a3 = {}
for i = 1, 10 do
    a3[i] = i
end
a3["key"] = "val"
print(a3["key"])
print(a3["none"])
```
脚本执行结果为：
```
$ lua table_test3.lua 
val
nil
```

### function（函数）
在 Lua 中，函数是被看作是"第一类值（First-Class Value）"，函数可以存在变量里:
```lua
-- function_test.lua 脚本文件
function factorial1(n)
    if n == 0 then
        return 1
    else
        return n * factorial1(n - 1)
    end
end
print(factorial1(5))
factorial2 = factorial1
print(factorial2(5))
```
脚本执行结果为：
```
$ lua function_test.lua 
120
120
```
function 可以以匿名函数（anonymous function）的方式通过参数传递:
```lua
-- function_test2.lua 脚本文件
function testFun(tab,fun)
    for k ,v in pairs(tab) do
        print(fun(k,v));
    end
end 

tab={key1="val1",key2="val2"};--table(数组)
testFun(tab,
function(key,val)--匿名函数
    return key.."="..val;--字符串拼接使用..
end
);
```
脚本执行结果为：
```
$ lua function_test2.lua 
key1 = val1
key2 = val2
```

### thread（线程）
在 Lua 里，最主要的线程是协同程序（`coroutine`）。它跟线程（`thread`）差不多，拥有自己独立的栈、局部变量和指令指针，可以跟其他协同程序共享全局变量和其他大部分东西。

线程跟协程的区别：线程可以同时多个运行，而协程任意时刻只能运行一个，并且处于运行状态的协程只有被挂起（suspend）时才会暂停。

### userdata（自定义类型）
`userdata` 是一种用户自定义数据，用于表示一种由应用程序或 C/C++ 语言库所创建的类型，可以将任意 C/C++ 的任意数据类型的数据（通常是 `struct` 和 指针）存储到 Lua 变量中调用。

