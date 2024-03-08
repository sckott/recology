---
name: mocking-redirects
layout: post
title: "Mocking HTTP redirects"
date: 2021-11-27
author: Scott Chamberlain
sourceslug: _drafts/2021-11-27-mocking-redirects.Rmd
tags:
- R
- http
- API
---



You've experienced an [HTTP redirect][redwiki] (or URL redirect, or URL forwarding) even if you haven't noticed. We all use browsers (I assume, since you are reading this), either on a phone or laptop/desktop computer. Browsers don't show all the HTTP requests going on in the background, some of which are redirects. Redirection is used for various reasons, including to prevent broken links when web pages are moved, for privacy protection, to allow multiple domains to refer to a single web page, and more.

The easiest way to know if you hit a redirect is to look at the [HTTP status code][statuscodes]. Status codes in the 3xx series are mostly about URL redirection. The most common you will see are 301 (moved permanently), 302 (moved temporarily), and 303 (see other URI; usually in a "Location" response header).

When making HTTP requests in R, redirects are generally handled automatically by the three HTTP clients ([curl][], [crul][], [httr][]). That is, if a 300 series code is detected, all three clients will go to the next URI and so on until there are no more redirects. Automatically following redirects may not be default behavior elsewhere (e.g., `crul` command line tool doesn't follow redirects by default), so beware.

HTTP redirects become more tricky when we have to mock them in unit tests or other similar situations. I'll cover the various tools for doing this in R.

## Redirects

First, I'll show how redirects work with three major HTTP clients:

[curl][]

```r
library(curl)
h <- curl::new_handle()
handle_setopt(h, followlocation=0L)
out <- curl_fetch_memory("https://hb.opencpu.org/redirect/3", handle = h)
curl::parse_headers(out$headers, multiple = TRUE)
```

[crul][]


```r
library(crul)
con <- HttpClient$new("https://hb.opencpu.org/redirect/3")
res <- con$get()
length(res$response_headers_all)
#> [1] 4
```

[httr][]


```r
library(httr)
z <- GET("https://hb.opencpu.org/redirect/3")
length(z$all_headers)
#> [1] 4
```

## Mocking redirects

If you want to mock HTTP redirects, you can do so with the [webmockr][] package. Why would you want to mock redirects? 

Here's one use case: Say you have a library/package interacting with a web resource that you interact with. You want to add some unit tests for a route that responds with one or more redirects. You'd prefer not to perform real HTTP requests against the remote service for one reason or another (e.g., extreme rate limiting); and some would say it's best not to test with real HTTP requests b/c you want to test the functionality of the package, NOT the remote server with which it interacts.

In the following, we re-create what happens in real HTTP requests - but just status codes and the `location` response header.


```r
library(webmockr)
library(crul)
webmockr::enable()
```

Make a single stub with each redirect response with `to_return()`


```r
stub_request("get", "https://hb.opencpu.org/redirect/3") %>%
  to_return(status = 302, headers = list(location = "/relative-redirect/2")) %>%
  to_return(status = 302, headers = list(location = "/relative-redirect/1")) %>%
  to_return(status = 302, headers = list(location = "/get")) %>%
  to_return(status = 200, headers = list(location = "hooray, all done!"))
```

Then make four different requests to `https://hb.opencpu.org/redirect/3`:


```r
con <- crul::HttpClient$new(url = "https://hb.opencpu.org")
con$get("redirect/3")$response_headers
#> $location
#> [1] "/relative-redirect/2"
con$get("redirect/3")$response_headers
#> $location
#> [1] "/relative-redirect/1"
con$get("redirect/3")$response_headers
#> $location
#> [1] "/get"
con$get("redirect/3")$response_headers
#> $location
#> [1] "hooray, all done!"
```

This isn't ideal because it doesn't reflect how the real HTTP request equivalent happens.



Alernatively, you could set it up like this, with four separate stubs:


```r
stub_request("get", "https://hb.opencpu.org/redirect/3") %>%
  to_return(status = 302, headers = list(location = "/relative-redirect/2"))

stub_request("get", "https://hb.opencpu.org/relative-redirect/2") %>%
  to_return(status = 302, headers = list(location = "/relative-redirect/1"))

stub_request("get", "https://hb.opencpu.org/relative-redirect/1") %>%
  to_return(status = 302, headers = list(location = "/get"))

stub_request("get", "https://hb.opencpu.org/get") %>%
  to_return(status = 200, headers = list(location = "hooray, all done!"))
```

Then make each request in turn to each successive URL:


```r
con <- crul::HttpClient$new(url = "https://hb.opencpu.org")
con$get("redirect/3")$response_headers
#> $location
#> [1] "/relative-redirect/2"
con$get("relative-redirect/2")$response_headers
#> $location
#> [1] "/relative-redirect/1"
con$get("relative-redirect/1")$response_headers
#> $location
#> [1] "/get"
con$get("get")$response_headers
#> $location
#> [1] "hooray, all done!"
```


## Faking real redirects

[vcr][] is built on top of webmockr, but instead of returning stubbed responses and not allowing real HTTP requests, vcr stores real HTTP request/response and uses them on all subsequent matching HTTP requests.


I wrote this back in March 2021 - and was waiting to figure out how to deal with redirects in [vcr][] before finishing this post - see [vcr issue #220](https://github.com/ropensci/vcr/issues/220). I still have and may never get to that issue. If you are interested, please do stop by vcr and make a pull request to get it fixed. The major issue is that vcr stores only the first HTTP response in a redirect chain, rather than the last HTTP response - as I would expect. 


[redwiki]: https://en.wikipedia.org/wiki/URL_redirection
[crul]: https://github.com/ropensci/crul
[webmockr]: https://github.com/ropensci/webmockr
[vcr]: https://github.com/ropensci/vcr
[curl]: https://jeroen.cran.dev/curl/
[httr]: https://github.com/r-lib/httr
[statuscodes]: https://en.wikipedia.org/wiki/List_of_HTTP_status_codes
