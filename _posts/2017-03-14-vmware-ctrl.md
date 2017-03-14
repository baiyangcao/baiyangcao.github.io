---
layout: post
title: VMWare虚拟机中Ctrl键锁定、粘滞
date: 2017-03-14
categories: Notes
tags: VMWare
---

最近在使用虚拟机时，总是遇到`Ctrl`键被按下的状态，就是在按下`Space`之后会切换输入法，
按下`A`后会全选文件之类的，然后在连续按下`Ctrl`键之后又恢复正常了，
极度崩溃，让我一度怀疑自己的键盘坏掉了，不过在我的主机中是好使的，
仅在虚拟机中会出现这种问题...
  
后来在网上搜索到了[解决方案](http://blog.csdn.net/zhentao_chen/article/details/9264885)，
其中提到是因为金山词霸的划译功能导致的问题，小生虽然没有安装金山词霸，
但是却一直在使用微软必应词典的划译功能，尝试了一下关掉之后果然好使了...
看样子真是“天下乌鸦一样黑”。

> 参考链接：  
> <http://blog.csdn.net/zhentao_chen/article/details/9264885>