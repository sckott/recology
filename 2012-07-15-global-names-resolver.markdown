--- 
name: global-names-resolver
layout: post
title: Hitting the Global Names Resolver API
date: 2012-07-15
tags: API ropensci taxonomic resolve taxize
---

## Example of using the Global Names Resolver API to check species names
 
There are a number of options for resolution of taxonomic names. The [Taxonomic Name Resolution Service (TNRS)](http://tnrs.iplantcollaborative.org/) comes to mind. There is a new service for taxonomic name resoultion called the [Global Names Resolver](http://resolver.globalnames.org/). They describe the service thusly "_Resolve lists of scientific names against known sources. This service parses incoming names, executes exact or fuzzy matching as required, and displays a confidence score for each match along with its identifier._". 

## Load required packages
Just uncomment the code.



```r
# If you don't have them already# install.packages(c('RJSONIO','plyr','devtools')) require(devtools)# install_github('taxize_','ropensci')
```






```r
# If you don't have them already
# install.packages(c('RJSONIO','plyr','devtools')) require(devtools)
# install_github('taxize_','ropensci')
library(RJSONIO)
library(plyr)
library(taxize)
```




## Get the data sources available


```r
# Get just id's and names of sources in a data.frame
tail(gnr_datasources(todf = T))
```

```
##     id                                title
## 82 164                            BioLib.cz
## 83 165 Tropicos - Missouri Botanical Garden
## 84 166                                nlbif
## 85 167                                 IPNI
## 86 168              Index to Organism Names
## 87 169                        uBio NameBank
```

```r

# give me the id for EOL (Encyclopedia of Life)
out <- gnr_datasources(todf = T)
out[out$title == "EOL", "id"]
```

```
## [1] 12
```

```r

# Fuzzy search for sources with the word 'zoo'
out <- gnr_datasources(todf = T)
outdf <- out[agrep("zoo", out$title, ignore.case = T), ]
outdf[1:2, ]
```

```
##     id             title
## 20 100 Mushroom Observer
## 25 105           ZooKeys
```




## Resolve some names


```r
# Search for Helianthus annuus and Homo sapiens, return a data.frame
gnr(names = c("Helianthus annuus", "Homo sapiens"), returndf = TRUE)[1:2, 
    ]
```

```
##   data_source_id    submitted_name       name_string score    title
## 1              4 Helianthus annuus Helianthus annuus 0.988     NCBI
## 3             10 Helianthus annuus Helianthus annuus 0.988 Freebase
```

```r

# Search for the same species, with only using data source 12 (i.e., EOL)
gnr(names = c("Helianthus annuus", "Homo sapiens"), data_source_ids = "12", 
    returndf = TRUE)
```

```
##   data_source_id    submitted_name       name_string score title
## 1             12 Helianthus annuus Helianthus annuus 0.988   EOL
## 2             12      Homo sapiens      Homo sapiens 0.988   EOL
```




### That's it. Have fun! And put bugs/comments/etc. [here](https://github.com/ropensci/taxize_/issues).

### Written in [Markdown](http://daringfireball.net/projects/markdown/), with help of [knitr](http://yihui.name/knitr/) in [RStudio](http://rstudio.org/).