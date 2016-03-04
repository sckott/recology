---
name: request-hello-world
layout: post
title: request - a high level HTTP client for R
date: 2016-01-05
author: Scott Chamberlain
sourceslug: _drafts/2016-01-05-request-hello-world.Rmd
tags:
- R
- api
- http
- DSL
- httr
---



`request` is DSL for http requests for R, and is inspired by the CLI tool [httpie](https://github.com/jakubroztocil/httpie). It's built on `httr`.

The following were driving principles for this package:

* The web is increasingly a JSON world, so we assume `applications/json` by default, but give back other types if not
* The workflow follows logically, or at least should, from, _hey, I got this url_, to _i need to add some options_, to _execute request_ - and functions support piping so that you can execute functions in this order
* Whenever possible, we transform output to data.frame's - facilitating downstream manipulation via `dplyr`, etc.
* We do `GET` requests by default. Specify a different type if you don't want `GET`. Given `GET` by default, this client is optimized for consumption of data, rather than creating new things on servers
* You can use non-standard evaluation to easily pass in query parameters without worrying about `&`'s, URL escaping, etc. (see `api_query()`)
* Same for body params (see `api_body()`)

The following is a brief demo of some of the package functionality:

## Install

From CRAN


```r
install.packages("request")
```

Or from GitHub


```r
devtools::install_github("sckott/request")
```


```r
library("request")
```

## Execute on last pipe

When using pipes (`%>%`) in `request`, we autodetect last piped command, and execute `http()` if it's the last. If not the last, the output gets passed to the next command, and so on. This feature (and `magrittr`) were done by Stefan Milton Bache.

This feature is really nice because a) it's one less thing you need to do, and b) you only need to care about the request itself.

You can escape auto-execution if you use the function `peep()`, which prints out a summary of the request you've created, but does not execute an HTTP request.

## HTTP Requests

A high level function `http()` wraps a lower level `R6` object `RequestIterator`, which holds a series of variables and functions to execute `GET` and `POST` requests, and will hold other HTTP verbs as well. In addition, it can hold state, which will allow us to do paging internally for you (see below). You have direct access to the `R6` object if you call `http_client()` instead of `http()`.

## NSE and SE

Most if not all functions in `request` support non-standard evaluation (NSE) as well as standard evaluation (SE). If a function supports both, there's a version without an underscore for NSE, while a version with an underscore is for SE. For example, here, we make a HTTP request by passing a base URL, then a series of paths that get combined together. First the NSE version


```r
api('https://api.github.com/') %>%
  api_path(repos, ropensci, rgbif, issues)
```

Then the SE version


```r
api('https://api.github.com/') %>%
  api_path_('repos', 'ropensci', 'rgbif', 'issues')
```

## Building API routes

The first thing you'll want to do is lay out the base URL for your request. The function `api()` is your friend.

`api()` works with full or partial URLs:


```r
api('https://api.github.com/')
#> URL: https://api.github.com/
api('http://api.gbif.org/v1')
#> URL: http://api.gbif.org/v1
api('api.gbif.org/v1')
#> URL: api.gbif.org/v1
```

And works with ports, full or partial


```r
api('http://localhost:9200')
#> URL: http://localhost:9200
api('localhost:9200')
#> URL: http://localhost:9200
api(':9200')
#> URL: http://localhost:9200
api('9200')
#> URL: http://localhost:9200
api('9200/stuff')
#> URL: http://localhost:9200/stuff
```

## Make HTTP requests

The above examples with `api()` are not passed through a pipe, so only define a URL, but don't do an HTTP request. To make an HTTP request, you can either pipe a url or partial url to e.g., `api()`, or call `http()` at the end of a string of function calls:


```r
'https://api.github.com/' %>% api()
#> $current_user_url
#> [1] "https://api.github.com/user"
#>
#> $current_user_authorizations_html_url
#> [1] "https://github.com/settings/connections/applications{/client_id}"
#>
#> $authorizations_url
#> [1] "https://api.github.com/authorizations"
#>
#> $code_search_url
...
```

Or


