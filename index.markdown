---
layout: default
---

# Intro

 Hi! I'm baiyangcao, come form Affric

# CV

 This is my personal speak

# Blog

<ul>
  {% for post in site.posts %}
    <li>
      [{{ post.date | date_to_string }}]<a href="{{ post.url }}">{{ post.title }}</a>
    </li>
  {% endfor %}
</ul>
