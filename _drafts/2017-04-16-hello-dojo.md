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

## Dojo 第一例

像其他 Js 框架一样，Dojo 可以通过引用本地的 `dojo.js` 文件使用，
也可以通过 CDNs 使用，在 1.7 版本之前，Dojo 会一次性的加载所有模块，
而在那之后，为了支持开发完全模块化的应用程序，Dojo 使用了基于 
[Asynchronous Module Definition (AMD)](https://github.com/amdjs/amdjs-api/wiki/AMD)
的模块化架构，可以使模块在需要的时候才被加载，防止了网络资源浪费，提高加载速度。
  
在我们加载了 `dojo.js` 文件之后，会提供两个可用的全局函数 `require` 
和 `define`，前者用于引入模块，后者用于定义新的模块，
让我们荡起双桨...啊呸，让我们先从引用模块做起

```html
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Tutorial: Hello Dojo!</title>
</head>
<body>
    <h1 id="greeting">Hello</h1>
    <!-- load Dojo -->
    <script src="https://ajax.googleapis.com/ajax/libs/dojo/1.10.4/dojo/dojo.js"
            data-dojo-config="async: true"></script>

    <script>
        require([
            'dojo/dom',
            'dojo/dom-construct'
        ], function (dom, domConstruct) {
            var greetingNode = dom.byId('greeting');
            domConstruct.place('<em> Dojo!</em>', greetingNode);
        });
    </script>
</body>
</html>
```

首先，`require` 函数传入了两个参数，第一个是要加载的模块名称数组，
第二个是模块加载完成之后的回调函数，
  
先来看模块名称数组，`['dojo/dom', 'dojo/dom-construct']`，
这里的模块名称其实就是对应要加载的 JS 文件路径，
如果下载 Dojo 包就会发现，其实在 `dojo` 文件夹下存在 `dom.js` 
和 `dom-constrct.js` 两个文件
  
而后是回调函数，回调函数有两个参数 `dom` 和 `domConstruct`，
是不是和加载的模块很像呢？没错，他们就是模块加载后返回的对象，
使用这些对象就可以引用在模块中定义的方法了

最后在回调函数中，调用 `dom.byId` 获取 `id='greeting'` 的 DOM 节点，
与 `document.getElementById` 类似，然后使用 `domConstruct.place` 
方法在 `greeting` 节点后面添加一个 `em` 节点