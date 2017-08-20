---
layout: post
title: MySQL 中 Int 列插入字符串变为 '0'
date: 2017-07-20
categories: Notes
tags: [MySQL]
---

今天在听课过程中遇到了这样一个问题：`grade` 表中的 `gradeid` 字段为 `INT` 类型，但是在执行插入一个字符串时，只是出现了警告，但是插入成功，而且插入的结果为 `0` 

```sql
# 执行语句
INSERT INTO grade(gradeid) VALUES('test')
# grade 表结果
# ---------
# gradeid
#   0
```

这是由于数据库的 SQL 模式导致的结果，在 `C:\ProgramData\MySQL\MySQL Server 5.7\my.ini` 配置文件中配置 `sql-mode` 参数

```shell
# Set the SQL mode to strict
sql-mode="STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION"
```

上述设置中 `STRICT_TRANS_TABLES` 为对事务表启用严格模式，
与这个设置相关的还有 `STRICT_ALL_TABLES`，是对所有表启用严格模式。  
  
> 严格模式控制MySQL如何处理非法或丢失的输入值。有几种原因可以使一个值为非法。例如，数据类型错误，不适合列，或超出范围。当新插入的行不包含某列的没有显示定义DEFAULT子句的值，则该值被丢失。
>   
> 对于事务表，当启用STRICT_ALL_TABLES或STRICT_TRANS_TABLES模式时，如果语句中有非法或丢失值，则会出现错误。语句被放弃并滚动。
>   
> 对于非事务表，如果插入或更新的第1行出现坏值，两种模式的行为相同。语句被放弃，表保持不变。如果语句插入或修改多行，并且坏值出现在第2或后面的行，结果取决于启用了哪个严格选项：
>   
> 对于STRICT_ALL_TABLES，MySQL返回错误并忽视剩余的行。但是，在这种情况下，前面的行已经被插入或更新。这说明你可以部分更新，这可能不是你想要的。要避免这点，最好使用单行语句，因为这样可以不更改表即可以放弃。
>   
> 对于STRICT_TRANS_TABLES，MySQL将非法值转换为最接近该列的合法值并插入调整后的值。如果值丢失，MySQL在列中插入隐式 默认值。在任何情况下，MySQL都会生成警告而不是给出错误并继续执行语句。

我的 `grade` 表的存储引擎是 `InnoDB`，应该是属于事务表，
但是在执行语句时没有报错只是出现了警告，
当然我是在 SQLyog 中执行的 SQL 语句，
可能是由于默认以非事务的方式执行 SQL 语句，所以会插入默认值，
但是如果以事务的方式执行，就会抛出错误，在 MySQL Workbench 中执行：

```sql
begin;
# 抛出错误
# Error Code: 1366. Incorrect integer value: 'test' for column 'id' at row 1
INSERT INTO grade(gradeid) VALUES('test');
commit;
```

严格模式的设置主要是对于 SQL 语句的执行方式，是否在事务中执行 SQL 语句，一般单独语句的执行都默认使用非事务方式执行

> 参考链接：  
> <https://dev.mysql.com/doc/refman/5.7/en/sql-mode.html#sql-mode-strict>  
> <http://blog.sina.com.cn/s/blog_53b13d950100x2ok.html>  
> <http://www.2cto.com/database/201207/139809.html>  
> <https://my.oschina.net/wojibuzhu/blog/511104>