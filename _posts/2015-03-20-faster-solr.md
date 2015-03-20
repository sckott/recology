---
name: faster-solr
layout: post
title: Faster solr with csv
date: 2015-03-20
author: Scott Chamberlain
sourceslug: _drafts/2015-03-20-faster-solr.Rmd
tags:
- R
- solr
- database
---



With the [help of user input](https://github.com/ropensci/solr/issues/47), I've tweaked `solr` just a bit to make things faster using default setings. I imagine the main interface for people using the `solr` R client is via `solr_search()`, which used to have `wt=json` by default. Changing this to `wt=csv` gives better performance. And it sorta makes sense to use csv, as the point of using an R client is probably do get data eventually into a data.frame, so it makes sense to go csv format (Already in tabular format) if it's faster too.

## Install

Install and load `solr`


```r
devtools::install_github("ropensci/solr")
```


```r
library("solr")
library("microbenchmark")
```

## Setup

Define base url and fields to return


```r
url <- 'http://api.plos.org/search'
fields <- c('id','cross_published_journal_name','cross_published_journal_key',
            'cross_published_journal_eissn','pmid','pmcid','publisher','journal',
            'publication_date','article_type','article_type_facet','author',
            'author_facet','volume','issue','elocation_id','author_display',
            'competing_interest','copyright')
```

## json

The previous default for `solr_search()` used `json`


```r
solr_search(q='*:*', rows=10, fl=fields, base=url, wt = "json")
#> Source: local data frame [10 x 19]
#> 
#>                                                                    id
#> 1             10.1371/annotation/856f0890-9d85-4719-8e54-c27530ac94f4
#> 2       10.1371/annotation/856f0890-9d85-4719-8e54-c27530ac94f4/title
#> 3    10.1371/annotation/856f0890-9d85-4719-8e54-c27530ac94f4/abstract
#> 4  10.1371/annotation/856f0890-9d85-4719-8e54-c27530ac94f4/references
#> 5        10.1371/annotation/856f0890-9d85-4719-8e54-c27530ac94f4/body
#> 6             10.1371/annotation/8551e3d5-fdd5-413b-a253-170ba13b7525
#> 7       10.1371/annotation/8551e3d5-fdd5-413b-a253-170ba13b7525/title
#> 8    10.1371/annotation/8551e3d5-fdd5-413b-a253-170ba13b7525/abstract
#> 9  10.1371/annotation/8551e3d5-fdd5-413b-a253-170ba13b7525/references
#> 10       10.1371/annotation/8551e3d5-fdd5-413b-a253-170ba13b7525/body
#> Variables not shown: cross_published_journal_name (chr),
#>   cross_published_journal_key (chr), cross_published_journal_eissn (chr),
#>   pmid (chr), pmcid (chr), publisher (chr), journal (chr),
#>   publication_date (chr), article_type (chr), article_type_facet (chr),
#>   author (chr), author_facet (chr), volume (int), issue (int),
#>   elocation_id (chr), author_display (chr), competing_interest (chr),
#>   copyright (chr)
```

## csv

The default `wt` setting is now `csv`


```r
solr_search(q='*:*', rows=10, fl=fields, base=url, wt = "json")
#> Source: local data frame [10 x 19]
#> 
#>                                                                    id
#> 1             10.1371/annotation/856f0890-9d85-4719-8e54-c27530ac94f4
#> 2       10.1371/annotation/856f0890-9d85-4719-8e54-c27530ac94f4/title
#> 3    10.1371/annotation/856f0890-9d85-4719-8e54-c27530ac94f4/abstract
#> 4  10.1371/annotation/856f0890-9d85-4719-8e54-c27530ac94f4/references
#> 5        10.1371/annotation/856f0890-9d85-4719-8e54-c27530ac94f4/body
#> 6             10.1371/annotation/8551e3d5-fdd5-413b-a253-170ba13b7525
#> 7       10.1371/annotation/8551e3d5-fdd5-413b-a253-170ba13b7525/title
#> 8    10.1371/annotation/8551e3d5-fdd5-413b-a253-170ba13b7525/abstract
#> 9  10.1371/annotation/8551e3d5-fdd5-413b-a253-170ba13b7525/references
#> 10       10.1371/annotation/8551e3d5-fdd5-413b-a253-170ba13b7525/body
#> Variables not shown: cross_published_journal_name (chr),
#>   cross_published_journal_key (chr), cross_published_journal_eissn (chr),
#>   pmid (chr), pmcid (chr), publisher (chr), journal (chr),
#>   publication_date (chr), article_type (chr), article_type_facet (chr),
#>   author (chr), author_facet (chr), volume (int), issue (int),
#>   elocation_id (chr), author_display (chr), competing_interest (chr),
#>   copyright (chr)
```

## Compare times

When parsing to a data.frame (which `solr_search()` does by default), csv is quite a bit faster.


```r
microbenchmark(
  json = solr_search(q='*:*', rows=500, fl=fields, base=url, wt = "json", verbose = FALSE),
  csv = solr_search(q='*:*', rows=500, fl=fields, base=url, wt = "csv", verbose = FALSE), 
  times = 20
)
#> Unit: milliseconds
#>  expr      min       lq      mean    median        uq       max neval cld
#>  json 965.7043 1013.014 1124.1229 1086.3225 1227.9054 1441.8332    20   b
#>   csv 509.6573  520.089  541.5784  532.4546  548.0303  723.7575    20  a
```

## json vs xml vs csv

When getting raw data, csv is best, json next, then xml pulling up the rear.


```r
microbenchmark(
  json = solr_search(q='*:*', rows=1000, fl=fields, base=url, wt = "json", verbose = FALSE, raw = TRUE),
  csv = solr_search(q='*:*', rows=1000, fl=fields, base=url, wt = "csv", verbose = FALSE, raw = TRUE),
  xml = solr_search(q='*:*', rows=1000, fl=fields, base=url, wt = "xml", verbose = FALSE, raw = TRUE),
  times = 10
)
#> Unit: milliseconds
#>  expr       min       lq      mean    median        uq       max neval cld
#>  json 1110.9515 1142.478 1198.9981 1169.0808 1195.5709 1518.7412    10  b 
#>   csv  801.6871  802.516  826.0655  819.1532  835.0512  873.4266    10 a  
#>   xml 1507.1111 1554.002 1618.5963 1617.5208 1671.0026 1740.4448    10   c
```

## Notes

Note that `wt=csv` is only available in `solr_search()` and `solr_all()` because csv writer 
only returns the docs element in csv, dropping other elements, including facets, mlt, groups, 
stats, etc. 

Also, note the http client used in `solr` is `httr`, which passes in a gzip compression header by default, so as long as the server serving up the Solr data has compression turned on, that's all set.

Another way I've sped things up is if you use `wt=json` then parse to a data.frame, it uses `dplyr` which sped things up considerably.
