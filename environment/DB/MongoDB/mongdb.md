# MongoDB

环境搭建[官方文档](https://docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu/#install-community-ubuntu-pkg)

## 相关操作

```sh
# 启动 MongoDB
sudo service mongod start
# 查看状态 MongoDB
sudo service mongod status
# 重新启动 MongoDB
sudo service mongod restart
# 停止 MongoDB
sudo service mongod stop
# 设置开机自启动
sudo systemctl enable mongod
```

## 卸载 MongoDB

```sh
sudo service mongod stop
sudo apt-get purge mongodb-org*
sudo rm -r /var/log/mongodb
sudo rm -r /var/lib/mongodb
```

## 开启远程访问

```sh
sudo vim /etc/mongod.conf
# 把 bindIp:127.0.0.1 修改为 bindIp:0.0.0.0

# 之后重启服务
sudo service mongod restart
```

## 故障问题

- 遇到连接拒绝问题 `Failed to connect to 127.0.0.1:27017, in(checking socket for error after poll), reason: Connection refused`，执行下面命令可解决

```sh
sudo rm /var/lib/mongodb/mongod.lock
sudo service mongod restart
```

## 应用场景

### 适用场景

1. 实时的CRU操作，如网站、论坛等实时数据存储
2. 高伸缩性，可以分布式集群，动态增删节点
3. 存储大尺寸、低价值数据
4. 缓存
5. BSON结构对象存储

### 不适用场景

1. 高度事务性操作，如银行或会计系统
2. 传统商业智能应用，如提供高度优化的查询方式
3. 需要SQL的问题
4. 重要数据，关系型数据

## mongodb性能优化

1. 文档中的`_id`键推荐使用默认值，禁止向`_id`中保存自定义的值。指定`_id`会减慢插入速率
2. 推荐使用**短字段名**。与关系型数据库不同，MongoDB集合中的每一个文档都需要存储字段名，长字段名会需要更多的存储空间。
3. MongoDB索引可以提高文档的查询、更新、删除、排序操作，所以结合业务需求，适当创建索引。
4. 每个索引都会占用一些空间，并且导致插入操作的资源消耗，因此，**建议每个集合的索引数尽量控制在5个以内**。
5. 对于包含多个键的查询，创建包含这些键的**复合索引**是个不错的解决方案。复合索引的键值顺序很重要，理解索引最左前缀原则。
6. **TTL 索引**（time-to-live index，具有生命周期的索引），使用TTL索引可以将超时时间的文档老化，一个文档到达老化的程度之后就会被删除。
7. 需要在集合中某字段创建索引，但集合中大量的文档不包含此键值时，建议创建**稀疏索引**。
8. 创建文本索引时字段指定text，而不是1或者-1。每个集合只有一个文本索引，但是它可以为任意多个字段建立索引。 **只有企业版（MongoDB Enterprise）支持中文搜索**
9. 使用findOne在数据库中查询匹配多个项目，它就会在自然排序文件集合中返回第一个项目。如果需要返回多个文档，则使用find方法。
10. 如果查询无需返回整个文档或只是用来判断键值是否存在，可以通过投影（映射）来限制返回字段，减少网络流量和客户端的内存使用。
11. 除了前缀样式查询，正则表达式查询不能使用索引，执行的时间比大多数选择器更长，应节制性地使用它们。
12. 在聚合运算中，`$match`要在`$group`前面，通过前置`$match`前置，可以减少`$group` 操作符要处理的文档数量。
13. 通过操作符对文档进行修改，通常可以获得更好的性能，因为，不需要往返服务器来获取并修改文档数据，可以在序列化和传输数据上花费更少的时间。
14. 批量插入（batchInsert）可以减少数据向服务器的提交次数，提高性能。但是批量提交的BSON Size不超过48MB。
15. 禁止一次取出太多的数据进行排序，MongoDB目前支持对32M以内的结果集进行排序。如果需要排序，请尽量限制结果集中的数据量。
16. 查询中的某些`$`操作符可能会导致性能低下，如操作符可能会导致性能低下，如 `$ne`，`$not`，`$exists`，`$nin`，`$or`尽量在业务中不要使用。
    - `$exist`:因为松散的文档结构导致查询必须遍历每一个文档；
    - `$ne`:如果当取反的值为大多数，则会扫描整个索引；
    - `$not`:可能会导致查询优化器不知道应当使用哪个索引，所以会经常退化为全表扫描；
    - `$nin`:全表扫描；
    - `$or`:有多个条件就会查询多少次，最后合并结果集，应该考虑装换为`$in`。
17. 固定集合可以用于记录日志，其插入数据更快，可以实现在插入数据时，淘汰最早的数据。需求分析和设计时，可考虑此特性，即提高了性能，有省去了删除动作。  
    - capped Collections 比普通 Collections 的读写效率高。Capped Collections 是高效率的 Collection 类型，它有如下特点：
    - **固定大小**: Capped Collections 必须事先创建，并设置大小：

      ```js
      db.createCollection("mycoll", {capped:true, size:100000})
      ```

    - Capped Collections 可以 `insert` 和 `update` 操作；不能 `delete` 操作。只能用 `drop()` 方法删除整个 Collection。
    - 默认基于 Insert 的次序排序的。如果查询时没有排序，则总是按照 `insert` 的顺序返回。
    - **FIFO**: 如果超过了 Collection 的限定大小，则用 FIFO 算法，新记录将替代最先 `insert` 的记录。
18. 集合中文档的数据量会影响查询性能，为保持适量，需要定期归档。

- [正确理解和使用 Mongodb 的索引](https://juejin.im/post/5ad1d2836fb9a028dd4eaae6)
