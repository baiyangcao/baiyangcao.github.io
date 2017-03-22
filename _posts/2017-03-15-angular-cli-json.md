---
layout: post
title: Angular-Cli中引用第三方库
date: 2017-03-15
categories: Notes
tags: Angular
---

最近在学习angular(AngularJS 2)，根据教程使用angular-cli新建项目，
然而在添加JQuery和Bootstrap第三方库时遇到了问题...
  
## 初试

我最初的想法是直接将相对路径写到`index.html`即可，如下：

{% highlight html %}
<link rel="stylesheet" href="../node_modules/bootstrap/dist/css/bootstrap.min.css" />
<script type="text/javascript" src="../node_modules/jquery/dist/jquery.min.js"/>
<script type="text/javascript" src="../node_modules/bootstrap/dist/js/bootstrap.min.js"/>
{% endhighlight %}

然鹅。。。并不好使，浏览器抓包会显示请求
`http://localhost:4200/node_modules/juqery/dist/jquery.min.js`返回404错误，
bootstrap也是相同的问题，这里显然是路径不正确，我的项目目录结构如下：

{% highlight html %}
angular-form/
    |- src/
    |   |- app/
    |   |- index.html
    |   ...
    |- node_modules
    |   |- jquery/
    |   |- bootstrap/
    |   ...
{% endhighlight %}

其中，网站运行时的根目录是`src`目录，
所以获取不到与其处在同一目录的`node_modules`目录下文件也在情理之中...

## 另辟蹊径

经过乱七八糟的查找...发现了可以在`/.angular-cli.json`文件中配置脚本引用，
在其`app.scripts`下配置要添加的脚本，
并在`app.styles`下配置要添加的样式文件:

{% highlight json %}
"app": [
    {
        ...
        "styles": [
            "node_modules/bootstrap/dist/css/bootstrap.min.css"
        ],
        "scripts": [
            "node_modules/bootstrap/dist/css/bootstrap.min.css",
            "node_modules/bootstrap/dist/css/bootstrap.min.css"
        ],
        ...
    }
]
{% endhighlight %}

再次启动网站，却连编译都无法通过...出现如下问题：

{% highlight shell %}
ERROR in multi script-loader!./src/~/jquery/dist/jquery.min.js script-loader!./src/~/bootstrap/dist/js/bootstrap.min.js
Module not found: Error: Can't resolve 'E:\Code\JavaScript\angular2\angular-forms\src\node_modules\jquery\dist\jquery.min.js' in 'E:\Code\JavaScript\angular2\angular-forms'
 @ multi script-loader!./src/~/jquery/dist/jquery.min.js script-loader!./src/~/bootstrap/dist/js/bootstrap.min.js
{% endhighlight %}

可以看出这里去加载js脚本时寻找的是`src/`目录下的`node_modules`目录，
所以加载失败。这意味着`angular-cli.json`文件中配置的路径时**相对于网站根目录**的路径，
接着做如下更改：

{% highlight json %}
"app": [
    {
        ...
        "styles": [
            "../node_modules/bootstrap/dist/css/bootstrap.min.css"
        ],
        "scripts": [
            "../node_modules/bootstrap/dist/css/bootstrap.min.css",
            "../node_modules/bootstrap/dist/css/bootstrap.min.css"
        ],
        ...
    }
]
{% endhighlight %}

再次运行网站，成功加载~~~

## 回看来时路

后来了解到，angular-cli的项目使用webpack来将模块打包，
我们这里配置的`scripts`和`styles`会被打包成`scripts.bundle.js`
和`styles.bundle.js`文件加载到前台页面，而后就阔以正常使用这些第三方库了~~~


> 参考链接:  
>   
> <http://stackoverflow.com/questions/38855891/angular-cli-webpack-how-to-add-or-bundle-external-js-files>  
> <https://www.sitepoint.com/ultimate-angular-cli-reference/>