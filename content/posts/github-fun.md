---
name: github-fun
layout: post
title: Fun with the GitHub API
date: 2014-11-26
author: Scott Chamberlain
sourceslug: _drafts/2014-11-26-github-fun.Rmd
tags:
- R
- API
- github
---



Recently I've had fun playing with the GitHub API, and here are some notes to self about this fun having.

## Setup

Get/load packages


```r
install.packages(c('devtools','jsonlite','httr','yaml'))
```


```r
library("devtools")
library("httr")
library("yaml")
```

## Define a vector of package names


```r
pkgs <- c("alm", "bmc", "bold", "clifro", "ecoengine",
  "elastic", "fulltext", "geonames", "gistr",
  "RNeXML", "rnoaa", "rnpn", "traits", "rplos", "rsnps",
  "rWBclimate", "solr", "spocc", "taxize", "togeojson", "treeBASE")
pkgs <- sort(pkgs)
```

## Define functions


```r
github_auth <- function(appname = getOption("gh_appname"), key = getOption("gh_id"),
                        secret = getOption("gh_secret")) {
  if (is.null(getOption("gh_token"))) {
    myapp <- oauth_app(appname, key, secret)
    token <- oauth2.0_token(oauth_endpoints("github"), myapp)
    options(gh_token = token)
  } else {
    token <- getOption("gh_token")
  }
  return(token)
}

make_url <- function(x, y, z) {
  sprintf("https://api.github.com/repos/%s/%s/%s", x, y, z)
}

process_result <- function(x) {
  stop_for_status(x)
  if (!x$headers$`content-type` == "application/json; charset=utf-8")
    stop("content type mismatch")
  tmp <- content(x, as = "text")
  jsonlite::fromJSON(tmp, flatten = TRUE)
}

parse_file <- function(x) {
  tmp <- gsub("\n\\s+", "\n", 
              paste(vapply(strsplit(x, "\n")[[1]], RCurl::base64Decode,
                           character(1), USE.NAMES = FALSE), collapse = " "))
  lines <- readLines(textConnection(tmp))
  vapply(lines, gsub, character(1), pattern = "\\s", replacement = "",
         USE.NAMES = FALSE)
}

request <- function(owner = "ropensci", repo, file="DESCRIPTION", ...) {
  req <- GET(make_url(owner, repo, paste0("contents/", file)), 
             config = c(token = github_auth(), ...))
  if(req$status_code != 200) { NA } else {
    cts <- process_result(req)$content
    parse_file(cts)
  }
}

has_term <- function(what, ...) any(grepl(what, request(...)))
has_file <- function(what, ...) if(all(is.na(request(file = what, ...)))) FALSE else TRUE
```

## Do stuff

Does a package depend on a particular package? e.g., look for `httr` in the `DESCRIPTION` file (which is the default file name in `request()` above)


```r
has_term("httr", repo="taxize")
#> [1] TRUE
has_term("maptools", repo="taxize")
#> [1] FALSE
```

Do a series of R packages have a file for how to contribute `CONTRIBUTING.md`?

Yes


```r
has_file("CONTRIBUTING.md", repo="taxize")
#> [1] TRUE
```

Many packages


```r
vapply(pkgs, function(x) has_file("CONTRIBUTING.md", repo=x), logical(1))
#>        alm        bmc       bold     clifro  ecoengine    elastic 
#>      FALSE      FALSE      FALSE      FALSE      FALSE      FALSE 
#>   fulltext   geonames      gistr     RNeXML      rnoaa       rnpn 
#>       TRUE      FALSE      FALSE       TRUE       TRUE      FALSE 
#>      rplos      rsnps rWBclimate       solr      spocc     taxize 
#>      FALSE      FALSE      FALSE      FALSE       TRUE       TRUE 
#>  togeojson     traits   treeBASE 
#>      FALSE      FALSE      FALSE
```

## Check rate limit

Define function


```r
rate_limit <- function(...) {
  token <- github_auth()
  req <- GET("https://api.github.com/rate_limit", config = c(token = token, ...))
  process_result(req)
}
```

Check it


```r
rate_limit()
#> $resources
#> $resources$core
#> $resources$core$limit
#> [1] 5000
#> 
#> $resources$core$remaining
#> [1] 4925
#> 
#> $resources$core$reset
#> [1] 1417031016
#> 
#> 
#> $resources$search
#> $resources$search$limit
#> [1] 30
#> 
#> $resources$search$remaining
#> [1] 30
#> 
#> $resources$search$reset
#> [1] 1417028069
#> 
#> 
#> 
#> $rate
#> $rate$limit
#> [1] 5000
#> 
#> $rate$remaining
#> [1] 4925
#> 
#> $rate$reset
#> [1] 1417031016
```

Convert time to reset to human readable form


```r
as.POSIXct(rate_limit()$rate$reset, origin="1970-01-01")
#> [1] "2014-11-26 11:43:36 PST"
```
