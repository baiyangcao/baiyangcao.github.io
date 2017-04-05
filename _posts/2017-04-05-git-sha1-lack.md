---
layout: post
title: Git 应用补丁报错 “sha1 information is lacking or useless”
date: 2017-04-05
categories: Notes
tags: Git
---

因为现场代码在客户局域网内，不能连接到公司网络，所以一般更新的时候都是打补丁，
然后在客户现场应用补丁，但是最近在应用补丁的时候出现了如下问题：

{% highlight shell%}
...
fatal: sha1 information is lacking or useless (config.xml).
...
{% endhighlight %}

这里使用的 GitExtension 的图形化界面管理版本库，进行补丁的生成和应用，
GitExtension 默认使用 3way-merge 来应用补丁，生成和应用补丁的命令如下：

{% highlight shell%}
# 生成补丁
> git format-patch -s (commit_id)
# 应用补丁
> git am --3way --signoff 0001.patch
{% endhighlight %}

## 解决办法：

总的来说就是强制应用补丁，手动解决文件问题，然后在继续应用补丁即可

 - 执行 `git am --3way --signoff --reject 0001.path` 命令应用补丁，
   并将补丁中不可应用的部分保存在 `*.rej` 文件中，例如：以上面的报错信息来说，
   就会多出来一个 `config.xml.rej` 文件来标识不可应用的部分

 - 根据 `*.rej` 文件修改没有应用完全的文件，我在处理的时候就比较生猛，
   直接删除 `*.rej` 文件，然后将修改后的文件覆盖

 - 然后将需要提交的文件添加到缓存区 `git add ...` ，因为应用补丁的过程基本就是修改文件，
   添加文件到缓存区，提交修改，由于修改文件的时候产生过了错误，
   所以应用补丁过程就停在了修改文件环节，再继续执行时我们就需要将需要提交的文件添加到缓存区

 - 最后执行 `git am --continue` 来继续执行补丁的应用即可

以上，既是 `sha1 information is lacking or useless` 的解决办法，
后经同事指导，还有更加生猛的办法... ...直接将版本库 `.git` 拷贝过去覆盖... ...

> 参考链接：  
>   
> <http://stackoverflow.com/questions/25846189/git-am-error-patch-does-not-apply>
