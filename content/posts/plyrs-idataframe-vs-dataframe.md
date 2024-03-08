--- 
name: plyrs-idataframe-vs-dataframe
layout: post
title: plyr's idata.frame VS. data.frame
author: Scott Chamberlain
date: 2011-05-13 15:16:00.001000 -05:00
sourceslug: _posts/2011-05-13-plyrs-idataframe-vs-dataframe.md
tags: 
- plyr
- R
---


*********
I had seen the function idata.frame in plyr before, but not really tested it. From the plyr documentation: 

> _"An immutable data frame works like an ordinary data frame, except that when you subset it, it returns a reference to the original data frame, not a a copy. This makes subsetting substantially faster and has a big impact when you are working with large datasets with many groups."_

For example, although baseball is a data.frame, its immutable counterpart is a reference to it:

```r
> idata.frame(baseball)
<environment: 0x1022c74e8>
attr(,"class")
[1] "idf"         "environment"
```

Here are a few comparisons of operations on normal data frames and immutable data frames. Immutable data frames don't work with the doBy package, but do work with aggregate in base functions. Overall, the speed gains using idata.frame are quite impressive - I will use it more often for sure.

Here's the comparisons of idata.frames and data.frames:

*********


```r
# load packages
require(plyr)
require(reshape2)

# Make immutable data frame
baseball_i <- idata.frame(baseball)
```


### Example 1 - idata.frame more than twice as fast
```r
system.time(replicate(50, ddply(baseball, "year", summarise, mean(rbi))))
```



```
   user  system elapsed 
  8.509   0.266   8.798 
```



```r
system.time(replicate(50, ddply(baseball_i, "year", summarise, mean(rbi))))
```



```
   user  system elapsed 
  7.233   0.025   7.334 
```



### Example 2 - Bummer, this does not work with idata.frame's
```r
colwise(max, is.numeric)(baseball)  # works
```



```
  year stint   g  ab   r   h X2b X3b hr rbi sb cs  bb so ibb hbp sh sf
1 2007     4 165 705 177 257  64  28 73  NA NA NA 232 NA  NA  NA NA NA
  gidp
1   NA
```



```r
colwise(max, is.numeric)(baseball_i)  # doesn't work
```



```
Error: is.data.frame(df) is not TRUE
```


### Example 3 - idata.frame twice as fast
```r
system.time(replicate(100, baseball[baseball$year == "1884", ]))
```



```
   user  system elapsed 
  1.329   0.035   1.378 
```



```r
system.time(replicate(100, baseball_i[baseball_i$year == "1884", ]))
```



```
   user  system elapsed 
  0.674   0.015   0.689 
```


### Example 4 - idata.frame faster
```r
system.time(replicate(50, melt(baseball[, 1:4], id = 1)))
```



```
   user  system elapsed 
  7.129   0.506   7.691 
```



```r
system.time(replicate(50, melt(baseball_i[, 1:4], id = 1)))
```



```
   user  system elapsed 
  0.852   0.162   1.015 
```


### And you can go back to a data frame by
```r
d <- as.data.frame(baseball_i)
str(d)
```



```
'data.frame': 21699 obs. of  22 variables:
 $ id   : chr  "ansonca01" "forceda01" "mathebo01" "startjo01" ...
 $ year : int  1871 1871 1871 1871 1871 1871 1871 1872 1872 1872 ...
 $ stint: int  1 1 1 1 1 1 1 1 1 1 ...
 $ team : chr  "RC1" "WS3" "FW1" "NY2" ...
 $ lg   : chr  "" "" "" "" ...
 $ g    : int  25 32 19 33 29 29 29 46 37 25 ...
 $ ab   : int  120 162 89 161 128 146 145 217 174 130 ...
 $ r    : int  29 45 15 35 35 40 36 60 26 40 ...
 $ h    : int  39 45 24 58 45 47 37 90 46 53 ...
 $ X2b  : int  11 9 3 5 3 6 5 10 3 11 ...
 $ X3b  : int  3 4 1 1 7 5 7 7 0 0 ...
 $ hr   : int  0 0 0 1 3 1 2 0 0 0 ...
 $ rbi  : int  16 29 10 34 23 21 23 50 15 16 ...
 $ sb   : int  6 8 2 4 3 2 2 6 0 2 ...
 $ cs   : int  2 0 1 2 1 2 2 6 1 2 ...
 $ bb   : int  2 4 2 3 1 4 9 16 1 1 ...
 $ so   : int  1 0 0 0 0 1 1 3 1 0 ...
 $ ibb  : int  NA NA NA NA NA NA NA NA NA NA ...
 $ hbp  : int  NA NA NA NA NA NA NA NA NA NA ...
 $ sh   : int  NA NA NA NA NA NA NA NA NA NA ...
 $ sf   : int  NA NA NA NA NA NA NA NA NA NA ...
 $ gidp : int  NA NA NA NA NA NA NA NA NA NA ...
```


### idata.frame doesn't work with the doBy package
```r
require(doBy)
summaryBy(rbi ~ year, baseball_i, FUN = c(mean), na.rm = T)
```



```
Error: cannot coerce type 'environment' to vector of type 'any'
```


### But idata.frame works with aggregate in base (but with minimal speed gains) and aggregate is faster than ddply
```r
system.time(replicate(100, aggregate(rbi ~ year, baseball, mean)))
```



```
   user  system elapsed 
  4.998   0.346   5.373 
```



```r
system.time(replicate(100, aggregate(rbi ~ year, baseball_i, mean)))
```



```
   user  system elapsed 
  4.745   0.283   5.045 
```



```r
system.time(replicate(100, ddply(baseball_i, "year", summarise, mean(rbi))))
```



```
   user  system elapsed 
 13.293   0.042  13.428 
```

