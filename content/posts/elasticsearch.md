---
name: elasticsearch
layout: post
title: elastic - Elasticsearch from R
date: 2015-01-29
author: Scott Chamberlain
sourceslug: _drafts/2015-01-29-elasticsearch.Rmd
tags:
- R
- http
- API
---



We've (ropensci) been working on an R client for interacting with [Elasticsearch](https://www.elasticsearch.org/) for a while now, first commit was November 2013.

Elasticsearch is a document database built on the JVM. `elastic` interacts with the Elasticsearch HTTP API, and includes functions for setting connection details to Elasticsearch instances, loading bulk data, searching for documents with both HTTP query variables and JSON based body requests. In addition, `elastic` provides functions for interacting with APIs for indices, documents, nodes, clusters, an interface to the cat API, and more.

Here's a few examples of what you can do.

Note: `elastic` was just pushed to CRAN. It just got accepted, so binaries may not be available, try again soon, or install from Github, or install from source from CRAN like `install.packages("https://cran.r-project.org/src/contrib/elastic_0.3.0.tar.gz", repos=NULL, type="source")`.

## Installation


```r
install.packages("elastic")
```

Or install development version:


```r
install.packages("devtools")
devtools::install_github("ropensci/elastic")
```

Then load package


```r
library("elastic")
```


## Install Elasticsearch

