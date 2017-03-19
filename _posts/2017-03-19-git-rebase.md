---
layout: post
title: git rebase 修改提交
date: 2017-03-19
categories: Notes
tags: Git
---

今天发现前几天的某一个提交因为忽略文件的问题而导致有几个文件没有提交，
需要修改一下某个提交，研究一下可以用rebase命令来完成，执行过程模拟如下：

环境搭建，版本库如下：

![init_commit]({{ site.url }}/images/git_rebase/init_commit.jpg)

文件目录如下：

![filelist]({{ site.url }}/images/git_rebase/filelist.png)

假设'test3.txt'那个提交缺了个test4.txt文件没有上传，而且提交信息有问题，下面开始修改

首先要将当前分支变基到想要修改的那个提交的父提交上，在这里是e29413e提交的父提交2101e49，也可以用HEAD~3来表示，但是这里出了点问题，因为当前目录中由没有暂存的修改，所以显示了如下界面：

![git_rebase]({{ site.url }}/images/git_rebase/git_rebase.jpg)

根据提示，先缓存当前工作目录中的变更：

![stash]({{ site.url }}/images/git_rebase/stash.jpg)

然后再执行变基命令：

{% highlight shell%}
$ git rebase -i HEAD~3
{% endhighlight %}

其中-i参数表示交互模式来执行变基命令，然后便会弹出交互界面：

![rebase_editor]({{ site.url }}/images/git_rebase/rebase_editor.jpg)

如上图所示的变基任务列表，#号开头的行是注释，显示了要如何修改从选定的这个提交到最新提交的所有提交，具体命令如下：

{% highlight shell%}
p, pick，使用提交命令，等于commit

r，reword，使用提交命令并修改提交信息

e，edit，使用提交命令但停止变基命令来修改提交（我用到的就是这个命令）

s，squash，使用提交命令但是与上一个提交合并

f，fixup，和squash命令一样，但是丢弃本次提交的日志信息

x，exec，使用shell执行命令（本行命令后的部分都是要再shell里执行的命令）

d，drop，删除这个提交
{% endhighlight %}

这里我们要编辑提交e29413e，使用edit命令，将第一行的pick命令改成edit，如下：

![rebase_edit]({{ site.url }}/images/git_rebase/rebase_edit.jpg)

然后保存关闭即可开始变基任务，显示如下：

![rebase_task]({{ site.url }}/images/git_rebase/rebase_task.jpg)

可以看到变基任务停止在了e29413e提交，此时我们可以进行提交的修改操作，添加缺失的test4.txt文件

{% highlight shell%}
$ git add test4.txt
{% endhighlight %}

然后执行命令`git commit --amend`完成提交修改，然后会弹出交互页面编辑提交信息，如下：

![commit_message]({{ site.url }}/images/git_rebase/commit_message.jpg)

编辑后保存关闭即可完成修改

然后继续执行下面的变基任务即可，如下：

![rebase_task_continue]({{ site.url }}/images/git_rebase/rebase_task_continue.jpg)

这时便可以看到修改提交已经完成了，如下：

![commit_finish]({{ site.url }}/images/git_rebase/commit_finish.jpg)

以为这个时候就完成了，果然还是图样~~此时，你的版本树可能会变得比较奇怪，像下面这样：

![commit_tree]({{ site.url }}/images/git_rebase/commit_tree.jpg)

不要着急，这是因为我们最初的时候将修改存在缓存区的缘故，将缓存区内容还原即可：

![stash_pop]({{ site.url }}/images/git_rebase/stash_pop.jpg)

此时再看版本树，便于原来的无二了
