---
layout: post
title: 使用 Python 操作 Git 版本库 - GitPython
date: 2017-04-11
categories: Notes
tags: git python
---

GitPython 是一个用于操作 Git 版本库的 python 包，
它提供了一系列的对象模型(库 - `Repo`、树 - `Tree`、提交 - `Commit`等)
用于操作版本库中的相应对象。

## 版本库对象 - `Repo`

首先，使用包含 `.git` 文件夹的版本库路径创建 `git.Repo` 对象

{% highlight python %}
from git import Repo
# 创建版本库对象
repo = git.Repo(r'E:\Notes')
{% endhighlight %}

然后便可以使用这个 `Repo` 对象对版本库进行操作，如：

{% highlight python %}
# 版本库是否为空版本库
repo.bare

# 当前工作区是否干净
repo.is_dirty()

# 版本库中未跟踪的文件列表
repo.untracked_files

# 克隆版本库
repo.clone('clone_path')

# 压缩版本库到 tar 文件
with open('repo.tar', 'wb') as fp:
    repo.archive(fp)

# 新建分支
repo.create_head('branchname')

# 查看当前分支
repo.active_branch
{% endhighlight %}

## 索引/暂存区对象 - `Index`

Git 术语中，index 表示暂存区，为下次将要提交到版本库里的文件，
GitPython 提供 `Repo.Index` 来操作暂存区，如添加、提交操作

{% highlight python %}
index = repo.index
index.add(['new.txt'])
index.remove(['old.txt'])
index.commit('this is a test')
{% endhighlight %}

## 远程版本库操作 - `Remotes`

`Remotes` 用于操作远程版本库，可以通过 `Repo.remote` 方法获取远程版本库，
`Repo.Remotes` 属性获取远程版本库列表

{% highlight python %}
# 获取默认版本库 origin
remote = repo.remote()
# 从远程版本库拉取分支
remote.pull()
# 推送本地分支到远程版本库
remote.push()
# 重命名远程分支
# remote.rename('new_origin')
{% endhighlight %}

## 直接执行 Git 命令

一般我们在工作目录做了改变之后，就会调用 `git add` 命令添加文件到暂存区，
然后调用 `git commit` 命令提交更改，`Repo` 虽然没有添加、提交方法，
但取而代之提供了一个 `git.cmd.Git` 对象实现对 Git 命令的调用，
通过 `Repo.git` 来进行 Git 命令操作。
  
{% highlight python %}
git = repo.git
git.add('test1.txt') # git add test1.txt
git.commit('-m', 'this is a test') # git commit -m 'this is a test'
{% endhighlight %}

`Repo.git.[command]` 即相当于调用对应的 git 命令，而调用对应命令方法所用的参数，
会被转换成跟在命令后的参数。
  
而调用命令方法所用的命名参数会被转换成对应的完整参数，如：`git.command(flag=True)`
会被转换成 `git command --flag` 命令执行

## 总结

基本的 Git 操作可以概括如下：

{% highlight python %}
# 新建版本库对象
repo = Repo(r'E:\Notes')

# 进行文件修改操作

# 获取版本库暂存区
index = repo.index
# 添加修改文件
index.add(['new.txt'])
# 提交修改到本地仓库
index.commit('this is a test')

# 获取远程仓库
remote = repo.remote()
# 推送本地修改到远程仓库
remote.push()
{% endhighlight %}

> 参考链接：  
>   
> <https://my.oschina.net/hopeMan/blog/141221>  
>   
> <http://gitpython.readthedocs.io/en/stable/tutorial.html>