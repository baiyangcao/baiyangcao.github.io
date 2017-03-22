---
layout: post
title: Github Pages(jekyll)文章标题显示为空
date: 2017-03-14
categories: Notes
tags: Github Jekyll Markdown
---

今天将写完的文章发布到Github Pages上的时候，出现了没有标题的情况，如下图：

![Jekyll Empty Title]({{ site.url }}/images/jekyll_empty_title/jekyll-empty-title.png)

将版本库下载到本地运行，想调试一下看看错误信息，果然，出现了如下错误：

```
Regenerating: 1 file(s) changed at 2017-03-14 16:11:15              Error: could not read file /home/bai/Documents/baiyangcao.github.io/_posts/2017-03-13-ef-sqlite.md: (<unknown>): found character that cannot start any token while scanning for the next token at line 3 column 8
...done in 3.719702386 seconds.
```

显示为`2017-03-13-ef-sqlite.md`文件的3行8列有为识别字符，打开文件看到如下：

```
title: `EntityFramework`使用SQLite数据库
```

原来是因为在标题中使用了<code>`</code>字符，无法识别，导致了报错的问题，去掉之后即好使了~~~