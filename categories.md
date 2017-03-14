---
layout: blog
---

{% for category in site.categories %}
<h1 id="{{ category | first }}">{{ category | first }} ({{ category | last | size }})</h1>
  {% for post in category[1] %}
  <p> 
    <span class="glyphicon glyphicon-chevron-right"></span>
    <a href="{{ post.url }}">[{{ post.date | date_to_string }}]&nbsp;{{ post.title }}</a>
  </p>
  {% endfor %}
{% endfor %}
