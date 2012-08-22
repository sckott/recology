---
name: ggplot-inset-map
layout: post
title: ggplot2 maps with insets
date: 2012-08-22
author: Scott Chamberlain
tags: 
- ggplot2
- map
- gridExtra
- inset
- R
---

## Here's a quick demo of creating a map with an inset within it using ggplot. The inset is achieved using the `gridExtra` package. 

## Install libraries, set directory, read file

{% highlight r %}
setwd("/Users/ScottMac/Dropbox/CANPOLIN_networks_ms/data")  # change to your directory
library(ggplot2)
library(maps)
library(maptools)
library(gridExtra)
library(rgeos)
dat <- read.csv("siteinfo_blog.csv")
head(dat)
{% endhighlight %}



{% highlight text %}
  ecosystem   lat    lon
1  oak sav. 48.81 -123.6
2  oak sav. 48.79 -123.6
3  oak sav. 48.82 -124.1
4  oak sav. 48.82 -124.1
5  oak sav. 48.78 -123.9
6  oak sav. 48.78 -123.9
{% endhighlight %}


*********

## Get maps

{% highlight r %}
# Get a map of Canada
canadamap <- data.frame(map("world", "Canada", plot = FALSE)[c("x", "y")])

# Get a map of smaller extent
canadamapsmall <- canadamap[canadamap$x < -90 & canadamap$y < 54, ]
{% endhighlight %}


*********

## Make the maps

{% highlight r %}
# The inset map, all of Canada
a <- ggplot(canadamap) + 
	theme_bw(base_size = 22) +
	geom_path(data = canadamap, aes(x, y), colour = "black", fill = "white") +
	scale_size(guide="none") +
	opts(panel.border = theme_rect(colour = 'black', size = 1, linetype=1),
			 panel.grid.major = theme_blank(), panel.grid.minor=theme_blank(),
			 panel.background = theme_rect( fill = 'white'),
			 legend.position = c(0.15,0.80), legend.key = theme_blank(),
			 axis.ticks = theme_blank(), axis.text.x=theme_blank(),
			 axis.text.y=theme_blank()) +
	labs(x = '', y = '')

# The larger map, zoomed in, with the data
b <- ggplot(dat, aes(lon, lat, colour=ecosystem)) +
	theme_bw(base_size = 22) +
	geom_jitter(size=4, alpha=0.6) +
	geom_path(data = canadamapsmall, aes(x, y), colour = "black", fill = "white") +
	scale_size(guide="none") +
	opts(panel.border = theme_rect(colour = 'black', size = 1, linetype=1),
			 panel.grid.major = theme_blank(), panel.grid.minor=theme_blank(),
			 panel.background = theme_rect( fill = 'white'),
			 legend.position = c(0.1,0.20), legend.text=theme_text(size=12, face='bold'), 
			 legend.title=theme_text(size=12, face='bold'), legend.key = theme_blank(),
			 axis.ticks = theme_segment(size = 2)) +
	labs(x = '', y = '')
{% endhighlight %}


*********

## Print the two maps together, one an inset of the other
### This approach uses the `gridExtra` package for flexible alignment, etc. of ggplot graphs

{% highlight r %}
grid.newpage()
vpb_ <- viewport(width = 1, height = 1, x = 0.5, y = 0.5)  # the larger map
vpa_ <- viewport(width = 0.4, height = 0.4, x = 0.8, y = 0.8)  # the inset in upper right
print(b, vp = vpb_)
print(a, vp = vpa_)
{% endhighlight %}

![center](/img/unnamed-chunk-4.png) 


*********

### Written in [Markdown](http://daringfireball.net/projects/markdown/), with help from [knitr](http://yihui.name/knitr/), and nice knitr highlighting/etc. in in [RStudio](http://rstudio.org/).