---
layout: post
title: Dojo初探
date: 2017-04-16
categories: Notes
tags: Dojo Javascript
---

Dojo 是一个由 Dojo 基金会开发的 Javascript 工具包，
据说受到 IBM 的永久支持，其包括四个部分： dojo, dijit, dojox, util

 - `dojo`: 有时也被称作 `core`，包括一些常用的软件包和模块，
 涉及了例如： AJAX， DOM 操作， 面对对象编程，事件，承诺（Promises），
 数据存储，拖拽和国际化等类库  

 - `dijit`: 一个扩展的控件包包括其底层类等，完全基于 Dojo core 构建
 
 - `dojox`: 基于 Dojo core 和 dijit 构建的大量的包和模块，
 这些包和模块的成熟度参差不齐，有些模块很成熟，但也有些模块仍处在实验阶段

 - `util`: 提供工具包余下的功能，如可构建、测试和文档化的代码