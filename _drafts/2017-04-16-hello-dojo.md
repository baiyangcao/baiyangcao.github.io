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
    <script src="//ajax.googleapis.com/ajax/libs/dojo/1.10.4/dojo/dojo.js"
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

> 注： 加载 `dojo.js` 时用的地址以 `//` 开头，而没有相应的协议名称，如 `http:`，
> 这表示这个脚本使用和当前页面相同的协议加载

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

## 自定义 AMD 模块

定义自己的模块可以通过 `define` 函数，定义自己的模块，
首先要保证 HTML 文件是从 HTTP 服务器加载的，因为有些浏览器的安全策略对 
`file:///` 协议有很多限制。一个模块其实就是一个 js 文件，如下：

```javascript
define([
    // 列出当前模块所依赖的模块
    'dojo/dom'
], function(dom){
    var oldText = {};

    // 模块加载时的返回值
    return {
        setText: function (id, text) {
            var node = dom.byId(id);
            oldText[id] = node.innerHTML;
            node.innerHTML = text;
        },

        restoreText: function (id) {
            var node = dom.byId(id);
            node.innerHTML = oldText[id];
            delete oldText[id];
        }
    };
});
```

将这个文件保存在 `当前目录/demo/myModule.js` 文件中，
`define` 和 `require` 参数相同，一个模块 ID 数组和一个回调函数，
`define` 回调函数的返回值将会作为引入模块时对应的模块值。
蓝后，我们来调用我们刚刚定义的模块， 在当前目录添加如下 html 文件
  
```html
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Tutorial: Hello Dojo!</title>
</head>
<body>
    <h1 id="greeting">Hello</h1>
    <!-- 配置 Dojo -->
    <script>
        // 在加载 dojo.js 之前添加 dojoConfig 变量用于配置 dojo
        // 其效果与在 script 标签上添加 data-dojo-config 属性一样
        var dojoConfig = {
            async: true,
            // 注册 demo 包的位置，确保能正确加载自定义模块
            packages: [{
                name: "demo",
                location: location.pathname.replace(/\/[^/]*$/, '') + '/demo'
            }]
        };
    </script>
    <!-- 加载 Dojo -->
    <script src="//ajax.googleapis.com/ajax/libs/dojo/1.10.4/dojo/dojo.js"></script>

    <script>
        require([
            'demo/myModule'
        ], function (myModule) {
            myModule.setText('greeting', 'Hello Dojo!');

            setTimeout(function () {
                myModule.restoreText('greeting');
            }, 3000);
        });
    </script>
</body>
</html>
```

如上代码引入 `demo/myModule` 模块，模块返回值复制给 myModule，
并调用函数 `setText` 与 `restoreText` 设置标题文本

## 等待 DOM 加载完成

一般在开发 Web 程序中，我们需要等待页面 DOM 元素加载完成之后再执行代码，
可以通过一种特殊 AMD 模块实现 —— “插件”，插件的引用方式与其他模块一样，
只不过会在模块标识符的最后加上感叹号(!)，Dojo 提供了 `dom/domReady` 插件，
用于实现 `document.ready` 事件，在 `rquire` 或 `define` 中引用插件，
而后回调函数就会在 DOM 加载完成之后执行

```javascript
require([
    'dojo/dom',
    'dojo/domReady!'
], function (dom) {
    var greeting = dom.byId('greeting');
    greeting.innerHTML += ' from Dojo!';
});
```

> 注：`dojo/domReady!` 后面的感叹号是必须的！！！

当然，如果我们把代码块放到了 `body` 的最下方加载，就不用使用 `dom/Ready!`插件了。
对于 `dom/Ready` 模块，我们并没有用到其返回值，所以，这里将其放到了模块列表的最后，
也没有在回调函数的参数列表中添加相应的引用，对于其他不需要使用返回值的模块也需要这样处理。

## 使用本地 Dojo 源

之前的例子使用的都是 CDN 来加载 Dojo，同样我们可以引用本地的 Dojo 源，
不过需要稍稍修改一下 dojo 的配置，来引入 dojo 的各个包

```javascript
var dojoConfig = {
    async: true,
    baseUrl: '.',
    packages: [
        'dojo',
        'dijit',
        'dojox',
        'demo'
    ]
};
```