---
name: farmer-s-markets-data
layout: post
title: Farmer's markets data
author: Scott Chamberlain
date: 2011-02-16 22:41:00.001000 -06:00
sourceslug: _posts/2011-02-16-farmer-s-markets-data.md
tags:
- ggplot2
- Datasets
---

I combined USDA data on farmer's markets in the US with population census data to get an idea of the disparity in farmers markets by state, and then also expressed per capita. 

Download USDA data [here](http://www.ams.usda.gov/AMSv1.0/getfile?dDocName=STELPRDC5087258&amp;acct=frmrdirmkt). The formatted file I used below is [here](http://schamber.files.wordpress.com/2011/02/farmmarkets.xls) (in excel format, although I read into R as csv file). The census data is read from url as below. 

California has a ton of absolute number of farmer's markets, but Vermont takes the cake by far with number of markets per capita. Iowa comes in a distant second behind Vermont in markets per capita.

The code:

```r
######## Farmer's Markets #############
setwd("/Mac/R_stuff/Blog_etc/USDAFarmersMarkets") # Set to your working directory, this is where you want to call files from and write files to
install.packages(c("ggplot2", "RCurl"))  # install all packags required below
require(ggplot2) # plyr is libraried along with ggplot2, as ggplot2 uses plyr (as well as package reshape) functions
 
# read market data
markets <- read.csv("farmmarkets.csv")
markets$state <- as.factor(gsub("Wyoming ", "Wyoming", markets$LocAddState)) # there was a typo for Wyoming
markets <- na.omit(markets)
str(markets)
 
# read population census data
popcen <- read.csv("http://www.census.gov/popest/national/files/NST_EST2009_ALLDATA.csv")
popcen <- popcen[,c(4,5,6,17)]
str(popcen)
 
# summarize
markets_ <- ddply(markets, .(state), summarise,
 markets_n = length(LocAddState) 
)
 
markets_pop_ <- merge(markets_, popcen[,-1], by.x = "state", by.y = "NAME") # merge two data sets
markets_pop_$marketspercap <- markets_pop_$markets_n/markets_pop_$POPESTIMATE2009 # create column of markets per capita
markets_pop_$markets_n_st <- markets_pop_$markets_n/max(markets_pop_$markets_n)
markets_pop_$marketspercap_st <- markets_pop_$marketspercap/max(markets_pop_$marketspercap)
 
# plot
ggplot(melt(markets_pop_[,-c(2:5)]), aes(x = state, y = value, fill = variable)) +
 geom_bar(position = "dodge") +
 coord_flip()
ggsave("fmarkets_barplot.jpeg")
```

![](https://4.bp.blogspot.com/-ceVMLE6yfbk/TVyE31U6LTI/AAAAAAAAEaM/PM2LCHnLPMM/s640/fmarkets_barplot.jpeg)

```r
# maps
try_require("maps")
states <- map_data("state")
markets_pop_$statelow <- tolower(markets_pop_$state)
survey_sum_map <- merge(states, markets_pop_, by.x = "region", by.y = "statelow")
survey_sum_map <- survey_sum_map[order(survey_sum_map$order), ]
str(survey_sum_map)
 
qplot(long, lat, data = survey_sum_map, group = group, fill = markets_n, geom = "polygon", main = "Total farmer's markets") + 
 scale_fill_gradient(low="green", high="black")
ggsave("fmarkets_map_green.jpeg")
```

![](https://2.bp.blogspot.com/-I-Hqg4GtJs0/TVyE3I7BmYI/AAAAAAAAEaI/xNqBq4BqemI/s640/fmarkets_map_green.jpeg)
