---
 Author: mazhuang
 Date: 2020-07-01 15:15:42
 LastEditTime: 2020-07-01 15:15:45
 Description: 
---
# YAML

YAML 是专门用来写配置文件的语言，非常简洁和强大，远比 JSON 格式方便。

## 语法规则

- 大小写敏感
- 使用缩进表示层级关系
- 缩进时不允许使用Tab键，**只允许使用空格**。
- 缩进的**空格数目不重要**，只要相同层级的元素左侧对齐即可

## 数据结构

- 对象：键值对的集合，又称为映射（mapping）/ 哈希（hashes） / 字典（dictionary）
- 数组：一组按次序排列的值，又称为序列（sequence） / 列表（list）
- 纯量（scalars）：单个的、不可再分的值
  - 字符串
  - 布尔值
  - 整数
  - 浮点数
  - Null
  - 时间
  - 日期

### 对比

```yaml
animal: cat
books: { name: c++, type: code }
# personal information
person:
  name: Alice
  sex: girl
  age: 16
  height: 160.50
  educate: true
  like:
    - music
    - painting
    - dancing
    - running
empty: ~
```

转为json

```json
{
    "animal": "cat",
    "books": {
        "name": "c++",
        "type": "code"
    },
    "person":{
        "name": "Alice",
        "sex": "girl",
        "age": 16,
        "height": 160.5,
        "educate": true,
        "like": [ "music", "painting", "dancing", "running" ]
    },

    "empty": null
}
```
