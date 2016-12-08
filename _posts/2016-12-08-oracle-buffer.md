---
layout: post
title: 缓冲区性能调优
date: 2016-12-08
categories: Notes
tags: Oracle
---

oracle 10g 修改SGA,PGA大小

 - 概念  
   `SGA指系统全局区域(System Global Area)`,是用于存储数据库信息的内存区，该信息为数据库进程所共享。
   `PGA指进程全局区域(Process Global Area)`,包含单个服务器进程或单个后台进程的数据和控制信息，与几个进程共享的SGA 正相反,PGA 是只被一个进程使用的区域，PGA 在创建进程时分配,在终止进程时回收。 Oracle 10g提供了PGA内存的自动管理。参数pga_aggregate_target可以指定PGA内存的最大值。当参数 pga_aggregate_target大于0时，Oracle将自动管理pga内存，并且各进程的所占PGA之和，不大于 pga_aggregate_target所指定的值。

 - 配置  
   oracle推荐OLTP(on-line Transaction Processing)系统oracle占系统总内存的80%,然后再分配80%给SGA,20%给PGA。也就是

```
SGA=system_total_memory*80%*80%
PGA=system_total_memory*80%*20%
```

 - 操作  
   用SYS用户以SYSDBA身份登录系统

```sql
SQL> alter system set sga_max_size=2000m scope=spfile;
SQL> alter system set sga_target=2000m scope=spfile;
SQL> alter system set pga_aggregate_target=500m scope=spfile;
```

   然后重新启动数据库
   最后查看一下是否生效

```sql
show parameter sga_max_size;
show parameter sga_target;
show parameter pga_aggregate_target;
```