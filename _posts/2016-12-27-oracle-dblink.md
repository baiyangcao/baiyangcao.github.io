---
layout: post
title: Oracle 数据库连接 DBLink
date: 2016-12-27
categories: Notes
tags: Oracle
---

 1. 创建数据库连接

```
CREATE [PUBLIC] DATABASE LINK {link name}
CONNECT TO {username} IDENTIFIED BY {password}
USING {connection string/tns name} 
```

其中`USING`关键词后面可以是数据库服务器上配置的`TNS name`服务命名，
或者是在`tnsname.ora`中配置的服务命名对应的连接字符串，如：
`(DESCRIPTION = (ADDRESS_LIST = (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.0.78)(PORT = 1521)) ) (CONNECT_DATA = (SERVICE_NAME = orcl) ) )`

 2. 使用数据库连接：

 数据库连接的使用很简单，只要在远程对象名之后添加`@数据库连接名`即可，
 如要从远程数据库`GT`的`BASP_DX`用户下获取`JSYDSYQ`表的数据，可使用如下语句：

 ```
 SELECT * FROM BASP_DX.JSYDSYQ@GT;
 ```

 3. 删除数据库连接：

```
DROP PUBLIC DATABASE LINK {link name}
```

 4. global_names
 
 如果数据库参数global_names设置为true，则必须数据库连接的名称{link name}
 必须与远程数据库GLOBAL_NAME相同。  
   
 global_names参数可以通过`show parameter global_names`得到，
 而远程服务器的GLOBAL_NAME可以通过执行SQL语句
 `SELECT * FROM GLOBAL_NAME`获得。  
  
 当global_names设置为false时，不可以在本地调用远程服务器中不存在
 的函数，不仅仅是自定义函数，`UTL_RAW.CAST_TO_RAW`函数也不可以