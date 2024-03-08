--- 
name: global-names-resolver
layout: post
title: Hitting the Global Names Resolver API
date: 2012-07-20
author: Scott Chamberlain
sourceslug: _drafts/2012-07-20-global-names-resolver.Rmd
tags: 
- API
- ropensci
- taxonomic
- resolve
- taxize
- ropensci
- taxize
---

## Example of using the Global Names Resolver API to check species names


There are a number of options for resolution of taxonomic names. The [Taxonomic Name Resolution Service (TNRS)](http://tnrs.iplantcollaborative.org/) comes to mind. There is a new service for taxonomic name resoultion called the [Global Names Resolver](http://resolver.globalnames.org/). They describe the service thusly "_Resolve lists of scientific names against known sources. This service parses incoming names, executes exact or fuzzy matching as required, and displays a confidence score for each match along with its identifier._". 


## Load required packages

### Just uncomment the code to use.


```r
# If you don't have them already
# install.packages(c('RJSONIO','plyr','devtools')) require(devtools)
# install_github('taxize_','ropensci')
library(RJSONIO)
library(plyr)
library(taxize)
```


## Get the data sources available

### Get just id's and names of sources in a data.frame

```r
tail(gnr_datasources(todf = T))
```



```r
##     id                                title
## 82 164                            BioLib.cz
## 83 165 Tropicos - Missouri Botanical Garden
## 84 166                                nlbif
## 85 167                                 IPNI
## 86 168              Index to Organism Names
## 87 169                        uBio NameBank
```


*********

### Give me the id for EOL (Encyclopedia of Life)

```r
out <- gnr_datasources(todf = T)
out[out$title == "EOL", "id"]
```



```r
## [1] 12
```


*********

### Fuzzy search for sources with the word "zoo"

```r
out <- gnr_datasources(todf = T)
outdf <- out[agrep("zoo", out$title, ignore.case = T), ]
outdf[1:2, ]
```



```r
##     id             title
## 20 100 Mushroom Observer
## 25 105           ZooKeys
```


## Resolve some names

### Search for _Helianthus annuus_ and _Homo sapiens_, return a data.frame

```r
gnr(names = c("Helianthus annuus", "Homo sapiens"), returndf = TRUE)[1:2, ]
```



```r
##   data_source_id    submitted_name       name_string score    title
## 1              4 Helianthus annuus Helianthus annuus 0.988     NCBI
## 3             10 Helianthus annuus Helianthus annuus 0.988 Freebase
```


*********

### Search for the same species, with only using data source 12 (i.e., EOL)

```r
gnr(names = c("Helianthus annuus", "Homo sapiens"), data_source_ids = "12", 
    returndf = TRUE)
```



```r
##   data_source_id    submitted_name       name_string score title
## 1             12 Helianthus annuus Helianthus annuus 0.988   EOL
## 2             12      Homo sapiens      Homo sapiens 0.988   EOL
```



### That's it. Have fun! And put bugs/comments/etc. [here](https://github.com/ropensci/taxize_/issues).


Written in [Markdown](http://daringfireball.net/projects/markdown/), with help from [knitr](http://yihui.name/knitr/), and nice knitr highlighting/etc. in in [RStudio](http://rstudio.org/).


### I prepared the markdown for this post by:

```r
KnitPost <- function(input, base.url = "/") {
    require(knitr)
    opts_knit$set(base.url = base.url)
    fig.path <- paste0("img/", sub(".Rmd$", "", basename(input)), "/")
    opts_chunk$set(fig.path = fig.path)
    opts_chunk$set(fig.cap = "center")
    render_jekyll()
    knit(input, envir = parent.frame())
}
setwd("/path/to/_posts")
KnitPost("/path/to/postfile.Rmd")
```

from [jfisher](http://jfisher-usgs.github.com/r/2012/07/03/knitr-jekyll/).
