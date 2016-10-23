---
layout: default
---

{% for post in site.posts %}
  <h1><a href="{{ post.url }}">{{ post.title }}</a></h1>
  <p class="text-muted">{{ post.date | date_to_string }}</p>
  <p>
    {{ post.excerpt | strip_html }}
  </p>
{% endfor %}
