---
layout: post
title: Jekyll 使用 Rouge 主题
date: 2017-03-28
categories: Notes
tags: Jekyll Github
syntax: base16
---

今日发现我的 Github Pages 中的代码并没有高亮，
看了一下代码发现，原来的没有设置 css 样式的原因，
我使用的代码高亮器是 rouge

{% highlight yaml %}
highlighter: rouge
{% endhighlight %}

`Rouge` 是一个纯 Ruby 编写的代码高亮器，可用于 60 多种语言的高亮，
其源代码托管在 [GitHub](https://github.com/jneen/rouge)上，
在其主页文档上了解到可以根据不同的样式生成 css 文件

{% highlight shell %}
> rougify style (theme_name) > (css_file.css)
{% endhighlight %}

其中：
 
 - `(theme_name)` 表示要使用的主题名称，详细的主题列表可以通过
   `rougify help style` 获得
 - `(css_file.css)` 表示要导出的样式文件路径

之后再在模板页面上引用导出的 css 文件即可

{% highlight liquid %}
<link rel="stylesheet" type="text/css" href="{{ site.url }}/stylesheets/(css_file.css)">
{% endhighlight %}

## 为不同的博客配置不同的样式文件

样式那么多，想要为不同的文章配置不同的样式肿么搞？
首先将所有的样式文件导出，这里小生用了一个小小的 shell 脚本：

{% highlight shell %}
for style in base16 base16.dark base16.monokai base16.monokai.light base16.solarized base16.solarized.dark colorful github gruvbox gruvbox.light molokai monokai monokai.sublime thankful_eyes
do 
    rougify style $style > syntax.$style.css
done
{% endhighlight %}

然后，为每一个文章的头信息中添加一个 syntax 属性，
用于表示应用于当前文章的样式

{% highlight yaml %}
syntax: colorful
{% endhighlight %}

最后，在模板上添加上相应的链接，并提供一个默认的样式文件 `syntax.css`

{% highlight liquid %}
{% raw %}
{% if page.syntax %}
    <link rel="stylesheet" type="text/css" href="{{ site.url }}/stylesheets/syntax/syntax.{{ page.syntax }}.css">
{% else %}
    <link rel="stylesheet" type="text/css" href="{{ site.url }}/stylesheets/syntax.css">
{% endif %}
{% endraw %}
{% endhighlight %}

至此，便可以随意的使用 Rouge 的样式了~~~

<blockquote>
<strong>TIPs：</strong>  
  
小生在用 Markdown 写文章时，发现引用块 `>` 中并不能添加代码块，
如果添加，就会将引用块截断... ... 
后来想到，引用快会被转换成 HTML 中的 `blockquote` 标签，
所以小生就选择了最为笨拙的方法，
硬编码进去 `blockquote` 标签不就阔以了，如下：

{% highlight html %}
{% raw %}
<blockquote>
this is test start
{% highlight shell %}
> this is code
{% endhighlight %}
this is test end
</blockquote>
{% endraw %}
{% endhighlight %}

</blockquote>