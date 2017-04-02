---
layout: cv
---


```
论一个逗比的自我修养
```

# 技能树

![技能树](images/cv/技能树.png)

> 注： 图中蓝色部分为实际在项目中运用过的技能

 - `Program Language`
    + `.NET`
       * `ASP.NET WebForm` 基础维护的电子政务平台的相关系统皆是基于 ASP.NET WebForm 建立的，
         而后又独立开发了移动端后台数据管理系统
       * `ASP.NET WebAPI` 使用 ASP.NET WebAPI 技术开发基础数据提报服务，用于导出 word/excel/附件数据
    + `python`
       * `Flask/Arcpy` 使用 Flask 制作基础数据提报服务中的图形导出服务部分，
         其中 Arcpy 用于将图形数据导出到指定文件夹，Flask 则负责提供 REST 服务
    + `Flex`
       * `MXML/ActionScript` 毕业设计基于 ArcGIS Server 制作人口分析程序，
         而后在参加工作后参与电子政务平台的 Flex 图形端的维护工作
- `Version Control System`
    + `VSS` 在工作初期使用的老版本的 VSS 来管理代码
    + `SVN` 而后，在服务器迁移之后，改用了新的 SVN 来管理代码
    + `GIT` 最后，从项目现场撤出之后，因为项目现场与办事处不在同一网络，改用了 GIT 版本管理器，
     以补丁的形式进行代码的更新，并在办事处建立 GitLab 服务器进行代码管理
- `DataBase`
    + `Oracle` 使用 Database Link 来连接远程数据库，并编写存储过程进行数据抽取，
      然后在数据表上添加触发器进行及时的数据推送，最后使用 job 来实现定时任务
    + `SQL Server` 进行过表值函数、标量值函数、存储过程的编写

# 工作经历

```
2013.07-2017.05 **武大吉奥信息技术有限公司**
```
  
在该公司主要负责沈阳“一张图”电子政务平台相关功能模块的开发和维护功能，以及后期不动产统一登记平台相关的开发。

<div class="alert alert-info" style="margin-left: 20px">沈阳“一张图”电子政务平台</div>

 - 维护MSSQL+ASP.NET开发的业务审批及OA系统，利用UCML工作流引擎完成相关新流程的开发及现有流程的维护
 - 开发WebService后台服务接口为移动办公APP提供后台服务，并基于Oracle+ASP.NET+jQuery EasyUI开发后台数据管理系统
 - 使用ASP.NET Web API技术开发数据导出接口，在现有系统中嵌入数据导出模块
 - 维护基于ArcGIS API For Flex开发的图形端程序  
  
<div class="alert alert-info" style="margin-left: 20px">不动产统一登记平台</div>

 - 利用ETL工具Kettel抽取“一张图”数据[SQL Server]到不动产登记平台[Oracle]
 - 基于不动产平台开发相关的流程及表单
 - Oracle数据库中制作触发器、存储过程、数据库连接用于与中间库数据之间的交互

# 教育经历

```
2010.09-2014.07 **沈阳建筑大学** 测绘工程/本科
```
