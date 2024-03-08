---
name: httping
layout: post
title: httping - ping and time http requests
date: 2015-01-30
author: Scott Chamberlain
sourceslug: _drafts/2015-01-30-elasticsearch.Rmd
tags:
- R
- http
---



I've been working on a little thing called `httping` - a small R package that started as a pkg to Ping urls and time requests. It's a port of the Ruby gem [httping](https://github.com/jpignata/httping). The `httr` package is in `Depends` in this package, so its functions can be called directly, without having to load `httr` explicitly yourself.

In addition to timing requests, I've been tinkering with how to make http requests, with curl options accepting and returning the same object so they can be chained together, and then that object passed to a http verb like `GET`. Maybe this is a bad idea, but maybe not.

## Installation

Install:

One non-CRAN dep (`httpcode`) needs to be installed first.


```r
install.packages("devtools")
devtools::install_github("sckott/httpcode")
devtools::install_github("sckott/httping")
```

Then load package


```r
library("httping")
```

## Time requests

The idea with `time()` is to provide easy to use and understand information on how long http requests take to run. You should be able to pass in any `httr` verbs (`GET()`, `POST()`, etc.) to `time()`. `time()` repeats whatever http request you pass to it by default 10 times, but you can set the number of times to repeat in the `count` parameter. In addition, the `flood` parameter controls whether there is a delay between requests or not, and `delay` controls length of the delay. 

A `GET` request


```r
GET("http://google.com") %>% time(count=3)
#> 29.392 kb - http://www.google.com/ code:200 time(ms):92.444
#> 29.392 kb - http://www.google.com/ code:200 time(ms):82.127
#> 29.392 kb - http://www.google.com/ code:200 time(ms):85.587
#> <http time>
#>   Avg. min (ms):  82.127
#>   Avg. max (ms):  92.444
#>   Avg. mean (ms): 86.71933
```

A `POST` request


```r
POST("http://httpbin.org/post", body = "A simple text string") %>% time(count=3)
#> 10.144 kb - http://httpbin.org/post code:200 time(ms):267.574
#> 10.144 kb - http://httpbin.org/post code:200 time(ms):113.309
#> 10.144 kb - http://httpbin.org/post code:200 time(ms):99.938
#> <http time>
#>   Avg. min (ms):  99.938
#>   Avg. max (ms):  267.574
#>   Avg. mean (ms): 160.2737
```

The return object is a list with slots for all the `httr` response objects, the times for each request, and the average times. The number of requests, and the delay between requests are included as attributes.


```r
res <- GET("http://google.com") %>% time(count=3)
#> 29.392 kb - http://www.google.com/ code:200 time(ms):82.086
#> 29.392 kb - http://www.google.com/ code:200 time(ms):78.15
#> 29.392 kb - http://www.google.com/ code:200 time(ms):79.763
```


```r
attributes(res)
#> $names
#> [1] "times"    "averages" "request" 
#> 
#> $count
#> [1] 3
#> 
#> $delay
#> [1] 0.5
#> 
#> $class
#> [1] "http_time"
```

Or print a summary of a response, gives more detail


```r
res %>% summary()
#> <http time, averages (min max mean)>
#>   Total (s):           78.15 82.086 79.99967
#>   Tedirect (s):        26.695 34.319 29.80633
#>   Namelookup time (s): 0.025 0.03 0.028
#>   Connect (s):         0.028 0.034 0.032
#>   Pretransfer (s):     0.069 0.081 0.07633333
#>   Starttransfer (s):   45.44 49.326 47.95867
```

Messages are printed using `cat`, so you can suppress those using `verbose=FALSE`, like


```r
GET("http://google.com") %>% time(count=3, verbose = FALSE)
#> <http time>
#>   Avg. min (ms):  86.12
#>   Avg. max (ms):  94.035
#>   Avg. mean (ms): 89.12467
```


## Ping an endpoint

The idea with `ping()` is to simply return the http status code along with a message describing what that code means. That's it.

This function is a bit different, accepts a url as first parameter, but can accept any args passed on to `httr` verb functions, like `GET`, `POST`,  etc.


```r
"http://google.com" %>% ping()
#> <http ping> 200
#>   Message: OK
#>   Description: Request fulfilled, document follows
```

Or pass in additional arguments to modify request


```r
"http://google.com" %>% ping(config=verbose())
#> -> GET / HTTP/1.1
#> -> User-Agent: curl/7.37.1 Rcurl/1.95.4.5 httr/0.6.1
#> -> Host: google.com
#> -> Accept-Encoding: gzip
...cutoff
```

## Even simpler verbs

`httr` is already easy, but `Get()`:

* Allows use of an intuitive chaining workflow
* Parses data for you using `httr` built in format guesser, which should work in most cases

A simple GET request


```r
"http://httpbin.org/get" %>%
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
#> [1] "curl/7.37.1 Rcurl/1.95.4.5 httr/0.6.1"
#> 
#> 
#> $origin
#> [1] "24.21.209.71"
#> 
#> $url
#> [1] "http://httpbin.org/get"
```

You can buid up options by calling functions


```r
"http://httpbin.org/get" %>%
  Progress() %>%
  Verbose()
#> <http request> 
#>   url: http://httpbin.org/get
#>   config: 
#> Config: 
#> List of 4
#>  $ noprogress      :FALSE
#>  $ progressfunction:function (...)  
#>  $ debugfunction   :function (...)  
#>  $ verbose         :TRUE
```

Then eventually execute the GET request


```r
"http://httpbin.org/get" %>%
  Verbose() %>%
  Progress() %>%
  Get()
#> -> GET /get HTTP/1.1
#> -> User-Agent: curl/7.37.1 Rcurl/1.95.4.5 httr/0.6.1
#> -> Host: httpbin.org
#> -> Accept-Encoding: gzip
#> -> Accept: application/json, text/xml, application/xml, */*
#> -> 
#> <- HTTP/1.1 200 OK
#> <- Server: nginx
#> <- Date: Fri, 30 Jan 2015 17:38:58 GMT
#> <- Content-Type: application/json
#> <- Content-Length: 288
#> <- Connection: keep-alive
#> <- Access-Control-Allow-Origin: *
#> <- Access-Control-Allow-Credentials: true
#> <- 
#>   |=======================================| 100%
#> 
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
#> [1] "curl/7.37.1 Rcurl/1.95.4.5 httr/0.6.1"
#> 
#> 
#> $origin
#> [1] "24.21.209.71"
#> 
#> $url
#> [1] "http://httpbin.org/get"
#> 
```
