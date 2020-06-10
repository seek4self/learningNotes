# python 语法

## 基本类型

不需要声明类型，自行识别

### 空值 None

python 空值是一个特殊值，用 `None` 表示， 并不等于`0`。

### 浮点数

除法有两种表示

- `/` 两数相除结果必为浮点数
- `//` 两数相除取整数
- `%` 两数相除取余数

### 列表 list

类似数组,用`[]`表示，索引可以为负值，元素可以为任何类型

```py
names = ['alice', 'bob', 234, 'david']
names[-1]
# 'david'
names.append('emiya')  
# ['alice', 'bob', 234, 'david', 'emiya']
names.insert(2, 'saber')
# ['alice', 'bob', 'saber', 234, 'david', 'emiya']
names.pop()
# ['alice', 'bob', 'saber', 234, 'david']
names.pop(2)
# ['alice', 'bob', 234, 'david']
```

### 元组 tuple

类似于list的有序列表, 但是初始化后不能修改，用`()`表示, 尽可能每个元素后跟`,` 结尾

```py
names = ('alice', 'bob', 234, 'david',)
a = (1)
# 1  not tuple
b = (1,)
# (1,) is tuple
```

### 字典 dist

使用 `key-value`存储， 用 `{}` 表示， `key` 可以为字符串或数字

```py
d = {1:2, 'name': 'alice', 'age': 18}

# 用 `in` 判断时候存在
'name' in d
# True
# 用 `get()` 判断存在
d.get(2)
# None

# 删除key
d.pop('age')
```

## problems

### Python3 报错 `TypeError: a bytes-like object is required, not 'str'`

问题出在python3.5和Python2.7在套接字返回值解码上有区别

```py
b = b"example"    # bytes object  
s = "example"     # str object  
sb = bytes(s, encoding = "utf8")    # str to bytes
# 或者：sb = str.encode(s)             # str to bytes
bs = str(b, encoding = "utf8")      # bytes to str  
# 或者：bs = bytes.decode(b)           #  bytes to str
```
