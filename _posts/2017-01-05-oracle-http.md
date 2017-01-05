---
layout: post
title: Oracle 发起 HTTP Post请求
date: 2017-01-05
categories: Notes
tags: Oracle
---

## 发起Http Post请求

```
DECLARE
  data VARCHAR2(8000);
  req UTL_HTTP.REQ;
  resp UTL_HTTP.RESP;
  bresult BLOB;
BEGIN
    req := UTL_HTTP.BEGIN_REQUEST(url => url, method => 'POST');
    UTL_HTTP.SET_HEADER(r => req, name => 'Content-Type', value => 'application/x-www-form-urlencoded');
    UTL_HTTP.SET_HEADER(r => req, name => 'Content-Length', value => LENGTHB(data));
    UTL_HTTP.WRITE_RAW(r => req, data => UTL_RAW.CAST_TO_RAW(CONVERT(data, 'UTF8')));
    resp := UTL_HTTP.GET_RESPONSE(req);
    UTL_HTTP.READ_RAW(resp, bresult);
    result := UTL_RAW.CAST_TO_VARCHAR2(bresult);
    UTL_HTTP.END_RESPONSE(resp);
  EXCEPTION
    WHEN UTL_HTTP.END_OF_BODY THEN
      UTL_HTTP.END_RESPONSE(resp);
  END;
```

这里有些需要注意的问题：

 - 使用`WRITE_RAW/READ_RAW`方法设置和读取数据，而不是`WRITE_TEXT/READ_TEXT`方法，
   因为后者会把字符串转换成服务器的字符集，而我们一般的请求Request的编码为UTF-8

 - 声明的变量类型应该是`VARCHAR2`而不是`NVARCHAR2`，否则在后台webservice中获取到的英文字符会自动补上`\0`，
   如`data`变量值为`BZF=A`到了后台中获取的为`\0B\0Z\0F=\0A`，
   这是因为`NVARCHAR2`中的字符都是以中文字符的形式保存，而对于英文字符则会自动补`\0`，
   这也就是为什么在`NVARCHAR2(10)`中可以保存十个中文字符或十个英文字符了。

## ORA-24247 网络访问被访问控制列表(ACL)拒绝

使用`utl_http.request(url)`函数发起HTTP请求报错，原因是没有设置ACL，
进行如下设置：

```
BEGIN
  -- 创建ACL
  DBMS_NETWORK_ACL_ADMIN.create_acl(acl => 'httprequestpermission.xml',
                                    description => 'Normal Access',
                                    -- 要授权的角色
                                    principal => 'CONNECT',
                                    is_grant => TRUE,
                                    -- PRIVILEGE需要大写
                                    PRIVILEGE => 'connect',
                                    start_date => NULL,
                                    end_date => NULL);
  -- 一定要提交                                 
  COMMIT;
  dbms_network_acl_admin.assign_acl(acl => 'httprequestpermission.xml',
                                    host => '192.168.5.*',
                                    lower_port => 80,
                                    upper_port => NULL);
  COMMIT;  
  DBMS_NETWORK_ACL_ADMIN.add_privilege(acl => 'httprequestpermission.xml',
                                       -- 要赋予访问权限的用户或角色
                                       principal => 'SYBDCSXK',
                                       is_grant => TRUE,
                                       privilege => 'connect',
                                       start_date => NULL,
                                       end_date => NULL);
  COMMIT;
END;
```