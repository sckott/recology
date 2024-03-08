---
name: the-new-way
layout: post
title: the new way - httsnap
date: 2015-04-29
author: Scott Chamberlain
sourceslug: _drafts/2015-04-29-the-new-way.Rmd
tags:
- R
- http
- httr
---



Inspired by `httpie`, a Python command line client as a sort of drop in replacement for `curl`, I am playing around with something similar-ish in R, at least in spirit. I started a little R pkg called `httsnap` with the following ideas:

* The web is increasingly a JSON world, so set `content-type` and `accept` headers to `applications/json` by default 
* The workflow follows logically, or at least should, from, _hey, I got this url_, to _i need to add some options_, to _execute request_
* Whenever possible, transform output to data.frame's - facilitating downstream manipulation via `dplyr`, etc.
* Do `GET` requests by default. Specify a different type if you don't want `GET`. Some functionality does GET by default, though in some cases you need to specify GET
* You can use non-standard evaluation to easily pass in query parameters without worrying about `&`'s, URL escaping, etc. (see `Query()`)
* Same for body params (see `Body()`)

## Install

Install and load `httsnap`


```r
devtools::install_github("sckott/httsnap")
```


```r
library("httsnap")
library("dplyr")
```

## Functions so far

* `Get` - GET request
* `Query` - add query parameters
* `Authenticate` - add authentication details
* `Progress` - add progress bar
* `Timeout` - add a timeout
* `User_agent` - add a user agent
* `Verbose` - give verbose output
* `Body` - add a body
* `h` - add headers by key-value pair

These are named to avoid conflict with `httr`

## Intro

A simple `GET` request


```r
"https://httpbin.org/get" %>%
  Get()
#> $args
#> named list()
#> 
#> $headers
#> $headers$Accept
#> [1] "application/json, text/xml, application/xml, */*"
#> 
#> $headers$`Accept-Encoding`
#> [1] "gzip"
#> 
#> $headers$Host
#> [1] "httpbin.org"
#> 
#> $headers$`User-Agent`
#> [1] "curl/7.37.1 Rcurl/1.95.4.1 httr/0.6.1 httsnap/0.0.2.99"
#> 
#> 
#> $origin
#> [1] "24.21.209.71"
#> 
#> $url
#> [1] "https://httpbin.org/get"
```

You'll notice that `Get()` doesn't just get the response, but also checks for whether it was a good response (the HTTP status code), and extracts the data. 

Or you can just pass the URL into the function itself


```r
Get("https://httpbin.org/get")
#> $args
#> named list()
#> 
#> $headers
#> $headers$Accept
#> [1] "application/json, text/xml, application/xml, */*"
#> 
#> $headers$`Accept-Encoding`
#> [1] "gzip"
#> 
#> $headers$Host
#> [1] "httpbin.org"
#> 
#> $headers$`User-Agent`
#> [1] "curl/7.37.1 Rcurl/1.95.4.1 httr/0.6.1 httsnap/0.0.2.99"
#> 
#> 
#> $origin
#> [1] "24.21.209.71"
#> 
#> $url
#> [1] "https://httpbin.org/get"
```

You can buid up options by calling functions via pipes, and see what the options look like


```r
"https://httpbin.org/get" %>%
  Progress() %>%
  Verbose()
#> <http request> 
#>   url: https://httpbin.org/get
#>   config: 
#> Config: 
#> List of 4
#>  $ noprogress      :FALSE
#>  $ progressfunction:function (...)  
#>  $ debugfunction   :function (...)  
#>  $ verbose         :TRUE
```

Then execute the GET request when you're ready


```r
"https://httpbin.org/get" %>%
  Progress() %>%
  Verbose() %>%
  Get()
#> $args
#> named list()
#> 
#> $headers
#> $headers$Accept
#> [1] "application/json, text/xml, application/xml, */*"
#> 
#> $headers$`Accept-Encoding`
#> [1] "gzip"
#> 
#> $headers$Host
#> [1] "httpbin.org"
#> 
#> $headers$`User-Agent`
#> [1] "curl/7.37.1 Rcurl/1.95.4.1 httr/0.6.1 httsnap/0.0.2.99"
#> 
#> 
#> $origin
#> [1] "24.21.209.71"
#> 
#> $url
#> [1] "https://httpbin.org/get"
```

## Example 1

Get scholarly article metadata from the Crossref API


```r
"https://api.crossref.org/works" %>%
  Query(query = "ecology") %>% 
  .$message %>% 
  .$items %>% 
  select(DOI, title, publisher)
#>                            DOI                title
#> 1          10.4996/fireecology         Fire Ecology
#> 2              10.5402/ecology         ISRN Ecology
#> 3                 10.1155/8641         ISRN Ecology
#> 4      10.1111/(issn)1526-100x  Restoration Ecology
#> 5        10.1007/248.1432-184x    Microbial Ecology
#> 6      10.1007/10144.1438-390x   Population Ecology
#> 7      10.1007/10452.1573-5125      Aquatic Ecology
#> 8      10.1007/10682.1573-8477 Evolutionary Ecology
#> 9      10.1007/10745.1572-9915        Human Ecology
#> 10     10.1007/10980.1572-9761    Landscape Ecology
#> 11     10.1007/11258.1573-5052        Plant Ecology
#> 12     10.1007/12080.1874-1746  Theoretical Ecology
#> 13     10.1111/(issn)1442-9993      Austral Ecology
#> 14     10.1111/(issn)1439-0485       Marine Ecology
#> 15     10.1111/(issn)1365-2435   Functional Ecology
#> 16     10.1111/(issn)1365-294x    Molecular Ecology
#> 17     10.1111/(issn)1461-0248      Ecology Letters
#> 18   10.1002/9780470979365.ch7  Behavioural Ecology
#> 19 10.1111/fec.2007.21.issue-5                     
#> 20     10.1111/rec.0.0.issue-0                     
#>                            publisher
#> 1       Association for Fire Ecology
#> 2     Hindawi Publishing Corporation
#> 3     Hindawi Publishing Corporation
#> 4                    Wiley-Blackwell
#> 5  Springer Science + Business Media
#> 6  Springer Science + Business Media
#> 7  Springer Science + Business Media
#> 8  Springer Science + Business Media
#> 9  Springer Science + Business Media
#> 10 Springer Science + Business Media
#> 11 Springer Science + Business Media
#> 12 Springer Science + Business Media
#> 13                   Wiley-Blackwell
#> 14                   Wiley-Blackwell
#> 15                   Wiley-Blackwell
#> 16                   Wiley-Blackwell
#> 17                   Wiley-Blackwell
#> 18                   Wiley-Blackwell
#> 19                   Wiley-Blackwell
#> 20                   Wiley-Blackwell
```

## Example 2

Get Public Library of Science article metadata via their API, make a histogram of number of tweets for each article


```r
"https://api.plos.org/search" %>%
  Query(q = "*:*", wt = "json", rows = 100, 
        fl = "id,journal,alm_twitterCount",  
        fq = 'alm_twitterCount:[100 TO 10000]') %>% 
  .$response %>% 
  .$docs %>% 
  .$alm_twitterCount %>% 
  hist()
```
 
![image](/public/img/2015-04-29-the-new-way/unnamed-chunk-9-1.png)

## Notes

Okay, so this isn't drastically different from what `httr` already does, but its early days. 
