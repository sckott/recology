---
name: i-work-for-internet-
layout: post
title: I Work For The Internet !
author: Scott Chamberlain
date: 2011-12-13 09:35:00 -06:00
sourceslug: _posts/2011-12-13-i-work-for-internet.md
tags:
- lubridate
- ggplot2
- twitteR
- plyr
- R
---

UPDATE: code and figure updated at 647 AM CST on 19 Dec '11. Also, see Jarrett Byrnes (improved) fork of my gist [here][].

The site [I WORK FOR THE INTERNET][iwfti] is collecting pictures and first names (last name initials only) to show collective support against SOPA (the Stop Online Piracy Act). Please stop by their site and add your name/picture.

I used the #rstats package twitteR, created by Jeff Gentry, to search for tweets from people signing this site with their picture, then plotted using ggplot2, and also used Hadley's lubridate to round timestamps on tweets to be able to bin tweets in to time slots for plotting.

Tweets containing the phrase 'I work for the internet' by time:

![](http://1.bp.blogspot.com/-KALUtp3xQ_Q/Tu8ya0ZX0GI/AAAAAAAAFNM/JGVLj1qSRYs/s1600/Rplot01.png)

Here's the code as a GitHub gist. Sometimes the searchTwitter fxn doesn't returns an error, which I don't understand, but you can play with it:


{{< rawhtml >}}
<script src="https://gist.github.com/1472619.js?file=iworkfortheinternet.R"></script>
{{< /rawhtml >}}

[here]: https://gist.github.com/1474802
[iwfti]: http://iworkfortheinternet.org/
