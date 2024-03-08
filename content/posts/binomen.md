---
name: binomen
layout: post
title: binomen - taxonomic classes and parsing
date: 2015-01-19
author: Scott Chamberlain
sourceslug: _drafts/2015-01-19-binomen.Rmd
tags:
- R
- taxonomy
---



I maintain, along with other [awesome people](https://github.com/ropensci/taxize/graphs/contributors), the [taxize](https://github.com/ropensci/taxize) R package - a taxonomic toolbelt for R, for interacting with taxonomic data sources on the web. 

Taxonomy data is not standardized, but there are a lot of common elements, and there is a finite list of taxonomic ranks, and finite number of major taxonomic data sets. Thus, I've been interested in attempting to define a pseudo standard for expressing taxonomic data in R. The conversation [started a while back](https://github.com/ropensci/taxize/issues/261) in a GitHub issue, and hasn't moved very far. 

I decided to start playing with this more, which is easier to do in a separate pacakge. Thus: `binomen`. It's an attempt to define a set of taxonomic classes/objects in R, along with a suite of functions to help construct and parse these objects.

Would love any/all feedback. 

Here's some examples:

## Install

Install `binomen` 


```r
install.packages("devtools")
devtools::install_github("ropensci/binomen")
```


```r
library("binomen")
```

## Make a taxon

Make a taxon object


```r
(obj <- make_taxon(genus="Poa", epithet="annua", authority="L.",
                   family='Poaceae', clazz='Poales', 
                   kingdom='Plantae', variety='annua'))
#> <taxon>
#>   binomial: Poa annua
#>   classification: 
#>     kingdom: Plantae
#>     clazz: Poales
#>     family: Poaceae
#>     genus: Poa
#>     species: Poa annua
#>     variety: annua
```

Index to various parts of the object

The binomial


```r
obj$binomial
#> <binomial>
#>   genus: Poa
#>   epithet: annua
#>   canonical: Poa annua
#>   species: Poa annua L.
#>   authority: L.
```

The authority


```r
obj$binomial$authority
#> [1] "L."
```

The classification


```r
obj$classification
#> <classification>
#>     kingdom: Plantae
#>     clazz: Poales
#>     family: Poaceae
#>     genus: Poa
#>     species: Poa annua
#>     variety: annua
```

The family


```r
obj$classification$family
#> <taxonref>
#>   rank: family
#>   name: Poaceae
#>   id: none
#>   uri: none
```

## Subset taxon objects

Get a single rank


```r
obj %>% select(family)
#> <taxonref>
#>   rank: family
#>   name: Poaceae
#>   id: none
#>   uri: none
```

Get a range of ranks


```r
obj %>% range(kingdom, family)
#> $kingdom
#> <taxonref>
#>   rank: kingdom
#>   name: Plantae
#>   id: none
#>   uri: none
#> 
#> $clazz
#> <taxonref>
#>   rank: clazz
#>   name: Poales
#>   id: none
#>   uri: none
#> 
#> $family
#> <taxonref>
#>   rank: family
#>   name: Poaceae
#>   id: none
#>   uri: none
```

Extract classification as a `data.frame`


```r
gethier(obj)
#>      rank      name
#> 1 kingdom   Plantae
#> 2   clazz    Poales
#> 3  family   Poaceae
#> 4   genus       Poa
#> 5 species Poa annua
#> 6 variety     annua
```

## Taxonomic data.frame's

Make one


```r
df <- data.frame(
  order=c('Asterales','Asterales','Fagales','Poales','Poales','Poales'),
  family=c('Asteraceae','Asteraceae','Fagaceae','Poaceae','Poaceae','Poaceae'),
  genus=c('Helianthus','Helianthus','Quercus','Poa','Festuca','Holodiscus'),
  stringsAsFactors = FALSE)
(df2 <- taxon_df(df))
#>       order     family      genus
#> 1 Asterales Asteraceae Helianthus
#> 2 Asterales Asteraceae Helianthus
#> 3   Fagales   Fagaceae    Quercus
#> 4    Poales    Poaceae        Poa
#> 5    Poales    Poaceae    Festuca
#> 6    Poales    Poaceae Holodiscus
```

Parse - get rank order matching _Fagales_


```r
df2 %>% select(order, Fagales)
#>     order   family   genus
#> 3 Fagales Fagaceae Quercus
```

get rank family matching _Asteraceae_


```r
df2 %>% select(family, Asteraceae)
#>       order     family      genus
#> 1 Asterales Asteraceae Helianthus
#> 2 Asterales Asteraceae Helianthus
```

get rank genus matching _Poa_


```r
df2 %>% select(genus, Poa)
#>    order  family genus
#> 4 Poales Poaceae   Poa
```
