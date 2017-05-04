---
name: just-for-fun-recoverygov-data-snooping
layout: post
title: "Just for fun: Recovery.gov data snooping"
author: Scott Chamberlain
date: 2011-01-11 10:52:00.006000 -06:00
sourceslug: _posts/2011-01-11-just-for-fun-recoverygov-data-snooping.md
tags:
- ggplot2
- R
- Datasets
---

<script async="true" src="http://pixel.propublica.org/pixel.js" type="text/javascript"></script>

<a href="http://projects.propublica.org/docdollars/" style="margin-left: 1em; margin-right: 1em;"><img border="0" src="http://4.bp.blogspot.com/_fANWq796z-w/TS_ACipsARI/AAAAAAAAEYA/s0V0Qr5GY0g/s1600/data-by-propublica.jpg" style="cursor: move;" /></a>

<div class="separator" style="clear: both; text-align: left;">Okay, so this isn't ecology related at all, but I like exploring data sets. So here goes...</div><div class="separator" style="clear: both; text-align: left;"><br /></div><div class="separator" style="clear: both; text-align: left;">Propublica has some awesome data sets available at their website: http://www.propublica.org/tools/</div><div class="separator" style="clear: both; text-align: left;">I played around with their data set on Recovery.gov (see hyperlink below in code). Here's some figures:</div><div class="separator" style="clear: both; text-align: left;"><br /></div><div class="separator" style="clear: both; text-align: left;">Mean award amount, ranked by mean amount, and also categorized by number of grants received ("nfund") by state (by size and color of point).&nbsp; Yes, there are 56 "states", which includes things like Northern Marian Islands (MP). Notice that California got the largest number of awards, but the mean award size was relatively small. </div><div class="separator" style="clear: both; text-align: center;"><a href="http://1.bp.blogspot.com/_fANWq796z-w/TSuMsqigYNI/AAAAAAAAEXo/XIv_2rHJ_J8/s1600/awardbystate.jpeg" imageanchor="1" style="clear: left; float: left; margin-bottom: 1em; margin-right: 1em;"><img border="0" height="640" src="http://1.bp.blogspot.com/_fANWq796z-w/TSuMsqigYNI/AAAAAAAAEXo/XIv_2rHJ_J8/s640/awardbystate.jpeg" width="572" /></a></div><div class="separator" style="clear: both; text-align: left;">Here is a figure by government organization that awarded each award, by mean award size (y-axis), number of awards (x-axis), and number of jobs created (numjobs=text size). Notice that the FCC (Federal Communications Commission) created nearly the most jobs despite not giving very large awards (although they did give a lot of awards). </div><div class="separator" style="clear: both; text-align: center;"><a href="http://3.bp.blogspot.com/_fANWq796z-w/TSyI0xFggbI/AAAAAAAAEX0/36J9f_n89tY/s1600/awardbyagency.jpeg" imageanchor="1" style="clear: left; float: left; margin-bottom: 1em; margin-right: 1em;"><img border="0" height="640" src="http://3.bp.blogspot.com/_fANWq796z-w/TSyI0xFggbI/AAAAAAAAEX0/36J9f_n89tY/s640/awardbyagency.jpeg" width="609" /></a></div><div class="separator" style="clear: both; text-align: left;"><br /></div><div class="separator" style="clear: both; text-align: left;"><br /></div><div class="separator" style="clear: both; text-align: left;"><br /></div><div class="separator" style="clear: both; text-align: left;">Here is a figure of mean awards by state on a map of the US:</div><div class="separator" style="clear: both; text-align: center;"><a href="http://4.bp.blogspot.com/_fANWq796z-w/TSuf8AnHDHI/AAAAAAAAEXs/pGxY_7ej7e8/s1600/bystatemapmeans.jpeg" imageanchor="1" style="clear: left; float: left; margin-bottom: 1em; margin-right: 1em;"><img border="0" height="537" src="http://4.bp.blogspot.com/_fANWq796z-w/TSuf8AnHDHI/AAAAAAAAEXs/pGxY_7ej7e8/s640/bystatemapmeans.jpeg" width="640" /></a></div><div class="separator" style="clear: both; text-align: left;"><br /></div><div class="separator" style="clear: both; text-align: left;"><br /></div><div class="separator" style="clear: both; text-align: left;">And by number of awards by state:</div><div class="separator" style="clear: both; text-align: center;"><a href="http://3.bp.blogspot.com/_fANWq796z-w/TSuf9SKo2KI/AAAAAAAAEXw/QxDiC-DbvFc/s1600/bystatemapnumber.jpeg" imageanchor="1" style="clear: left; float: left; margin-bottom: 1em; margin-right: 1em;"><img border="0" height="537" src="http://3.bp.blogspot.com/_fANWq796z-w/TSuf9SKo2KI/AAAAAAAAEXw/QxDiC-DbvFc/s640/bystatemapnumber.jpeg" width="640" /></a></div><div class="separator" style="clear: both; text-align: left;"><br /></div><div class="separator" style="clear: both; text-align: left;"><br /></div>

