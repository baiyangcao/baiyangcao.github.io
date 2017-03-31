---
layout: post
title: 修改数据库连接数,游标数
date: 2016-11-24
categories: Notes
tags: Oracle
---

Oracle中的`processes`参数表示`最大连接数`，`open_cursors`参数表示`游标数`，
如下可以查看系统中的最大连接数和游标数

```sql
SQL> show parameter processes;
50

SQL> show parameter open_cursors;
1000
```

可以使用如下命令修改`processes`和`open_cursors`参数值

```sql
SQL> alter system set processes=200 scope=spfile;

SQL> alter system set open_cursors=2000 scope=spfile;
```

> **注：** `processes`的可取值可以到pfile样例文件(一般在$ORACLE_HOME/db/init.ora)
> 中查看
> 
> ```
> processes = 50    #SMALL
> processes = 100   #MEDIIUM
> processes = 200   #LARGE
> ```
>
> 这里可以看出`processes`参数最大值可以取`200`，
> 最好不要超过这个值，否则就可能出现[`ORA-00064...` 修改Processes参数后重启报错]()的情况

<!-- -->

> ```sql
> -- 查看当前数据库连接数
> SQL> select * from v$session;
> 
> -- 查看当前数据库打开的游标
> SQL> select * from v$open_cursors;
> ```