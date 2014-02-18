---
name: coffeehouse
layout: post
title: Coffeehouse - an aggregator for blog posts about data, data management, etc.
date: 2013-06-18
author: Scott Chamberlain
tags:
- data
- data management
- news
---

Have you heard of [DataONE](http://www.dataone.org/)? It stands for the Data Observation Network for Earth, and I am involved in the [Community Education and Engagement working group](http://www.dataone.org/working_groups/community-education-and-engagement) at DataONE. We try to communicate about data, data management, and similar things to scientists and other DataONE *stakeholders*. 

At our last meeting, we decided to start a blog aggregator to pull in to one place blog posts about data, data management, and related topics. Those reading this blog have likely heard of [R-Bloggers](http://www.r-bloggers.com/) - and there are many more aggregator blogs. We are calling this blog aggregator **Coffeehouse** - as it's sort of a place to gather to talk/read about ideas. Check it out [here][coffee]. If you blog about data management think about adding your blog to Coffeehouse - go to the [*Add your blog*][addblog] page to do so. A screenshot:

![](/public/img/coffeehouse.png)

********************

The blogs already added to Coffeehouse:

<i class="icon-coffee"></i> <a href="http://dataconservancy.org/blog/" target="_blank">Data Conservancy</a><br>
<i class="icon-coffee"></i> <a href="http://datapub.cdlib.org/" target="_blank">Data Pub</a><br>
<i class="icon-coffee"></i> <a href="http://www.datacite.org/" target="_blank">DataCite</a><br>
<i class="icon-coffee"></i> <a href="http://researchremix.wordpress.com/" target="_blank">Research Remix</a><br>
<i class="icon-coffee"></i> <a href="http://blogs.loc.gov/digitalpreservation/" target="_blank">The Signal: Digital Preservation</a>

********************

The tech/styling details:

+ As is obvious we are using Wordpress.org, with the Magazine Basic theme.
+ We don't accept comments - when someone clicks on the comments button it sends them back to the original post. This is on purpose so that the authors of the post get the comments on their own site.
+ On the top of each post there is an alert to tell you the post is syndicated, and gives a link to the original post. You can close this alert if it's annoying to you.
+ Style - we have strived to use clean and simple styling to make for a nice reading experience. A cluttered website makes reading painful. And using the [Twitter Bootstrap WP plugin][boot]
+ Icons: done using the [FontAwesome Wordpress Plugin][fawp].
+ Aggregating posts is done using the [FeedWordPress plugin][fwp].
+ The add your blog form: using the [Nina forms plugin][ninja]
+ Analytics: using the [Gauges WP plugin][gauges]

That's it. Let us know if you have any thoughts/comments.

[coffee]: https://coffeehouse.dataone.org/
[fawp]: https://github.com/rachelbaker/Font-Awesome-WordPress-Plugin
[addblog]: https://coffeehouse.dataone.org/add-your-blog/
[fwp]: http://feedwordpress.radgeek.com/
[ninja]: http://wpninjas.com/ninja-forms/
[boot]: http://www.icontrolwp.com/our-wordpress-plugins/wordpress-twitter-bootstrap-css-plugin-home/
[gauges]: http://wordpress.org/plugins/gauges/