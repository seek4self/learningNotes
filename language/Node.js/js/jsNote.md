# Node.js notes

## 严格模式

ES6 的模块自动采用严格模式，不管你有没有在模块头部加上"use strict";。

严格模式主要有以下限制。

- 变量必须声明后再使用
- 函数的参数不能有同名属性，否则报错
- 不能使用with语句
- 不能对只读属性赋值，否则报错
- 不能使用前缀 0 表示八进制数，否则报错
- 不能删除不可删除的属性，否则报错
- 不能删除变量delete prop，会报错，只能删除属性delete global[prop]
- eval不会在它的外层作用域引入变量
- eval和arguments不能被重新赋值
- arguments不会自动反映函数参数的变化
- 不能使用arguments.callee
- 不能使用arguments.caller
- 禁止this指向全局对象
- 不能使用fn.caller和fn.arguments获取函数调用的堆栈
- 增加了保留字（比如protected、static和interface）

## Problems

### async/await

- async 是“异步”的简写，而 await 可以认为是 async wait 的简写
- await 只能出现在 async 函数中
- async函数输出的是一个 Promise 对象
- async 函数（包含函数语句、函数表达式、Lambda表达式）会返回一个 Promise 对象，如果在函数中 return 一个直接量，async 会把这个直接量通过 Promise.resolve() 封装成 Promise 对象。
- await 用于解析async函数返回的Promise对象或者表达式运算结果，如果等到一个Promise对象，它会阻塞后面的代码，直到解析出Promise中封装的值

## modules

- [log4js基本配置](https://www.shenyujie.cc/2018/05/25/log4js-basic/)

## 生成6位随机数验证码

```js
console.log(Math.random().toString().slice(-6));
```

Math.random方法 用于生成0~1之间的随机数
toString方法 用于将生成的随机数转换成字符串
slice方法 用于截取转换后的字符串，传入参数为负数时代表从字符串尾部开始朝头部方向截取

## exports

[exports的用法：Node.js模块的接口设计模式](https://gywbd.github.io/posts/2014/11/using-exports-nodejs-interface-design-pattern.html)

## 或赋值

```js
const a = 1
const b = 0
const c = b || a
console.log(c)  // 1
```
