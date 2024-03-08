---
name: processing-nested-lists
layout: post
title: Processing nested lists
author: Scott Chamberlain
date: 2011-04-28 17:41:00 -05:00
sourceslug: _posts/2011-04-28-processing-nested-lists.md
tags:
- R
---

So perhaps you have all figured this out already, but I was excited to figure out how to finally neatly get all the data frames, lists, vectors, etc. out of a nested list. It is as easy as nesting calls to the apply family of functions, in the case below, using plyr's apply like functions. Take this example:

```r
# Nested lists code, an example
# Make a nested list
mylist <- list()
mylist_ <- list()
for(i in 1:5) {
 for(j in 1:5) {
  mylist[[j]] <- i*j
 }
mylist_[[i]] <- mylist
}
 
# return values from first part of list
laply(mylist_[[1]], identity)
[1] 1 2 3 4 5

 
# return all values
laply(mylist_, function(x) laply(x, identity))
     1  2  3  4  5
[1,] 1  2  3  4  5
[2,] 2  4  6  8 10
[3,] 3  6  9 12 15
[4,] 4  8 12 16 20
[5,] 5 10 15 20 25

 
# perform some function, in this case sqrt of each value
laply(mylist_, function(x) laply(x, function(x) sqrt(x)))

  
        1        2        3        4        5
[1,] 1.000000 1.414214 1.732051 2.000000 2.236068
[2,] 1.414214 2.000000 2.449490 2.828427 3.162278
[3,] 1.732051 2.449490 3.000000 3.464102 3.872983
[4,] 2.000000 2.828427 3.464102 4.000000 4.472136
[5,] 2.236068 3.162278 3.872983 4.472136 5.000000
```
