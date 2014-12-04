---
name: rplos-pubs-country
layout: post
title: Publications by author country
date: 2014-12-03
author: Scott Chamberlain
tags:
- R
- API
- publications
---



I just missed another chat on the rOpenSci website:

> I want to know the number of publications by people from a certain country, but I dont know how to achieve this...

Fun! Let's do that. It's a bit complicated because there is no field like geography of the authors. But there are affiliation fields, from which we can collect data we need.

## Installation

You'll need the GitHub version for the coutry names data, or just use the CRAN version, and get country names elsewhere. 


```r
install.packages("devtools")
devtools::install_github("rplos")
```


```r
library("rplos")
```

## Get the data


```r
articles <- searchplos(q='*:*', limit = 5,
    fl=c("id","author_affiliate"), 
    fq=list('article_type:"Research Article"', "doc_type:full"))
```

## Search for country names in affilitation field


```r
(countries <- lapply(articles$data$author_affiliate, function(x){
  out <- sapply(isocodes$name, function(z) grepl(z, x))
  isocodes$name[out]
}))
#> [[1]]
#> [1] "Netherlands"
#> 
#> [[2]]
#> [1] "China"
#> 
#> [[3]]
#> [1] "Canada"
#> 
#> [[4]]
#> [1] "China"
#> 
#> [[5]]
#> [1] "Germany"
```

You can combine this data with the previously collected data:


```r
# Helper function
splitem <- function(x){
  if(length(x) == 0) { NA } else {
    if(length(x) > 1) paste0(x, collapse = ", ") else x
  }
}

articles$data$countries <- sapply(countries, splitem)
head(articles$data)
#>                             id
#> 1 10.1371/journal.pone.0004237
#> 2 10.1371/journal.pone.0006239
#> 3 10.1371/journal.pone.0034856
#> 4 10.1371/journal.pone.0021965
#> 5 10.1371/journal.pone.0008295
#>                                                                                                                                                                                                                                                                                                                                                                                   author_affiliate
#> 1 Division of General Internal Medicine, Department of Medicine, Radboud University Nijmegen Medical Center, Nijmegen, The Netherlands; Nijmegen Institute of Infection, Inflammation and Immunity (N4i), Nijmegen, The Netherlands; Department of Pharmacology and Toxicology, Nijmegen Center for Molecular Life Sciences, Radboud University Nijmegen Medical Center, Nijmegen, The Netherlands
#> 2                                                                                                                                                                                                                       State Key Laboratory of Cognitive Neuroscience and Learning, Beijing Normal University, Beijing, China; Graduate University of Chinese Academy of Sciences, Beijing, China
#> 3                                                                                                                                                                  Rotman Research Institute of Baycrest, Toronto, Ontario, Canada; Department of Psychology, University of Toronto, Toronto, Ontario, Canada; Dalla Lana School of Public Health, University of Toronto, Toronto, Ontario, Canada
#> 4                                                                                                                             Hefei National Laboratory for Physical Sciences at Microscale, School of Life Sciences, University of Science and Technology of China, Hefei, Anhui, People's Republic of China; School of Life Sciences, Anhui University, Hefei, Anhui, People's Republic of China
#> 5                                                                                                                                                                                                                                                                                                                   Institute of Biochemistry, Charité-Universitätsmedizin Berlin, Berlin, Germany
#>     countries
#> 1 Netherlands
#> 2       China
#> 3      Canada
#> 4       China
#> 5     Germany
```

## Bigger data set

Okay, cool, lets do it on a bigger data set, and this time, we'll get another variable `counter_total_all`, which is the combination of page views/pdf downloads for each article. This will allow us to ask _Is number of countries included in the authors related to page views?_. I have no idea if this question makes sense, but nonetheless, it is a question :)


```r
articles <- searchplos(q='*:*', limit = 1000,
    fl=c("id","counter_total_all","author_affiliate"), 
    fq=list('article_type:"Research Article"', "doc_type:full"))
```

Get countries


```r
countries <- lapply(articles$data$author_affiliate, function(x){
  out <- sapply(isocodes$name, function(z) grepl(z, x))
  isocodes$name[out]
})
df <- articles$data
df$countries <- sapply(countries, splitem)
```

Let's remove those rows with 0 countries, since the authors must be from somewhere, so the country name matching must have errored. 


```r
df$n_countries <- sapply(countries, length)
df <- df[ df$n_countries > 0, ]
```

Plot data


```r
library("ggplot2")
ggplot(df, aes(n_countries, as.numeric(counter_total_all))) +
  geom_point() +
  labs(y="total page views") + 
  theme_grey(base_size = 16)
```

![](/public/img/2014-12-03-rplos-pubs-country/unnamed-chunk-10-1.png) 

Conclusion: meh, maybe, maybe not

## Into rplos

We'll probably add a function like this into `rplos`, as a convenient way to handle this use case.
