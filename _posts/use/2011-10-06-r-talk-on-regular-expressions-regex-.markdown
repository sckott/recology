--- 
layout: post
title: R talk on regular expressions (regex)
date: 2011-10-06 10:50:00.001000 -05:00
tags: regex sciencetalks R
---

Written by ~ Scott Chamberlain

Regular expressions are a powerful in any language to manipulate, search, etc. data.

For example:

{% highlight r %}
> fruit <- c("apple", "banana", "pear", "pineapple")
> fruit
[1] "apple"     "banana"    "pear"      "pineapple"

> grep("a", fruit) # there is an "a" in each of the words
[1] 1 2 3 4
> 
> strsplit("a string", "s") # strsplit splits the string on the "s"
[[1]]
[1] "a "    "tring"
{% endhighlight %}


R base has many functions for regular expressions, see slide 9 of Ed's talk below.  The package stringr, created by Hadley Wickham, is a nice alternative that wraps the base regex functions for easier use. I highly recommend [stringr][].


Ed Goodwin, the coordinator of the [Houston R Users group][doi], gave a presentation to the group last night on regular expressions in R. It was a great talk, and he is allowing me to post his talk here.

Enjoy!  And thanks for sharing Ed!

<div style="width:425px" id="__ss_9576621"> <strong style="display:block;margin:12px 0 4px"><a href="http://www.slideshare.net/schamber/regexpresentationedgoodwin" title="regex-presentation_ed_goodwin" target="_blank">regex-presentation_ed_goodwin</a></strong> <iframe src="http://www.slideshare.net/slideshow/embed_code/9576621" width="425" height="355" frameborder="0" marginwidth="0" marginheight="0" scrolling="no"></iframe> <div style="padding:5px 0 12px"> View more <a href="http://www.slideshare.net/" target="_blank">presentations</a> from <a href="http://www.slideshare.net/schamber" target="_blank">schamber</a> </div> </div>

[stringr]: http://cran.r-project.org/web/packages/stringr/index.html
[doi]: http://www.meetup.com/houstonr/
