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

*********

## UPDATE: changed data source so that the entire example can be run by anone on their own machine. Also, per Joachim's suggestion, I put a box around the blown up area of the map. Thoughts?

*********

## Here's a quick demo of creating a map with an inset within it using ggplot. The inset is achieved using the `gridExtra` package. 

*********

### Install libraries

{% highlight r linenos %}
library(ggplot2)
library(maps)
library(maptools)
library(gridExtra)
library(rgeos)
{% endhighlight %}


*********

### Create a data frame

{% highlight r linenos %}
dat <- data.frame(ecosystem = rep(c("oak", "steppe", "prairie"), each = 8), 
    lat = rnorm(24, mean = 51, sd = 1), lon = rnorm(24, mean = -113, sd = 5))
head(dat)
{% endhighlight %}



{% highlight text %}
  ecosystem   lat    lon
1       oak 51.81 -109.1
2       oak 50.41 -115.0
3       oak 52.20 -112.5
4       oak 51.67 -114.8
5       oak 49.75 -105.4
6       oak 51.42 -114.6
{% endhighlight %}


*********

### Get maps using the maps library

{% highlight r linenos %}
# Get a map of Canada
canadamap <- data.frame(map("world", "Canada", plot = FALSE)[c("x", "y")])

# Get a map of smaller extent
canadamapsmall <- canadamap[canadamap$x < -90 & canadamap$y < 54, ]

# Make inset rectangle to show area of zoom
canadamapsmall_ <- na.omit(canadamapsmall)  # omit NA's

# This should get your corner points for the box, picking min and max of
# lat and lon
insetrect <- data.frame(xmin = min(canadamapsmall_$x), xmax = max(canadamapsmall_$x), 
    ymin = min(canadamapsmall_$y), ymax = max(canadamapsmall_$y))
insetrect
{% endhighlight %}



{% highlight text %}
    xmin   xmax  ymin ymax
1 -133.1 -90.39 48.05   54
{% endhighlight %}


*********

### Make the maps

{% highlight r linenos %}
# The inset map, all of Canada
a <- ggplot(canadamap) + 
	theme_bw(base_size = 22) +
	geom_path(data = canadamap, aes(x, y), colour = "black", fill = "white") +
	geom_rect(data = insetrect, aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax), alpha=0, colour="blue", size = 1, linetype=1) +
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

### Print the two maps together, one an inset of the other
#### This approach uses the `gridExtra` package for flexible alignment, etc. of ggplot graphs

{% highlight r linenos %}
grid.newpage()
vpb_ <- viewport(width = 1, height = 1, x = 0.5, y = 0.5)  # the larger map
vpa_ <- viewport(width = 0.4, height = 0.4, x = 0.8, y = 0.8)  # the inset in upper right
print(b, vp = vpb_)
print(a, vp = vpa_)
{% endhighlight %}

![center](/img/unnamed-chunk-5.png) 


*********

### Get the .Rmd file used to create this post [at my github account](https://github.com/SChamberlain/schamberlain.github.com/blob/master/_drafts/2012-08-22-ggplot-inset-map.Rmd).

*********

### Written in [Markdown](http://daringfireball.net/projects/markdown/), with help from [knitr](http://yihui.name/knitr/), and nice knitr highlighting/etc. in in [RStudio](http://rstudio.org/).
