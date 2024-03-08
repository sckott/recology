---
name: multi-handle
layout: post
title: Dealing with multi handle errors
date: 2014-12-08
author: Scott Chamberlain
sourceslug: _drafts/2014-12-08-multi-handle.Rmd
tags:
- R
- API
- http
- httr
---



At rOpenSci we occasssionally hear from our users that they run into an error like:

```r
Error in function (type, msg, asError = TRUE)  : 
  easy handled already used in multi handle
```

This error occurs in the `httr` package that we use to do http requests to sources of data on the web. It happens when e.g., you make a lot of requests to a resource, then it gets interrupted somehow - then you make another call, and you get the error above. Let's try it with the an version of `httr` (`v0.5`): 


```r
library("httr")
# run, then esc to cause multi handle error
replicate(50, GET("http://google.com/"))
# then retry single call, which trows multi handle error
GET("http://google.com/")
#> Error in function (type, msg, asError = TRUE)  : 
#>   easy handled already used in multi handle
```

There are any number of reasons why your session may get interrupted, including an internet outage, the web service you are requesesting data from times out, etc.  There hasn't been a straight-forward way to handle this, until recently. 

In `httr` version `0.6`, there are two new functions `handle_find()` and `handle_reset()` to help deal with this error.

First, install newest httr from Github


```r
install.packages("devtools")
devtools::install_github("hadley/httr")
```


```r
library("httr")
```

Make a bunch of requests to google, interrupting part way through


```r
replicate(50, HEAD("http://google.com/"))
```

Then retry single call, which trows multi handle error


```r
HEAD("http://google.com/")
#> Error in function (type, msg, asError = TRUE)  : 
#>   easy handled already used in multi handle
```

Find handle


```r
handle_find("http://google.com/")
#> Host: http://google.com/ <0x10f3d1600>
```

Reset handle


```r
handle_reset("http://google.com/")
```

Try call again, this time it should work


```r
HEAD("http://google.com/")
#> Response [http://www.google.com/]
#>   Date: 2014-12-08 13:37
#>   Status: 200
#>   Content-Type: text/html; charset=ISO-8859-1
#> <EMPTY BODY>
```

## Usage in ropensci packages

We have more work to do yet to integrate this into our packages. It's great you can reset a handle as above, but to reset the handle you need to search for the URL used in the request, which our users would have to dig into the code for the function they are using. That is easy-ish to do, but perhaps not everyone knows they can get to the code easily.  So, we may try seting a parameter in functions that would let reset the handle to clear this error. 

## Note

Note that Hadley is planning on eliminating `RCurl` dependency (https://github.com/hadley/httr/issues/172), so there may be a different solution in the future. 
