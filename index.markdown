---
layout: default
---

{% include introduction.markdown %}

### Recent Articles

<ul>
  {% for post in site.posts limit:5 %}
    <li><a href="{{ post.url }}">{{ post.title }}</a> on {{ post.date | date: "%b %d, %Y" }}</li>
  {% endfor %}
</ul>

Read more of my writing [here](/articles) and find out more about my past 
and present work [here](/about).