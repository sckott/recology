--- 
name: logistic-regression-barplot-fig
layout: post
title: Presenting results of logistic regression
date: 2012-01-10 07:50:00 -06:00
categories: 
- ggplot2
- gridExtra
- R
---

So my advisor pointed out this 'new' (well, 2004), way of plotting results of logistic regression results.  The idea was presented in a 2004 Bulletin of the Ecological Society of America issue ([here][]).  I tried to come up with a  solution using, what else, ggplot2.  I don't have it quite all the way down - I am missing the second y-axis values for the histograms, but someone smarter than me can figure that part out (note that Hadley doesn't want to support second y-axes in ggplot2, but they can probably be hacked on). 

Here's the code:
<script src="https://gist.github.com/1589136.js?file=loghistplot.R"></script>


Here's a few examples using datasets provided with the ggplot2 package:

`loghistplot(mtcars[,c("mpg","vs")])`

![mtcars plot](/images/posts/mtcarsplot.png)


`loghistplot(movies[,c("rating","Action")])`

![movies plot](/images/posts/moviesplot.png)



[here]: http://esapubs.org/bulletin/backissues/085-3/bulletinjuly2004_2column.htm#tools1