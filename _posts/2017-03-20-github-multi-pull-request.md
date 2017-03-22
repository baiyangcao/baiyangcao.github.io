---
layout: post
title: GitHub针对同一版本库创建多个Pull Request
date: 2017-03-20
categories: Notes
tags: Github Git
excerpt: 近日在对某个翻译文档库进行 Pull Request 时，经库主提醒，对于不同章节的翻译需要创建不同的 Pull Request，否则库主在合并的时候不好合并。
---

近日在对某个翻译文档库进行 Pull Request 时，经库主提醒，
对于不同章节的翻译需要创建不同的 Pull Request，否则库主在合并的时候不好合并。  
  
对于我fork过来的版本库来说， `master` 分支上有三个提交，每一个对应一章的翻译，
然后在我创建 Pull Request 的时候就会对比我的版本库的 `master` 分支
与源版本库的 `master` 分支，此时会将三个提交全部选上，而且，
GitHub 上并没有选择提交的位置... 当时我就懵逼了...  
  
经过一番折腾之后找到答案，GitHub 创建 Pull Request 是根据分支来进行对比的，
所以如果想创建多个 Pull Request 则需要创建多个分支来提供不同的提交。  
  
故而，在本地版本库中，签出三个提交，创建不同的分支，并推送到GitHub：

{% highlight shell %}
// 在指定提交上创建分支
> git checkout -b [branch_name] [commit_id]
// 推送所有分支
> git push --all
{% endhighlight %}

之后，在去创建 Pull Request 的时候就可以通过选择不同的对比分支来区别提交了，
但是，又有了其他问题，因为我是直接在提交上创建的分支，所以，
对于三个提交创建的三个分支来说，每一分支都是包含上一个分支的提交的...  
  
所以，还需要把分支上没有必要的提交删除：

{% highlight shell %}
// 签出分支
> git checkout [branch_name]
// 调用rebase命令删除多余提交
> git rebase -i HEAD~4
// 修改完成后推送分支
> git pull --all
{%  endhighlight %}

> 注：  
> 
> 命令中的`HEAD~4`是要从哪个提交开始编辑，这里有三个提交需要编辑，
> 所以设置到当前提交向上的第四个提交开始编辑，
> rebase修改提交具体可参见[这篇]({% post_url 2017-03-19-git-rebase %}) 
  
这样就可以通过分支，为不同的提交创建不同的 Pull Request 啦~~~
其实，如果我在翻译的时候就按照**每次翻译新的一章时就创建一个新的分支**的规则的话，
就可以不用 `rebase` 来修改提交了。