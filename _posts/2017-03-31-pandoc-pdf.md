---
layout: post
title: 利用 Pandoc 将 Markdown 生成 Word/PDF 文件
date: 2017-03-31
categories: Notes
tags: Markdown Pandoc
syntax: gruvbox
---

Pandoc 是一个格式转化工具，可以用于各(luan)种(qi)各(ba)样(zao)的文件转换，
反正我是认不全官网上的[那个图](http://pandoc.org/diagram.jpg)（傲娇脸），
之前一直使用它将 Markdown 文件转换成 Html 文件，最近发现原来还可以生成 Word/PDF文件。

## Word 文件生成

将 Markdown 文件生成 Word 文件很简单，和 html 文件一样

```shell
> pandoc test.md -o test.docx
```

同时在生成时也可以使用 `-c` 参数为文档指定样式文件（ css 文件）

```shell
> pandoc test.md -o test.docx -c style.css
```

这里的样式与生成 html 时的样式一直，
针对 markdown 文档各个部分生成的 html 标签来应用，
如：在样式文档中定义的 `h1 { font-size: 24px; }` 
就会应用在以 `#` 开头的一级标题行。

## 生成 pdf

原本以为生成 pdf 与 docx 一样省事，然鹅... 报错打脸：

```shell
> pandoc test.md -o test.pdf
pandoc: pdflatex not found. pdflatex is needed for pdf output.
```

原来是因为 pandoc 在生成 pdf 文件的时候默认使用 pdflatex 引擎，
我的电脑上没有安装 Tex，所以才报错了，故下载之
（小生使用的是 [MiKTex](https://miktex.org/download)，
它会在缺少组件的时候自动下载相关包。）
  
接着继续执行命令：

```shell
> pandoc test.md -o test.pdf
! Package inputenc Error: Unicode char 鍔?(U+529E)
(inputenc)                not set up for use with LaTeX.

See the inputenc package documentation for explanation.
Type  H <return>  for immediate help.
 ...

l.53 \section{鍔炰簨澶勬竻鍗曟€濆瘑杈緘

Try running pandoc with --latex-engine=xelatex.
pandoc.exe: Error producing PDF
```

哎呀呀，又报错了，不过这次比较好，给了提示，
让我们试一试 `--latex-engine=xelatex` 参数，
pandoc 一般转换 pdf 使用的默认引擎是 pdflatex，
估计是不能识别 Unicode 字符串，导致无法支持中文，
所以这里建议我们换用 xelatex 引擎，执行之：

```shell
> pandoc test.md -o test.pdf --latex-engine=xelatex
```

文件生成，没有报错，堪称完美，以上... 哎，等一下，
打开文档一看，我的汉字呢... 汉字全部空白（pandoc 饿了？）
google 之发现，原来是没有指定字体的问题，加上参数 `-v`

```shell
> pandoc test.md -o test.pdf --latex-engine=xelatex -v mainfont="Microsoft YaHei"
```

以上，完美~~~

> 参考链接：  
>   
> <https://segmentfault.com/a/1190000004887280>
> <http://stackoverflow.com/questions/18178084/pandoc-and-foreign-characters>