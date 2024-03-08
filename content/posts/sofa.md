---
name: sofa-reboot
layout: post
title: sofa - reboot
date: 2014-11-18
author: Scott Chamberlain
sourceslug: _drafts/2014-11-18-sofa.Rmd
tags:
- R
- API
- database
- couchdb
- nosql
---



I've reworked `sofa` recently after someone reported a bug in the package. Since the last post on this package on 2013-06-21, there's a bunch of changes:

* Removed the `sofa_` prefix from all functions as it wasn't really necessary. 
* Replaced `rjson`/`RJSONIO` with `jsonlite` for JSON I/O.
* New functions:
  * `revisions()` - to get the revision numbers for a document.
  * `uuids()` - get any number of UUIDs - e.g., if you want to set document IDs with UUIDs
* Most functions that deal with documents are prefixed with `doc_`
* Functions that deal with databases are prefixed with `db_`
* Simplified all code, reducing duplication
* All functions take `cushion` as the first parameter, for consistency sake.
* Changed `cushion()` function so that you can only register one cushion with each function call, 
and the function takes parameters for each element now, `name` (name of the cushion, whatever you want), `user` (user name, if applicable), `pwd` (password, if applicable), `type` (one of localhost, cloudant, or iriscouch), and `port` (if applicable).
* Changed package license from `CC0` to `MIT`

There's still more to do, but I'm pretty happy with the recent changes, and I hope at least some find the package useful. Also, would love people to try it out as all bugs are shallow and all that...

The following are a few examples of package use.

## Install CouchDB

