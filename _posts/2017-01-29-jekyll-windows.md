---
layout: post
title: Windows下安装Jekyll
date: 2017-01-29
categories: Notes
tags: Jekyll Github Ruby
---

一直以来使用jekyll更新文章时都是在Windows下的Linux虚拟机内构建，测试，
因为听闻Windows下安装比较麻烦，不过现在觉得打开虚拟机更麻烦，
所以本着不作死不罢休的精神开始了Windows下jekyll安装之旅... 

## 安装Ruby和RubyDevKit

[下载](http://rubyinstaller.org/downloads/)Ruby安装包和RubyDevKit压缩包，
按照系统分别下载32位和64位的版本。
  
Ruby的安装比较简单，直接一路下一步就可以；
RubyDevKit打开时会提示你输入解压目录，例如：`C:\RubyDevKit\`。
  
然后进入RubyDevKit解压目录，执行如下命令：

{% highlight shell %}
> cd C:\RubyDevKit
> ruby dk.rb init
> ruby dk.rb install
{% endhighlight %}

## 安装Jekyll

执行如下命令使用gem来安装Jekyll：

{% highlight shell %}
> gem install jekyll
{% endhighlight %}

## 安装语法高亮器

Jekyll默认使用pygments.rb作为语法高亮器，pygments基于python开发，
要想使用的话就需要安装Python2.x版本及pip。

> 注： 不可以使用Python3.x版本

当然，我们也可以使用另外基于Ruby的语法高亮器Rouge，
虽然没有pygments支持的语言多，但是运行起来更快也更容易安装，
执行如下语句安装Rouge：

{% highlight shell %}
> gem install rouge
{% endhighlight %}

然后在你的`_config.yml`文件中设置Rouge作为语法高亮器：

{% highlight yaml %}
highlighter: rouge
{% endhighlight %}

> 注：若想要使用pygments参见[这里](http://jekyll-windows.juthilo.com/3-syntax-highlighting/#make-pygments-work)

## 启用监视功能

Jekyll有一个內建的自动生成功能，可以监视你的源文件变化并为你重建网站，
从Jekyll v2.4.0版本开始，`jekyll server`自动启动监视功能。
  
在Windows下，开启这个功能需要安装额外的工具包`wdm`，
执行如下命令安装：

{% highlight shell %}
> gem install wdm
{% endhighlight %}
  
最后，就可以执行`jekyll server`命令在本地预览你的网站啦~~~

> 参考链接：  
> <http://jekyll-windows.juthilo.com/>
