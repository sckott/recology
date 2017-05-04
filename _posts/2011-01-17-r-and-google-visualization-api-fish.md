---
name: r-and-google-visualization-api-fish
layout: post
title: "R and Google Visualization API: Fish harvests"
author: Scott Chamberlain
date: 2011-01-17 21:04:00.002000 -06:00
sourceslug: _posts/2011-01-17-r-and-google-visualization-api-fish.md
tags:
- ggplot2
- Ecology
- GoogleVis
- R
- Datasets
---

I recently gathered fish harvest data from the U.S. National Oceanic and Atmospheric Administarion (NOAA), which I downloaded from <a href="http://infochimps.com/">Infochimps</a>. The data is fish harvest by weight and value, by species for 21 years, from 1985 to 2005.

Here is a link to a google document of the data I used below. I had to do some minor pocessing in Excel first; thus the link to this data.<br />https://spreadsheets.google.com/ccc?key=0Aq6aW8n11tS_dFRySXQzYkppLXFaU2F5aC04d19ZS0E&amp;hl=en

Get the original data from Infochimps here <a href="http://infochimps.com/datasets/domestic-fish-and-shellfish-catch-value-and-price-by-species-198">http://infochimps.com/datasets/domestic-fish-and-shellfish-catch-value-and-price-by-species-198</a>

```r
################# Fish harvest data ############################
setwd("/Mac/R_stuff/Blog_etc/Infochimps/Fishharvest") # Set path
library(ggplot2)
library(googleVis)
library(Hmisc)

fish <- read.csv("fishharvest.csv") # read data
fish2 <- melt(fish,id=1:3,measure=4:24) # melt table
year <- rep(1985:2005, each = 117)
fish2 <- data.frame(fish2,year) # replace year with actual values

# Google visusalization API
fishdata <- data.frame(subset(fish2,fish2$var == "quantity_1000lbs",-4),value_1000dollars=subset(fish2,fish2$var == "value_1000dollars",-4)[,4])
names(fishdata)[4] <- "quantity_1000lbs"
fishharvest <- gvisMotionChart(fishdata, idvar="species", timevar="year")
plot(fishharvest)
```

<div style="overflow: auto;"><div class="geshifilter"><pre class="r geshifilter-R" style="font-family: monospace;">fishdatagg2 &lt;- ddply<span style="color: #009900;">(</span>fish2<span style="color: #339933;">,</span>.<span style="color: #009900;">(</span>species<span style="color: #339933;">,</span><a href="http://inside-r.org/r-doc/stats/var"><span style="color: #003399; font-weight: bold;">var</span></a><span style="color: #009900;">)</span><span style="color: #339933;">,</span>summarise<span style="color: #339933;">,</span><br /> <a href="http://inside-r.org/r-doc/base/mean"><span style="color: #003399; font-weight: bold;">mean</span></a> = <a href="http://inside-r.org/r-doc/base/mean"><span style="color: #003399; font-weight: bold;">mean</span></a><span style="color: #009900;">(</span>value<span style="color: #009900;">)</span><span style="color: #339933;">,</span><br /> se = <a href="http://inside-r.org/r-doc/stats/sd"><span style="color: #003399; font-weight: bold;">sd</span></a><span style="color: #009900;">(</span>value<span style="color: #009900;">)</span>/sqrt<span style="color: #009900;">(</span><a href="http://inside-r.org/r-doc/base/length"><span style="color: #003399; font-weight: bold;">length</span></a><span style="color: #009900;">(</span>value<span style="color: #009900;">)</span><span style="color: #009900;">)</span><br /><span style="color: #009900;">)</span><br />fishdatagg2 &lt;- <a href="http://inside-r.org/r-doc/base/subset"><span style="color: #003399; font-weight: bold;">subset</span></a><span style="color: #009900;">(</span>fishdatagg2<span style="color: #339933;">,</span>fishdatagg2$var %in% <a href="http://inside-r.org/r-doc/base/c"><span style="color: #003399; font-weight: bold;">c</span></a><span style="color: #009900;">(</span><span style="color: blue;">"quantity_1000lbs"</span><span style="color: #339933;">,</span><span style="color: blue;">"value_1000dollars"</span><span style="color: #009900;">)</span><span style="color: #009900;">)</span><br />limit3 &lt;- aes<span style="color: #009900;">(</span>ymax = <a href="http://inside-r.org/r-doc/base/mean"><span style="color: #003399; font-weight: bold;">mean</span></a> + se<span style="color: #339933;">,</span> ymin = <a href="http://inside-r.org/r-doc/base/mean"><span style="color: #003399; font-weight: bold;">mean</span></a> - se<span style="color: #009900;">)</span><br />bysppfgrid &lt;- <a href="http://www.blogger.com/packages/ggplot">ggplot</a><span style="color: #009900;">(</span>fishdatagg2<span style="color: #339933;">,</span>aes<span style="color: #009900;">(</span>x=<a href="http://inside-r.org/r-doc/stats/reorder"><span style="color: #003399; font-weight: bold;">reorder</span></a><span style="color: #009900;">(</span>species<span style="color: #339933;">,</span><a href="http://inside-r.org/r-doc/base/rank"><span style="color: #003399; font-weight: bold;">rank</span></a><span style="color: #009900;">(</span><a href="http://inside-r.org/r-doc/base/mean"><span style="color: #003399; font-weight: bold;">mean</span></a><span style="color: #009900;">)</span><span style="color: #009900;">)</span><span style="color: #339933;">,</span>y=<a href="http://inside-r.org/r-doc/base/mean"><span style="color: #003399; font-weight: bold;">mean</span></a><span style="color: #339933;">,</span>colour=species<span style="color: #009900;">)</span><span style="color: #009900;">)</span> + geom_point<span style="color: #009900;">(</span><span style="color: #009900;">)</span> + geom_errorbar<span style="color: #009900;">(</span>limit3<span style="color: #009900;">)</span> + facet_grid<span style="color: #009900;">(</span>. ~ <a href="http://inside-r.org/r-doc/stats/var"><span style="color: #003399; font-weight: bold;">var</span></a><span style="color: #339933;">,</span> scales=<span style="color: blue;">"free"</span><span style="color: #009900;">)</span> + opts<span style="color: #009900;">(</span>legend.position=<span style="color: blue;">"none"</span><span style="color: #009900;">)</span> + coord_flip<span style="color: #009900;">(</span><span style="color: #009900;">)</span> + scale_y_continuous<span style="color: #009900;">(</span>trans=<span style="color: blue;">"log"</span><span style="color: #009900;">)</span><br />ggsave<span style="color: #009900;">(</span><span style="color: blue;">"bysppfgrid.jpeg"</span><span style="color: #009900;">)</span></pre></div></div><a href="http://www.inside-r.org/pretty-r" title="Created by Pretty R at inside-R.org">Created by Pretty R at inside-R.org</a><br /><br /><br /><div class="separator" style="clear: both; text-align: center;"><a href="http://2.bp.blogspot.com/_fANWq796z-w/TTRvw6n41xI/AAAAAAAAEYk/aaoDVQ_C8kk/s1600/bysppfgrid.jpeg" imageanchor="1" style="clear: left; float: left; margin-bottom: 1em; margin-right: 1em;"><img border="0" height="640" src="http://2.bp.blogspot.com/_fANWq796z-w/TTRvw6n41xI/AAAAAAAAEYk/aaoDVQ_C8kk/s640/bysppfgrid.jpeg" width="500" /></a></div>
