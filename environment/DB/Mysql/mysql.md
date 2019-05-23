# Mysql

## 自定义函数

- 递归查询函数

```sql
DELIMITER $$ --定界符

USE `bmi_ums`$$

DROP FUNCTION IF EXISTS `getChildList`$$

-- 开始创建函数
CREATE DEFINER=`root`@`%` FUNCTION `getChildList`(rootId BIGINT) RETURNS VARCHAR(1000) CHARSET utf8mb4
    DETERMINISTIC
BEGIN
    -- 定义变量
    DECLARE sTemp VARCHAR (1000) ;
    DECLARE sTempChd VARCHAR(1000);
      -- 给定义的变量赋值
    SET sTemp = '';
    SET sTempChd =CAST(rootId AS CHAR);
    WHILE sTempChd IS NOT NULL DO
        SET sTemp = CONCAT(sTemp,sTempChd,',');
        SELECT GROUP_CONCAT(id) INTO sTempChd FROM location WHERE FIND_IN_SET(manager_id,sTempChd)>0;
    END WHILE;
    SET sTemp = CONCAT(sTemp,'-1');
    -- 返回函数处理结果
    RETURN sTemp;
END $$  

-- 函数创建定界符
DELIMITER ;
```

- mysql 中函数创建特别注意的两点：
  1. 需要定义定界符`$$`，否则是创建不了函数的，因为 mysql 见到 `;` 就认为执行结束了，只有开始创建时定义分界符，结束时在配对一个分界符，mysql认为这个时候才结束，使得函数能够完整编译创建。
  2. mysql创建函数是没有or replace 这个概念的，这个地方与创建视图不同。
- 使用如下

```sql
SELECT * FROM location WHERE FIND_IN_SET(id, getChildList(806));
-- 查询函数状态
SHOW FUNCTION STATUS [LIKE 'pattern%%']；
-- 查看函数的定义语法
SHOW CREATE FUNCTION fn_name;
```

### 遇到的问题

在MySql中创建自定义函数报错信息如下：

```err
ERROR 1418 (HY000): This function has none of DETERMINISTIC, NO SQL, or READS SQL DATA in its declaration and binary logging is enabled (you *might* want to use the less safe log_bin_trust_function_creators variable)
```

解决方案：

- 设置全局变量，mysql服务重置会失效

```sql
mysql> set global log_bin_trust_function_creators=1;
```

- 建议用这种方案： 这是由于我们开启了bin-log所导致的, 我们就必须在函数中添加下列选项之一
  1. `DETERMINISTIC`: 不确定的
  2. `NO SQL`: 没有SQl语句，当然也不会修改数据
  3. `READS SQL DATA`: 只是读取数据，当然也不会修改数据
  4. `MODIFIES SQL DATA`: 要修改数据
  5. `CONTAINS SQL`: 包含了SQL语句