Instructions [here](https://wiki.apache.org/couchdb/Installation)

## Start CouchDB

In your terminal 

```sh
couchdb
```

You can interact with your CouchDB databases as well in your browser. Navigate to <http://localhost:5984/_utils>

## Install sofa


```r
install.packages("devtools")
devtools::install_github("sckott/sofa")
```


```r
library('sofa')
```

## Authenticate - Cushions

As an example, here's how I set up details for connecting to my Cloudant couch:


```r
cushion(name = 'cloudant', user = '<user name>', pwd = '<password>', type = "cloudant")
```

By default there is a built-in `cushion` for localhost so you don't have to do that, unless you want to change those details, e.g., the port number. Right now cushions aren't preserved across R sessions, but working on that.

For example, I'll lay down a cushion for Cloudant, then I can call `cushions()` to see my cushions:


```r
cushion(name = 'cloudant', user = '<user name>', pwd = '<pwd>', type = "cloudant")
cushions()
```

By default, if you don't provide a cushion name, you are using localhost.

## Ping the server


```r
ping()
#> $couchdb
#> [1] "Welcome"
#> 
#> $uuid
#> [1] "2c10f0c6d9bd17205b692ae93cd4cf1d"
#> 
#> $version
#> [1] "1.6.0"
#> 
#> $vendor
#> $vendor$version
#> [1] "1.6.0-1"
#> 
#> $vendor$name
#> [1] "Homebrew"
```

Nice, it's working.

## Create a new database, and list available databases




```r
db_create(dbname='sofadb')
#> $ok
#> [1] TRUE
```

see if its there now


```r
db_list()
#>  [1] "_replicator" "_users"      "alm_couchdb" "cachecall"   "hello_earth"
#>  [6] "leothelion"  "mran"        "mydb"        "newdbs"      "sofadb"
```

## Create documents

Create a document WITH a name (uses PUT)


```r
doc1 <- '{"name":"sofa","beer":"IPA"}'
doc_create(dbname="sofadb", doc=doc1, docid="a_beer")
#> $ok
#> [1] TRUE
#> 
#> $id
#> [1] "a_beer"
#> 
#> $rev
#> [1] "1-a48c98c945bcc05d482bc6f938c89882"
```

Create a document WITHOUT a name (uses POST)


```r
doc2 <- '{"name":"sofa","icecream":"rocky road"}'
doc_create(dbname="sofadb", doc=doc2)
#> $ok
#> [1] TRUE
#> 
#> $id
#> [1] "c5c5c332c25cf62cc584647a81006f6d"
#> 
#> $rev
#> [1] "1-fd0da7fcb8d3afbfc5757d065c92362c"
```

## List documents

List them


```r
alldocs(dbname="sofadb")
#>                                 id                              key
#> 1                           a_beer                           a_beer
#> 2 c5c5c332c25cf62cc584647a81006f6d c5c5c332c25cf62cc584647a81006f6d
#>                                  rev
#> 1 1-a48c98c945bcc05d482bc6f938c89882
#> 2 1-fd0da7fcb8d3afbfc5757d065c92362c
```

Optionally include the documents, returned as a list by default as it would be hard to parse an endless number of document formats. 


```r
alldocs(dbname="sofadb", include_docs = TRUE)
#> $total_rows
#> [1] 2
#> 
#> $offset
#> [1] 0
#> 
#> $rows
#> $rows[[1]]
#> $rows[[1]]$id
#> [1] "a_beer"
#> 
#> $rows[[1]]$key
#> [1] "a_beer"
#> 
#> $rows[[1]]$value
#> $rows[[1]]$value$rev
#> [1] "1-a48c98c945bcc05d482bc6f938c89882"
#> 
#> 
#> $rows[[1]]$doc
#> $rows[[1]]$doc$`_id`
#> [1] "a_beer"
#> 
#> $rows[[1]]$doc$`_rev`
#> [1] "1-a48c98c945bcc05d482bc6f938c89882"
#> 
#> $rows[[1]]$doc$name
#> [1] "sofa"
#> 
#> $rows[[1]]$doc$beer
#> [1] "IPA"
#> 
#> 
#> 
#> $rows[[2]]
#> $rows[[2]]$id
#> [1] "c5c5c332c25cf62cc584647a81006f6d"
#> 
#> $rows[[2]]$key
#> [1] "c5c5c332c25cf62cc584647a81006f6d"
#> 
#> $rows[[2]]$value
#> $rows[[2]]$value$rev
#> [1] "1-fd0da7fcb8d3afbfc5757d065c92362c"
#> 
#> 
#> $rows[[2]]$doc
#> $rows[[2]]$doc$`_id`
#> [1] "c5c5c332c25cf62cc584647a81006f6d"
#> 
#> $rows[[2]]$doc$`_rev`
#> [1] "1-fd0da7fcb8d3afbfc5757d065c92362c"
#> 
#> $rows[[2]]$doc$name
#> [1] "sofa"
#> 
#> $rows[[2]]$doc$icecream
#> [1] "rocky road"
```

## Update a document

Change _IPA_ (india pale ale) to _IPL_ (india pale lager). We need to get revisions first as we need to include revision number when we update a document.


```r
(revs <- revisions(dbname = "sofadb", docid = "a_beer"))
#> [1] "1-a48c98c945bcc05d482bc6f938c89882"
```


```r
newdoc <- '{"name":"sofa","beer":"IPL"}'
doc_update(dbname = "sofadb", doc = newdoc, docid = "a_beer", rev = revs[1])
#> $ok
#> [1] TRUE
#> 
#> $id
#> [1] "a_beer"
#> 
#> $rev
#> [1] "2-f2390eb18b8f9a870c915c6712a7f65e"
```

Should be two revisions now


```r
revisions(dbname = "sofadb", docid = "a_beer")
#> [1] "2-f2390eb18b8f9a870c915c6712a7f65e"
#> [2] "1-a48c98c945bcc05d482bc6f938c89882"
```

## Get headers for a document


```r
doc_head(dbname = "sofadb", docid = "a_beer")
#> [[1]]
#> [[1]]$status
#> [1] 200
#> 
#> [[1]]$version
#> [1] "HTTP/1.1"
#> 
#> [[1]]$headers
#> $server
#> [1] "CouchDB/1.6.0 (Erlang OTP/17)"
#> 
#> $etag
#> [1] "\"2-f2390eb18b8f9a870c915c6712a7f65e\""
#> 
#> $date
#> [1] "Tue, 18 Nov 2014 21:19:16 GMT"
#> 
#> $`content-type`
#> [1] "application/json"
#> 
#> $`content-length`
#> [1] "88"
#> 
#> $`cache-control`
#> [1] "must-revalidate"
#> 
#> attr(,"class")
#> [1] "insensitive" "list"
```

## JSON vs. list

Across all/most functions you can request json or list as output with the `as` parameter. 


```r
db_list(as = "list")
#>  [1] "_replicator" "_users"      "alm_couchdb" "cachecall"   "hello_earth"
#>  [6] "leothelion"  "mran"        "mydb"        "newdbs"      "sofadb"
```


```r
db_list(as = "json")
#> [1] "[\"_replicator\",\"_users\",\"alm_couchdb\",\"cachecall\",\"hello_earth\",\"leothelion\",\"mran\",\"mydb\",\"newdbs\",\"sofadb\"]\n"
```

## Curl options

Across all functions you can pass in curl options. We're using `httr` internally, so you can use `httr` helper functions to make some curl options easier. Examples:

Verbose output


```r
library("httr")
db_list(config=verbose())
#>  [1] "_replicator" "_users"      "alm_couchdb" "cachecall"   "hello_earth"
#>  [6] "leothelion"  "mran"        "mydb"        "newdbs"      "sofadb"
```

Progress


```r
db_list(config=progress())
#> 
  |                                                                       
  |                                                                 |   0%
  |                                                                       
  |=================================================================| 100%
#>  [1] "_replicator" "_users"      "alm_couchdb" "cachecall"   "hello_earth"
#>  [6] "leothelion"  "mran"        "mydb"        "newdbs"      "sofadb"
```

Set a timeout


```r
db_list(config=timeout(seconds = 0.001))
#> 
#> Error in function (type, msg, asError = TRUE)  : 
#>    Operation timed out after 3 milliseconds with 0 out of -1 bytes received
```


## Full text search

I'm working on an R client for Elaticsearch called `elastic` - find it at [https://github.com/ropensci/elastic](https://github.com/ropensci/elastic)

Thinking about where to include functions to allow `elastic` and `sofa` to work together...if you have any thoughts hit up the issues. I'll probably include helper functions for CouchDB search in the `elastic` package, interfacing with the [CouchDB plugin for Elasticsearch](https://github.com/elasticsearch/elasticsearch-river-couchdb).
