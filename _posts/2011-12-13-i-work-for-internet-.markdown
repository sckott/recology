--- 
name: i-work-for-internet-
layout: post
title: I Work For The Internet !
date: 2011-12-13 09:35:00 -06:00
categories: 
- lubridate
- ggplot2
- twitteR
- plyr
- R
---

UPDATE: code and figure updated at 647 AM CST on 19 Dec '11. &nbsp;Also, see Jarrett Byrnes (improved) fork of my gist &nbsp;<a href="https://gist.github.com/1474802" target="_blank">here</a>.<br /><br /><br />The site <a href="http://iworkfortheinternet.org/" target="_blank">I WORK FOR THE INTERNET</a> is collecting pictures and first names (last name initials only) to show collective support <b><i>against</i></b> SOPA (the Stop Online Piracy Act). &nbsp;Please stop by their site and add your name/picture.<br /><br />I used the #rstats package twitteR, created by Jeff Gentry, to search for tweets from people signing this site with their picture, then plotted using ggplot2, and also used Hadley's lubridate to round timestamps on tweets to be able to bin tweets in to time slots for plotting.<br /><br />Tweets containing the phrase 'I work for the internet' by time:<br /><div class="separator" style="clear: both; text-align: center;"><br /></div><div class="separator" style="clear: both; text-align: center;"></div><div class="separator" style="clear: both; text-align: center;"><a href="http://1.bp.blogspot.com/-KALUtp3xQ_Q/Tu8ya0ZX0GI/AAAAAAAAFNM/JGVLj1qSRYs/s1600/Rplot01.png" imageanchor="1" style="clear: left; float: left; margin-bottom: 1em; margin-right: 1em;"><img border="0" height="326" src="http://1.bp.blogspot.com/-KALUtp3xQ_Q/Tu8ya0ZX0GI/AAAAAAAAFNM/JGVLj1qSRYs/s400/Rplot01.png" width="400" /></a></div><div class="separator" style="clear: both; text-align: center;"><br /></div><div class="separator" style="clear: both; text-align: center;"><br /></div><div class="separator" style="clear: both; text-align: center;"><br /></div><div class="separator" style="clear: both; text-align: center;"><br /></div><div class="separator" style="clear: both; text-align: left;">Here's the code as a GitHub gist. &nbsp; Sometimes the searchTwitter fxn doesn't returns an error, which I don't understand, but you can play with it:</div><div class="separator" style="clear: both; text-align: left;"><br /></div><div class="separator" style="clear: both; text-align: left;"><br /></div><br /><script src="https://gist.github.com/1472619.js?file=iworkfortheinternet.R"></script>