```r
api('https://api.github.com/') %>% http()
#> $current_user_url
#> [1] "https://api.github.com/user"
#>
#> $current_user_authorizations_html_url
#> [1] "https://github.com/settings/connections/applications{/client_id}"
#>
#> $authorizations_url
#> [1] "https://api.github.com/authorizations"
#>
#> $code_search_url
...
```

`http()` is called at the end of a chain of piped commands, so no need to invoke it. However, you can if you like.

## Templating

```r
repo_info <- list(username = 'craigcitro', repo = 'r-travis')
api('https://api.github.com/') %>%
  api_template(template = 'repos/{{username}}/{{repo}}/issues', data = repo_info)
#> [[1]]
#> [[1]]$url
#> [1] "https://api.github.com/repos/craigcitro/r-travis/issues/164"
#>
#> [[1]]$labels_url
#> [1] "https://api.github.com/repos/craigcitro/r-travis/issues/164/labels{/name}"
#>
#> [[1]]$comments_url
#> [1] "https://api.github.com/repos/craigcitro/r-travis/issues/164/comments"
#> ...
```

## Set paths

`api_path()` adds paths to the base URL


```r
api('https://api.github.com/') %>%
  api_path(repos, ropensci, rgbif, issues) %>%
  peep
#> <http request>
#>   url: https://api.github.com/
#>   paths: repos/ropensci/rgbif/issues
#>   query:
#>   body:
#>   paging:
#>   headers:
#>   rate limit:
#>   retry (n/delay (s)): /
#>   error handler:
#>   config:
```

## Query


```r
api("http://api.plos.org/search") %>%
  api_query(q = ecology, wt = json, fl = journal) %>%
  peep
#> <http request>
#>   url: http://api.plos.org/search
#>   paths:
#>   query: q=ecology, wt=json, fl=journal
#>   body:
#>   paging:
#>   headers:
#>   rate limit:
#>   retry (n/delay (s)): /
#>   error handler:
#>   config:
```

## Headers


```r
api('http://httpbin.org/headers') %>%
  api_headers(`X-FARGO-SEASON` = 3, `X-NARCOS-SEASON` = 5) %>%
  peep
#> <http request>
#>   url: http://httpbin.org/headers
#>   paths:
#>   query:
#>   body:
#>   paging:
#>   headers:
#>     X-FARGO-SEASON: 3
#>     X-NARCOS-SEASON: 5
#>   rate limit:
#>   retry (n/delay (s)): /
#>   error handler:
#>   config:
```

## curl configuration

`httr` is exported in `request`, so you can use `httr` functions like `verbose()` to get verbose curl output


```r
api('http://httpbin.org/headers') %>%
  api_config(verbose())
#> -> GET /headers HTTP/1.1
#> -> Host: httpbin.org
#> -> User-Agent: curl/7.43.0 curl/0.9.4 httr/1.0.0 request/0.1.0
#> -> Accept-Encoding: gzip, deflate
#> -> Accept: application/json, text/xml, application/xml, */*
#> ->
#> <- HTTP/1.1 200 OK
#> <- Server: nginx
#> <- Date: Sun, 03 Jan 2016 16:56:29 GMT
#> <- Content-Type: application/json
#> <- Content-Length: 227
#> <- Connection: keep-alive
#> <- Access-Control-Allow-Origin: *
#> <- Access-Control-Allow-Credentials: true
#> <-
#> $headers
#> $headers$Accept
#> [1] "application/json, text/xml, application/xml, */*"
#> ...
```

## Coming soon

There's a number of interesting features that should be coming soon to `request`.

* Paging - a paging helper will make it easy to do paing, and will attempt to handle any parameters used for paging. Some user input will be required, like what parameter names are, and how many records you want returned  [sckott/request#2](https://github.com/sckott/request/issues/2)
* Retry - a retry helper will make it easy to retry http requests on any failure, and execute a user defined function on failure [sckott/request#6](https://github.com/sckott/request/issues/6)
* Rate limit - a rate limit helper will add info to a set of many requests - still in early design stages [sckott/request#5](https://github.com/sckott/request/issues/5)
* Caching - a caching helper - may use in the background the in development [vcr R client](https://github.com/ropensci/vcr) when on CRAN or perhaps [storr](https://github.com/richfitz/storr)  [sckott/request#4](https://github.com/sckott/request/issues/4)
