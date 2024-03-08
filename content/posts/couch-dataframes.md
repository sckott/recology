---
name: couch-dataframes
layout: post
title: PUT dataframes on your couch
date: 2015-03-12
author: Scott Chamberlain
sourceslug: _drafts/2015-03-12-couch-dataframes.Rmd
tags:
- R
- couchdb
- sofa
---



It would be nice to easily push each row or column of a data.frame into CouchDB instead of having to prepare them yourself into JSON, then push in to couch. I recently added ability to push data.frame's into couch using the normal `PUT /{db}` method, and added support for the couch bulk API.

## Install


```r
install.packages("devtools")
devtools::install_github("sckott/sofa")
```


```r
library("sofa")
```

## PUT /db

You can write directly from a data.frame, either by rows or columns. First, rows:


```
#> $ok
#> [1] TRUE
```

Create a database


```r
db_create(dbname="mtcarsdb")
#> $ok
#> [1] TRUE
```


```r
out <- doc_create(mtcars, dbname="mtcarsdb", how="rows")
out[1:2]
#> $`Mazda RX4`
#> $`Mazda RX4`$ok
#> [1] TRUE
#> 
#> $`Mazda RX4`$id
#> [1] "0063109bfb1c15765854cbc9525c3a7a"
#> 
#> $`Mazda RX4`$rev
#> [1] "1-3946941c894a874697554e3e6d9bc176"
#> 
#> 
#> $`Mazda RX4 Wag`
#> $`Mazda RX4 Wag`$ok
#> [1] TRUE
#> 
#> $`Mazda RX4 Wag`$id
#> [1] "0063109bfb1c15765854cbc9525c461d"
#> 
#> $`Mazda RX4 Wag`$rev
#> [1] "1-273ff17a938cb956cba21051ab428b95"
```

Then by columns


```r
out <- doc_create(mtcars, dbname="mtcarsdb", how="columns")
out[1:2]
#> $mpg
#> $mpg$ok
#> [1] TRUE
#> 
#> $mpg$id
#> [1] "0063109bfb1c15765854cbc9525d4f1f"
#> 
#> $mpg$rev
#> [1] "1-4b83d0ef53a28849a872d47ad03fef9a"
#> 
#> 
#> $cyl
#> $cyl$ok
#> [1] TRUE
#> 
#> $cyl$id
#> [1] "0063109bfb1c15765854cbc9525d57d3"
#> 
#> $cyl$rev
#> [1] "1-c21bfa5425c67743f0826fd4b44b0dbf"
```

## Bulk API

The bulk API will/should be faster for larger data.frames


```
#> $ok
#> [1] TRUE
```

We'll use part of the diamonds dataset


```r
library("ggplot2")
dat <- diamonds[1:20000,]
```

Create a database


```r
db_create(dbname="bulktest")
#> $ok
#> [1] TRUE
```

Load by row (could instead do each column, see `how` parameter), printing the time it takes


```r
system.time(out <- bulk_create(dat, dbname="bulktest"))
#>    user  system elapsed 
#>  16.832   6.039  24.432
```

The returned data is the same as with `doc_create()`


```r
out[1:2]
#> [[1]]
#> [[1]]$ok
#> [1] TRUE
#> 
#> [[1]]$id
#> [1] "0063109bfb1c15765854cbc9525d8b8d"
#> 
#> [[1]]$rev
#> [1] "1-f407fe4935af7fd17c101f13d3c81679"
#> 
#> 
#> [[2]]
#> [[2]]$ok
#> [1] TRUE
#> 
#> [[2]]$id
#> [1] "0063109bfb1c15765854cbc9525d998b"
#> 
#> [[2]]$rev
#> [1] "1-cf8b9a9dcdc026052a663d6fef8a36fe"
```

So that's 20,000 rows in not that much time, not bad.

### not dataframes

You can also pass in lists or vectors of json as character strings, e.g., 

_lists_


```
#> $ok
#> [1] TRUE
```


```r
row.names(mtcars) <- NULL # get rid of row.names
lst <- parse_df(mtcars, tojson=FALSE)
db_create(dbname="bulkfromlist")
#> $ok
#> [1] TRUE
out <- bulk_create(lst, dbname="bulkfromlist")
out[1:2]
#> [[1]]
#> [[1]]$ok
#> [1] TRUE
#> 
#> [[1]]$id
#> [1] "ba70c46d73707662b1e204a90fcd9bb8"
#> 
#> [[1]]$rev
#> [1] "1-3946941c894a874697554e3e6d9bc176"
#> 
#> 
#> [[2]]
#> [[2]]$ok
#> [1] TRUE
#> 
#> [[2]]$id
#> [1] "ba70c46d73707662b1e204a90fcda9f6"
#> 
#> [[2]]$rev
#> [1] "1-273ff17a938cb956cba21051ab428b95"
```

_json_


```
#> $ok
#> [1] TRUE
```


```r
strs <- as.character(parse_df(mtcars, "columns"))
db_create(dbname="bulkfromchr")
#> $ok
#> [1] TRUE
out <- bulk_create(strs, dbname="bulkfromchr")
out[1:2]
#> [[1]]
#> [[1]]$ok
#> [1] TRUE
#> 
#> [[1]]$id
#> [1] "ba70c46d73707662b1e204a90fce8c20"
#> 
#> [[1]]$rev
#> [1] "1-4b83d0ef53a28849a872d47ad03fef9a"
#> 
#> 
#> [[2]]
#> [[2]]$ok
#> [1] TRUE
#> 
#> [[2]]$id
#> [1] "ba70c46d73707662b1e204a90fce9bc1"
#> 
#> [[2]]$rev
#> [1] "1-c21bfa5425c67743f0826fd4b44b0dbf"
```
