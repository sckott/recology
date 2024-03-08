---
name: taxize-1000
layout: post
title: 1000 commits to taxize
date: 2014-11-28
author: Scott Chamberlain
sourceslug: _drafts/2014-11-28-taxize-1000.Rmd
tags:
- R
- API
- taxize
---



Just today we've hit 1000 commits on `taxize`!  `taxize` is an R client to search across lots of taxonomic databases on the web. In honor of the 1000 commit milestone, here's some stats on the project.

Before that, lots of people have contributed to `taxize`, it's a big group effort:

* [Eduard Szöcs](https://github.com/EDiLD)
* [Zachary Foster](https://github.com/zachary-foster)
* [Carl Boettiger](https://github.com/cboettig)
* [Karthik Ram](https://github.com/karthik)
* [Jari Oksanen](https://github.com/jarioksa)
* [Francis Michonneau](https://github.com/fmichonneau)
* [Oliver Keyes](https://github.com/Ironholds)
* [David LeBauer](https://github.com/dlebauer)
* [Ben Marwick](https://github.com/benmarwick)
* [Anirvan Chatterjee](https://github.com/anirvan)

In addition, we've had lots of feedback from users, including feature requests and bug reports, making `taxize` a lot better.

## Setup


```r
library("devtools")
library("httr")
library("ggplot2")
library("stringr")
library("plyr")
library("dplyr")
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

gh_commits <- function(repo, owner = "ropensci", ...) {
  token <- github_auth()
  outout <- list(); iter <- 0; nexturl <- "dontstop"
  while(nexturl != "stop"){
    iter <- iter + 1
    req <- if(grepl("https:/", nexturl)) GET(nexturl, config = c(token = token)) else GET(make_url(owner, repo, "commits"), query = list(per_page=100), config = c(token = token))
    outout[[iter]] <- process_result(req)
    link <- req$headers$link
    nexturl <- if(is.null(link)){ "stop" } else {
      if(grepl("next", link)){
        stringr::str_extract(link, "https://[0-9A-Za-z/?=\\._&]+")
      } else {
        "stop"
      }
    }
  }
  outout <- outout[sapply(outout, function(x) !identical(x, list()))]
  dplyr::rbind_all(outout)
}

gh_issues <- function(repo, owner = "ropensci", ...) {
  token <- github_auth()
  outout <- list(); iter <- 0; nexturl <- "dontstop"
  while(nexturl != "stop"){
    iter <- iter + 1
    req <- if(grepl("https:/", nexturl)) GET(nexturl, query=list(state="all"), config = c(token = token)) else GET(make_url(owner, repo, "issues"), query = list(per_page=100, state="all"), config = c(token = token))
    outout[[iter]] <- process_result(req)
    link <- req$headers$link
    nexturl <- if(is.null(link)){ "stop" } else {
      if(grepl("next", link)){
        stringr::str_extract(link, "https://[0-9A-Za-z/?=\\._&]+")
      } else {
        "stop"
      }
    }
  }
  outout <- outout[sapply(outout, function(x) !identical(x, list()))]
  dplyr::rbind_all(outout)
}

gh_commit <- function(sha, repo, owner = "ropensci", ...) {
  token <- github_auth()
  req <- GET(paste0(make_url(owner, repo, "commits"), "/", sha),
             config = c(token = token, ...))
  process_result(req)
}

gh_verb <- function(owner = "ropensci", repo, verb, args=list(), ...) {
  token <- github_auth()
  req <- GET(make_url(owner, repo, verb), query=args, config = c(token = token, ...))
  process_result(req)
}
```

## Commits

List of commits


```r
out <- gh_commits("taxize")
```

Get changes for each commit


```r
changes <- vapply(out$sha, function(x) gh_commit(x, repo="taxize")$stats$total, numeric(1))
changesdf <-  data.frame(changes=unname(changes), sha=names(changes))
```

Combine


```r
out <- inner_join(out, changesdf)
```

Total changes through time (additions + deletions)


```r
ct <- function(x) as.POSIXct(x, format="%Y-%m-%dT%H:%M:%SZ", tz="UTC")
out %>%
  mutate(commit.committer.date = ct(commit.committer.date)) %>%
  ggplot(aes(x=commit.committer.date, y=changes)) +
    geom_area(fill="#87D2A0") +
    theme_grey(base_size = 20)
```

![](/2014-11-28-taxize-1000/unnamed-chunk-7-1.png)

By Authors


```r
out %>%
  group_by(author.login) %>%
  summarise(n = n()) %>%
  ggplot(aes(author.login, n)) +
    geom_bar(stat = "identity", fill="#87D2A0") +
    coord_flip() +
    theme_grey(base_size = 20)
```

![](/2014-11-28-taxize-1000/unnamed-chunk-8-1.png)

## Issues


```r
out <- gh_issues("taxize")
```

Number of issues


```r
NROW(out)
#> [1] 382
```

Number of open issues


```r
out %>%
  filter(state == "open") %>%
  NROW
#> [1] 35
```

Number of pull requests


```r
out %>%
  filter(!is.na(pull_request.url)) %>%
  NROW
#> [1] 119
```

## Forks, number of


```r
NROW(gh_verb(repo = "taxize", verb="forks"))
#> [1] 16
```

## Stars, number of


```r
NROW(gh_verb(repo = "taxize", verb="stargazers", args=list(per_page=100)))
#> [1] 44
```

## Watchers, number of


```r
NROW(gh_verb(repo = "taxize", verb="subscribers", args=list(per_page=100)))
#> [1] 12
```