Here is the code:

```r
################################################################################
#################### Propublica Recovery.gov data           ####################
################################################################################
install.packages(c("ggplot2","maps","stringr"))
library(ggplot2)
library(maps)
library(stringr)
setwd("/Mac/R_stuff/Blog_etc") # Set working directory
theme_set(theme_bw())

# Read propublica data from file (download from here: http://propublica.s3.amazonaws.com/assets/recoverygov/propublica-recoverygov-primary-2.xls
propubdat <- read.csv("propublica-recoverygov-primary-2.csv")
str(propubdat)

# Summarize data
fundbystate <- ddply(propubdat,.(prime_state),summarise,
 meanfund = mean(award_amount),
 sefund = sd(award_amount)/sqrt(length(award_amount)),
 nfund = length(award_amount),
 numjobs = mean(number_of_jobs)
)

fundbyagency <- ddply(propubdat,.(funding_agency_name),summarise,
 meanfund = mean(award_amount),
 sefund = sd(award_amount)/sqrt(length(award_amount)),
 nfund = length(award_amount),
 numjobs = mean(number_of_jobs)
)


fun1 <- function(a) {str_c(paste(na.omit(str_extract(unlist(str_split(unlist(as.character(a[1])), " ")), "[A-Z]{1}"))), collapse="")} # Fxn to make funding agency name abbreviations within ddply below

fundbyagency2 <- ddply(fundbyagency,.(funding_agency_name),transform, # add to table funding agency name abbreviations
 agency_abbrev = fun1(funding_agency_name)
)

# Plot data, means and se's by state
limits <- aes(ymax = meanfund + sefund, ymin = meanfund - sefund)
dodge <- position_dodge(width=0.6)
awardbystate <- ggplot(fundbystate,aes(x=reorder(prime_state,meanfund),y=meanfund,colour=nfund)) + geom_point(aes(size=nfund),position=dodge) + coord_flip()  + geom_errorbar(limits, width=0.2,position=dodge) + opts(panel.grid.major = theme_blank(),panel.grid.minor=theme_blank(),legend.position=c(0.7,0.2)) + labs(x="State",y="Mean grant amount awarded +/- 1 s.e.")
ggsave("awardbystate.jpeg")

# Plot data, means and se's by funding agency
limits2 <- aes(ymax = meanfund + sefund, ymin = meanfund - sefund)
dodge <- position_dodge(width=0.6)
awardbyagency <- ggplot(fundbyagency2,aes(y=log(meanfund),x=log(nfund),label=agency_abbrev)) + geom_text(aes(size=numjobs))
ggsave("awardbyagency.jpeg")


# On US map
fundbystate2 <- read.csv("fundbystate.csv")

states <- map_data("state") # get state geographic data from the maps package
recovmap <- merge(states,fundbystate2,by="region") # merage datasets

qplot(long,lat,data=recovmap,group=group,fill=meanfund,geom="polygon")
ggsave("bystatemapmeans.jpeg")

qplot(long,lat,data=recovmap,group=group,fill=nfund,geom="polygon")
ggsave("bystatemapnumber.jpeg")
```

And the text file fundbystate2 <a href="http://web.me.com/scott_c1/Scott_Chamberlain/Other_files/fundbystate.csv">here</a>. I had the make this file separately so I could get in the spelled out state names as they were not provided in the propublica dataset.<br /><br />Source and disclaimer:<br />Data provided by <a href="http://www.propublica.org/">Propublica</a>. Data may contain errors and/or omissions.
