# mongoose

## 简介

## 消除弃用警告

mongoose 有些接口被弃用或不建议使用，Node.js驱动时会发出`DeprecationWarning`警告，

- `mongoose.set('useNewUrlParser', true);`
- `mongoose.set('useFindAndModify', false);`
- `mongoose.set('useCreateIndex', true);`
- 更换`update()`用`updateOne()`，`updateMany()`或`replaceOne()`
- 替换`remove()`为`deleteOne()`或`deleteMany()`。
- 替换`count()`为`countDocuments()`，除非您想要计算整个集合中有多少文档（没有过滤器）。在后一种情况下，使用`estimatedDocumentCount()`。

## api

- Model.findById()
  - 通过`_id`字段查找单个文档。`findById(id)`差不多相当于`findOne({ _id: id })`。如果要按文档查询`_id`，请使用`findById()`而不是`findOne()`。