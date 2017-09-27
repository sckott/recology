---
name: cranchecks-api
layout: post
title: "cranchecks: an API for CRAN check results"
date: 2017-09-27
author: Scott Chamberlain
sourceslug: _drafts/2017-09-27-cranchecks-api.Rmd
tags:
- API
- cran
- R
---

If you maintain an R package, or even use R packages, you may have looked at CRAN check results. These are essentially the results of running `R CMD CHECK` on a package. They do these for each package for each of a few different operating systems (debian, fedora, solaris, windows, osx) and different R versions (devel, release and patched).

* src: <https://github.com/ropensci/cchecksapi>
* base api url: <https://cranchecks.info>

CRAN maintainers look at these, and eventually will email maintainers if checks are bad enough. 

Which brings us to the motivation for the API: it'd be nice to have a modern way (read: an API) to check CRAN check results.

The tech looks like so:

* language: Ruby
* rest framework: Sinatra
* http requests for scraping: faraday
* database (storage): mongodb
* server: caddy
* scheduled scraping: cron (outside of docker)
* container: docker-compose

The API originally just had rOpenSci pkgs, which is a small 150ish. But it was easy enough to scale it, so the API has all CRAN packages now. 

The scraping step takes about 40 minutes and happens once a day. To clarify, results are up to date, so you can just use this API and not have to look up results on a cran mirror itself.

## API routes

Here's the breakdown

* `/`
* `/heartbeat`
* `/docs`
* `/pkgs`
* `/pkgs/:pkg_name:`

## /docs

Brings you to the docs at <https://github.com/ropensci/cchecksapi/blob/master/docs/api_docs.md>

## /pkgs

Get all packages, paginated 10 at a time by default. 

for example:

```
curl https://cranchecks.info/pkgs | jq .
```

Params:

* `limit` - number of records to return, default 10, max 1000
* `offset` - record to start at, deafult 0

## /pkgs/:pkg_name

Get a package by name.

for example:

```
curl https://cranchecks.info/pkgs/crul | jq .
```

Output looks like:

```json
{
  "error": null,
  "data": {
    "_id": "sofa",
    "package": "sofa",
    "checks": [
      {
        "Flavor": "r-devel-linux-x86_64-debian-clang ",
        "Version": "0.2.0 ",
        "Tinstall": "1.01 ",
        "Tcheck": "18.27 ",
        "Ttotal": "19.28 ",
        "Status": "OK",
        "check_url": "https://www.R-project.org/nosvn/R.check/r-devel-linux-x86_64-debian-clang/sofa-00check.html"
      },
...
```

The full URL is given for the check results, so you can go to it and check results, e.g., the top of the one above:

```
using R Under development (unstable) (2017-09-21 r73332)
using platform: x86_64-pc-linux-gnu (64-bit)
using session charset: UTF-8
checking for file ‘sofa/DESCRIPTION’ ... OK
this is package ‘sofa’ version ‘0.2.0’
checking package namespace information ... OK
checking package dependencies ... OK
checking if this is a source package ... OK
checking if there is a namespace ... OK
checking for executable files ... OK
checking for hidden files and directories ... OK
checking for portable file names ... OK
checking for sufficient/correct file permissions ... OK
checking whether package ‘sofa’ can be installed ... OK

...
```


## TO DO

* maybe caching for `/pkgs` route
* lowercase all keys just cause
* clean up api results: numerics should be actual numerics, make empty strings to `null`, maybe change a status of `OK` to `true` so its more JSONish