* [Elasticsearch installation help](https://www.elasticsearch.org/guide/en/elasticsearch/reference/current/_installation.html)

__Unix (linux/osx)__

Replace `1.4.1` with the version you are working with.

+ Download zip or tar file from Elasticsearch [see here for download](https://www.elasticsearch.org/overview/elkdownloads/), e.g., `curl -L -O https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.4.1.tar.gz`
+ Uncompress it: `tar -xvf elasticsearch-1.4.1.tar.gz`
+ Move it: `sudo mv /path/to/elasticsearch-1.4.1 /usr/local`
+ Navigate to /usr/local: `cd /usr/local`
+ Add shortcut: `sudo ln -s elasticsearch-1.4.1 elasticsearch`

On OSX, you can install via Homebrew: `brew install elasticsearch`

__Windows__

Windows users can follow the above, but unzip the zip file instead of uncompressing the tar file.

## Start Elasticsearch

* Navigate to elasticsearch: `cd /usr/local/elasticsearch`
* Start elasticsearch: `bin/elasticsearch`

I create a little bash shortcut called `es` that does both of the above commands in one step (`cd /usr/local/elasticsearch && bin/elasticsearch`).

__Note:__ Windows users should run the `elasticsearch.bat` file

## Initialize connection

The function `connect()` is used before doing anything else to set the connection details to your remote or local elasticsearch store. The details created by `connect()` are written to your options for the current session, and are used by `elastic` functions.


```r
connect()
```

On package load, your base url and port are set to `https://127.0.0.1` and `9200`, respectively. You can of course override these settings per session or for all sessions.

## Get data

Elasticsearch has a bulk load API to load data in fast. The format is pretty weird though. It's sort of JSON, but would pass no JSON linter. I include a few data sets in `elastic` so it's easy to get up and running, and so when you run examples in this package they'll actually run the same way (hopefully).

### Shakespeare data

Elasticsearch provides some data on Shakespeare plays. I've provided a subset of this data in this package. Get the path for the file specific to your machine:


```r
shakespeare <- system.file("examples", "shakespeare_data.json", package = "elastic")
```

Then load the data into Elasticsearch:


```r
docs_bulk(shakespeare)
```

### Public Library of Science (PLOS) data

A dataset inluded in the `elastic` package is metadata for PLOS scholarly articles.


```r
plosdat <- system.file("examples", "plos_data.json", package = "elastic")
docs_bulk(plosdat)
```

### Global Biodiversity Information Facility (GBIF) data

A dataset inluded in the `elastic` package is data for GBIF species occurrence records. Get the file path, then load:


```r
gbifdat <- system.file("examples", "gbif_data.json", package = "elastic")
docs_bulk(gbifdat)
```

GBIF geo data with a coordinates element to allow `geo_shape` queries


```r
gbifgeo <- system.file("examples", "gbif_geo.json", package = "elastic")
docs_bulk(gbifgeo)
```

## The Search function

The main interface to searching documents in your Elasticsearch store is the function `Search()`. I nearly always develop R software using all lowercase, but R has a function called `search()`, and I wanted to avoid collision with that function.

`Search()` is an interface to both the HTTP search API (in which queries are passed in the URI of the request, meaning queries have to be relatively simple), as well as the POST API, or the Query DSL, in which queries are passed in the body of the request (so can be much more complex).

There are a huge amount of ways you can search Elasticsearch documents - this tutorial covers some of them, and highlights the ways in which you interact with the R outputs.

### Search an index


```r
out <- Search(index="shakespeare")
out$hits$total
#> [1] 5000
```


```r
out$hits$hits[[1]]
#> $`_index`
#> [1] "shakespeare"
#> 
#> $`_type`
#> [1] "line"
#> 
#> $`_id`
#> [1] "4"
#> 
#> $`_version`
#> [1] 1
#> 
#> $`_score`
#> [1] 1
#> 
#> $`_source`
#> $`_source`$line_id
#> [1] 5
#> 
#> $`_source`$play_name
#> [1] "Henry IV"
#> 
#> $`_source`$speech_number
#> [1] 1
#> 
#> $`_source`$line_number
#> [1] "1.1.2"
#> 
#> $`_source`$speaker
#> [1] "KING HENRY IV"
#> 
#> $`_source`$text_entry
#> [1] "Find we a time for frighted peace to pant,"
```

### Search an index by type


```r
Search(index="shakespeare", type="act")$hits$hits[[1]]
#> $`_index`
#> [1] "shakespeare"
#> 
#> $`_type`
#> [1] "act"
#> 
#> $`_id`
#> [1] "2227"
#> 
#> $`_version`
#> [1] 1
#> 
#> $`_score`
#> [1] 1
#> 
#> $`_source`
#> $`_source`$line_id
#> [1] 2228
#> 
#> $`_source`$play_name
#> [1] "Henry IV"
#> 
#> $`_source`$speech_number
#> [1] 81
#> 
#> $`_source`$line_number
#> [1] ""
#> 
#> $`_source`$speaker
#> [1] "FALSTAFF"
#> 
#> $`_source`$text_entry
#> [1] "ACT IV"
```

### Return certain fields


```r
Search(index="shakespeare", fields=c('play_name','speaker'))$hits$hits[[1]]
#> $`_index`
#> [1] "shakespeare"
#> 
#> $`_type`
#> [1] "line"
#> 
#> $`_id`
#> [1] "4"
#> 
#> $`_version`
#> [1] 1
#> 
#> $`_score`
#> [1] 1
#> 
#> $fields
#> $fields$speaker
#> $fields$speaker[[1]]
#> [1] "KING HENRY IV"
#> 
#> 
#> $fields$play_name
#> $fields$play_name[[1]]
#> [1] "Henry IV"
```

### Sorting


```r
Search(index="shakespeare", type="act", sort="text_entry")$hits$hits[1:2]
#> [[1]]
#> [[1]]$`_index`
#> [1] "shakespeare"
#> 
#> [[1]]$`_type`
#> [1] "act"
#> 
#> [[1]]$`_id`
#> [1] "2227"
#> 
#> [[1]]$`_version`
#> [1] 1
#> 
#> [[1]]$`_score`
#> NULL
#> 
#> [[1]]$`_source`
#> [[1]]$`_source`$line_id
#> [1] 2228
#> 
#> [[1]]$`_source`$play_name
#> [1] "Henry IV"
#> 
#> [[1]]$`_source`$speech_number
#> [1] 81
#> 
#> [[1]]$`_source`$line_number
#> [1] ""
#> 
#> [[1]]$`_source`$speaker
#> [1] "FALSTAFF"
#> 
#> [[1]]$`_source`$text_entry
#> [1] "ACT IV"
#> 
#> 
#> [[1]]$sort
#> [[1]]$sort[[1]]
#> [1] "act"
#> 
#> 
#> 
#> [[2]]
#> [[2]]$`_index`
#> [1] "shakespeare"
#> 
#> [[2]]$`_type`
#> [1] "act"
#> 
#> [[2]]$`_id`
#> [1] "2633"
#> 
#> [[2]]$`_version`
#> [1] 1
#> 
#> [[2]]$`_score`
#> NULL
#> 
#> [[2]]$`_source`
#> [[2]]$`_source`$line_id
#> [1] 2634
#> 
#> [[2]]$`_source`$play_name
#> [1] "Henry IV"
#> 
#> [[2]]$`_source`$speech_number
#> [1] 9
#> 
#> [[2]]$`_source`$line_number
#> [1] ""
#> 
#> [[2]]$`_source`$speaker
#> [1] "ARCHBISHOP OF YORK"
#> 
#> [[2]]$`_source`$text_entry
#> [1] "ACT V"
#> 
#> 
#> [[2]]$sort
#> [[2]]$sort[[1]]
#> [1] "act"
```

### Paging


```r
Search(index="shakespeare", size=1, from=1, fields='text_entry')$hits
#> $total
#> [1] 5000
#> 
#> $max_score
#> [1] 1
#> 
#> $hits
#> $hits[[1]]
#> $hits[[1]]$`_index`
#> [1] "shakespeare"
#> 
#> $hits[[1]]$`_type`
#> [1] "line"
#> 
#> $hits[[1]]$`_id`
#> [1] "9"
#> 
#> $hits[[1]]$`_version`
#> [1] 1
#> 
#> $hits[[1]]$`_score`
#> [1] 1
#> 
#> $hits[[1]]$fields
#> $hits[[1]]$fields$text_entry
#> $hits[[1]]$fields$text_entry[[1]]
#> [1] "Nor more shall trenching war channel her fields,"
```

### Queries

Using the `q` parameter you can pass in a query, which gets passed in the URI of the query. This type of query is less powerful than the below query passed in the body of the request, using the `body` parameter.


```r
Search(index="shakespeare", type="act", q="speaker:KING HENRY IV")$hits$total
#> [1] 9
```

### Query DSL searches - queries sent in the body of the request

Pass in as an R list


```r
aggs <- list(aggs = list(stats = list(terms = list(field = "text_entry"))))
Search(index="shakespeare", body=aggs)$hits$hits[[1]]
#> $`_index`
#> [1] "shakespeare"
#> 
#> $`_type`
#> [1] "line"
#> 
#> $`_id`
#> [1] "4"
#> 
#> $`_version`
#> [1] 1
#> 
#> $`_score`
#> [1] 1
#> 
#> $`_source`
#> $`_source`$line_id
#> [1] 5
#> 
#> $`_source`$play_name
#> [1] "Henry IV"
#> 
#> $`_source`$speech_number
#> [1] 1
#> 
#> $`_source`$line_number
#> [1] "1.1.2"
#> 
#> $`_source`$speaker
#> [1] "KING HENRY IV"
#> 
#> $`_source`$text_entry
#> [1] "Find we a time for frighted peace to pant,"
```

Or pass in as json query with newlines, easy to read


```r
aggs <- '{
    "aggs": {
        "stats" : {
            "terms" : {
                "field" : "text_entry"
            }
        }
    }
}'
Search(index="shakespeare", body=aggs)$hits$hits[[1]]
#> $`_index`
#> [1] "shakespeare"
#> 
#> $`_type`
#> [1] "line"
#> 
#> $`_id`
#> [1] "4"
#> 
#> $`_version`
#> [1] 1
#> 
#> $`_score`
#> [1] 1
#> 
#> $`_source`
#> $`_source`$line_id
#> [1] 5
#> 
#> $`_source`$play_name
#> [1] "Henry IV"
#> 
#> $`_source`$speech_number
#> [1] 1
#> 
#> $`_source`$line_number
#> [1] "1.1.2"
#> 
#> $`_source`$speaker
#> [1] "KING HENRY IV"
#> 
#> $`_source`$text_entry
#> [1] "Find we a time for frighted peace to pant,"
```

Or pass in collapsed json string


```r
aggs <- '{"aggs":{"stats":{"terms":{"field":"text_entry"}}}}'
Search(index="shakespeare", body=aggs)$hits$hits[[1]]
#> $`_index`
#> [1] "shakespeare"
#> 
#> $`_type`
#> [1] "line"
#> 
#> $`_id`
#> [1] "4"
#> 
#> $`_version`
#> [1] 1
#> 
#> $`_score`
#> [1] 1
#> 
#> $`_source`
#> $`_source`$line_id
#> [1] 5
#> 
#> $`_source`$play_name
#> [1] "Henry IV"
#> 
#> $`_source`$speech_number
#> [1] 1
#> 
#> $`_source`$line_number
#> [1] "1.1.2"
#> 
#> $`_source`$speaker
#> [1] "KING HENRY IV"
#> 
#> $`_source`$text_entry
#> [1] "Find we a time for frighted peace to pant,"
```

### Fuzzy query

Fuzzy query on numerics


```r
fuzzy <- list(query = list(fuzzy = list(speech_number = 7)))
Search(index="shakespeare", body=fuzzy)$hits$total
#> [1] 523
```


```r
fuzzy <- list(query = list(fuzzy = list(speech_number = list(value = 7, fuzziness = 4))))
Search(index="shakespeare", body=fuzzy)$hits$total
#> [1] 1499
```

### Range query

With numeric


```r
body <- list(query=list(range=list(decimalLongitude=list(gte=1, lte=3))))
Search('gbif', body=body)$hits$total
#> [1] 24
```


```r
body <- list(query=list(range=list(decimalLongitude=list(gte=2.9, lte=10))))
Search('gbif', body=body)$hits$total
#> [1] 166
```

With dates


```r
body <- list(query=list(range=list(eventDate=list(gte="2012-01-01", lte="now"))))
Search('gbif', body=body)$hits$total
#> [1] 899
```


```r
body <- list(query=list(range=list(eventDate=list(gte="2014-01-01", lte="now"))))
Search('gbif', body=body)$hits$total
#> [1] 685
```

### Highlighting


```r
body <- '{
 "query": {
   "query_string": {
     "query" : "cell"
   }
 },
 "highlight": {
   "fields": {
     "title": {"number_of_fragments": 2}
   }
 }
}'
out <- Search('plos', 'article', body=body)
out$hits$total
#> [1] 57
```


```r
sapply(out$hits$hits, function(x) x$highlight$title[[1]])[8:10]
#> [1] "c-FLIP Protects Eosinophils from TNF-α-Mediated <em>Cell</em> Death In Vivo"                          
#> [2] "DUSP1 Is a Novel Target for Enhancing Pancreatic Cancer <em>Cell</em> Sensitivity to Gemcitabine"     
#> [3] "Carbon Ion Radiation Inhibits Glioma and Endothelial <em>Cell</em> Migration Induced by Secreted VEGF"
```

### Scrolling search - instead of paging


```r
Search('shakespeare', q="a*")$hits$total
#> [1] 2747
res <- Search(index = 'shakespeare', q="a*", scroll="1m")
res <- Search(index = 'shakespeare', q="a*", scroll="1m", search_type = "scan")
length(scroll(scroll_id = res$`_scroll_id`)$hits$hits)
#> [1] 50
```


```r
res <- Search(index = 'shakespeare', q="a*", scroll="5m", search_type = "scan")
out <- list()
hits <- 1
while(hits != 0){
  res <- scroll(scroll_id = res$`_scroll_id`)
  hits <- length(res$hits$hits)
  if(hits > 0)
    out <- c(out, res$hits$hits)
}
length(out)
#> [1] 2747
```

Woohoo! Collected all 2747 documents in very little time.

## The cat API

List cat methods


```r
cat_()
#> =^.^=
#> /_cat/allocation
#> /_cat/shards
#> /_cat/shards/{index}
#> /_cat/master
#> /_cat/nodes
#> /_cat/indices
#> /_cat/indices/{index}
#> /_cat/segments
#> /_cat/segments/{index}
#> /_cat/count
#> /_cat/count/{index}
#> /_cat/recovery
#> /_cat/recovery/{index}
#> /_cat/health
#> /_cat/pending_tasks
#> /_cat/aliases
#> /_cat/aliases/{alias}
#> /_cat/thread_pool
#> /_cat/plugins
#> /_cat/fielddata
#> /_cat/fielddata/{fields}
```

Get aliases


```r
cat_aliases()
#> things plos - - - 
#> stuff  plos - - -
```

Get indices


```r
cat_indices()
#> yellow open plosmore     5 1  1000  0   3.5mb   3.5mb 
#> yellow open leotheadfadf 5 1     0  0    575b    575b 
#> red    open alsothat     3 2                          
#> yellow open gbif         5 1   899  0     1mb     1mb 
#> yellow open gbifgeopoint 5 1     0  0    575b    575b 
#> yellow open gbifnewgeo   5 1     2  0   5.8kb   5.8kb 
#> yellow open plos         5 1  1202 39  14.2mb  14.2mb 
#> yellow open leothedog    5 1     0  0    575b    575b 
#> yellow open shakespeare  5 1  5000  0     1mb     1mb 
#> yellow open gbifgeo      5 1   600  0 861.9kb 861.9kb 
#> yellow open plosbigdata  5 1 20000  0  53.6mb  53.6mb 
#> yellow open mapuris      5 1    31  0  34.4kb  34.4kb 
#> yellow open leothelion   5 1     0  0    575b    575b
```

Get nodes


```r
cat_nodes()
#> Scotts-MacBook-Pro.local 192.168.1.104 6 79 3.44 d * Hellfire
```

## Work with indices


```r
out <- index_get(index='shakespeare')
names(out$shakespeare$mappings)
#> [1] "line"  "scene" "act"
```

Check for index existence


```r
index_exists(index='shakespeare')
#> [1] TRUE
```

Delete an index


```r
index_delete(index='plos')
#> $acknowledged
#> [1] TRUE
```

Create an index


```r
index_create(index='twitter')
#> $acknowledged
#> [1] TRUE
```

## Work with documents

Get a document


```r
docs_get(index='shakespeare', type='line', id=10)
#> $`_index`
#> [1] "shakespeare"
#> 
#> $`_type`
#> [1] "line"
#> 
#> $`_id`
#> [1] "10"
#> 
#> $`_version`
#> [1] 1
#> 
#> $found
#> [1] TRUE
#> 
#> $`_source`
#> $`_source`$line_id
#> [1] 11
#> 
#> $`_source`$play_name
#> [1] "Henry IV"
#> 
#> $`_source`$speech_number
#> [1] 1
#> 
#> $`_source`$line_number
#> [1] "1.1.8"
#> 
#> $`_source`$speaker
#> [1] "KING HENRY IV"
#> 
#> $`_source`$text_entry
#> [1] "Nor bruise her flowerets with the armed hoofs"
```

Get certain fields


```r
docs_get(index='shakespeare', type='line', id=10, fields=c('play_name','speaker'))
#> $`_index`
#> [1] "shakespeare"
#> 
#> $`_type`
#> [1] "line"
#> 
#> $`_id`
#> [1] "10"
#> 
#> $`_version`
#> [1] 1
#> 
#> $found
#> [1] TRUE
#> 
#> $fields
#> $fields$play_name
#> $fields$play_name[[1]]
#> [1] "Henry IV"
#> 
#> 
#> $fields$speaker
#> $fields$speaker[[1]]
#> [1] "KING HENRY IV"
```

Test for existence of the document


```r
docs_get(index='plos', type='article', id=1, exists=TRUE)
#> [1] FALSE
```


```r
docs_get(index='plos', type='article', id=123456, exists=TRUE)
#> [1] FALSE
```

## Thats it

Let us know if you have any feedback!
