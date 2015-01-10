---
name: taxize-workflows
layout: post
title: taxize workflows
date: 2014-12-02
author: Scott Chamberlain
sourceslug: _drafts/2014-12-02-taxize-workflows.Rmd
tags:
- R
- API
- taxize
- taxonomy
---



A missed chat on the rOpenSci website the other day asked:

> Hi there, i am trying to use the taxize package and have a .csv file of species names to run through taxize updating them. What would be the code i would need to run to achieve this?

One way to answer this is to talk about the basic approach to importing data, doing stuff to the data, then recombining data. There are many ways to do this, but I'll go over a few of them.

## Install taxize


```r
install.packages("taxize")
install.packages("downloader")
```


```r
library("taxize")
```

## Import data

We'll use Winston Chang's new `downloader` package to avoid problems with `https`, and get a dataset from our ropensci datasets repo [https://github.com/ropensci/datasets](https://github.com/ropensci/datasets)


```r
downloader::download("https://raw.githubusercontent.com/ropensci/datasets/master/planttraits/morphological.csv", "morphological.csv")
dat <- read.csv("morphological.csv", stringsAsFactors = FALSE)
head(dat)
#>                  species log_SLA leaf_water_content log_wood_density
#> 1         Abies concolor    3.46               0.51            -0.52
#> 2          Abies grandis    3.58               0.49            -0.51
#> 3        Abies magnifica    3.87               0.62            -0.53
#> 4      Acacia farnesiana      NA                 NA               NA
#> 5           Acer glabrum    5.07               0.69            -0.54
#> 6 Adenostoma fasciculata    3.56               0.46            -0.31
#>   log_ht log_N
#> 1   7.72  0.02
#> 2   7.51 -0.31
#> 3   7.58 -0.14
#> 4   5.70    NA
#> 5   3.25  1.02
#> 6   5.33  0.29
```

After importing data, there are a variety of approaches you could take:

1. Vector: Take species names as vector from your `data.frame`, cleaning them, then re-attching to the `data.frame` later, or
2. In-Place: Use for loops or `lapply` family functions to iterate over each name while simultaneously re-inserting into the `data.frame`

## 1. Vector

Make a vector of names


```r
splist <- dat$species
```

Then proceed to do name cleaning, e.g, we can use the `tnrs` function to see if any names are potentially not spelled correctly. 


```r
tnrs_out <- tnrs(splist, source = "iPlant_TNRS")
head(tnrs_out)
#>              submittedname             acceptedname    sourceid score
#> 1     Ceanothus prostratus     Ceanothus prostratus iPlant_TNRS     1
#> 2          Abies magnifica          Abies magnifica iPlant_TNRS     1
#> 3 Arctostaphylos canescens Arctostaphylos canescens iPlant_TNRS     1
#> 4         Berberis nervosa         Berberis nervosa iPlant_TNRS     1
#> 5        Arbutus menziesii        Arbutus menziesii iPlant_TNRS     1
#> 6     Calocedrus decurrens     Calocedrus decurrens iPlant_TNRS     1
#>                matchedname      authority
#> 1     Ceanothus prostratus         Benth.
#> 2          Abies magnifica  A. Murray bis
#> 3 Arctostaphylos canescens         Eastw.
#> 4         Berberis nervosa          Pursh
#> 5        Arbutus menziesii          Pursh
#> 6     Calocedrus decurrens (Torr.) Florin
#>                                     uri
#> 1 http://www.tropicos.org/Name/27500276
#> 2 http://www.tropicos.org/Name/24900142
#> 3 http://www.tropicos.org/Name/12302547
#> 4  http://www.tropicos.org/Name/3500175
#> 5 http://www.tropicos.org/Name/12302436
#> 6  http://www.tropicos.org/Name/9400069
```

Those with score of less than 1 may have misspellings


```r
tnrs_out[ tnrs_out$score < 1, ]
#>                 submittedname              acceptedname    sourceid score
#> 23     Adenostoma fasciculata   Adenostoma fasciculatum iPlant_TNRS  0.97
#> 24 Arctostaphylos glandulosus Arctostaphylos glandulosa iPlant_TNRS  0.97
#> 36        Chamaebatia foliosa     Chamaebatia foliolosa iPlant_TNRS  0.95
#> 38     Juniperus californicus     Juniperus californica iPlant_TNRS  0.97
#> 77         Prunus illicifolia         Prunus ilicifolia iPlant_TNRS  0.99
#> 78         Prunus subcordatus         Prunus subcordata iPlant_TNRS  0.97
#>                  matchedname                         authority
#> 23   Adenostoma fasciculatum                      Hook. & Arn.
#> 24 Arctostaphylos glandulosa                            Eastw.
#> 36     Chamaebatia foliolosa                            Benth.
#> 38     Juniperus californica                          Carrière
#> 77         Prunus ilicifolia (Nutt. ex Hook. & Arn.) D. Dietr.
#> 78         Prunus subcordata                            Benth.
#>                                      uri
#> 23 http://www.tropicos.org/Name/27801458
#> 24 http://www.tropicos.org/Name/12300542
#> 36 http://www.tropicos.org/Name/27801486
#> 38  http://www.tropicos.org/Name/9400374
#> 77 http://www.tropicos.org/Name/27801102
#> 78 http://www.tropicos.org/Name/27801124
```

So let's take the `acceptedname` column as a the new names and assign to a new vector


```r
cleaned_names <- tnrs_out$acceptedname
```

Then join names back, replacing them, or adding as a new column

Replace


```r
dat$species <- cleaned_names
head(dat)
#>                    species log_SLA leaf_water_content log_wood_density
#> 1     Ceanothus prostratus    3.46               0.51            -0.52
#> 2          Abies magnifica    3.58               0.49            -0.51
#> 3 Arctostaphylos canescens    3.87               0.62            -0.53
#> 4         Berberis nervosa      NA                 NA               NA
#> 5        Arbutus menziesii    5.07               0.69            -0.54
#> 6     Calocedrus decurrens    3.56               0.46            -0.31
#>   log_ht log_N
#> 1   7.72  0.02
#> 2   7.51 -0.31
#> 3   7.58 -0.14
#> 4   5.70    NA
#> 5   3.25  1.02
#> 6   5.33  0.29
```

New column


```r
dat$species_cleaned <- cleaned_names
head(dat)
#>                    species log_SLA leaf_water_content log_wood_density
#> 1     Ceanothus prostratus    3.46               0.51            -0.52
#> 2          Abies magnifica    3.58               0.49            -0.51
#> 3 Arctostaphylos canescens    3.87               0.62            -0.53
#> 4         Berberis nervosa      NA                 NA               NA
#> 5        Arbutus menziesii    5.07               0.69            -0.54
#> 6     Calocedrus decurrens    3.56               0.46            -0.31
#>   log_ht log_N          species_cleaned
#> 1   7.72  0.02     Ceanothus prostratus
#> 2   7.51 -0.31          Abies magnifica
#> 3   7.58 -0.14 Arctostaphylos canescens
#> 4   5.70    NA         Berberis nervosa
#> 5   3.25  1.02        Arbutus menziesii
#> 6   5.33  0.29     Calocedrus decurrens
```

## 2. In-place

You can use functions from the `dplyr` package to `split-apply-combine`, where `split` is split apart your vector for each taxon, `apply` to apply a function or functions to do name cleaning, then `combine` to put them back together. 

Here, we'll attach taxonomic ids from the Catalogue of Life to each species (each row) (with just a subset of the data to save time):


```r
library("dplyr")
tbl_df(dat)[1:5,] %>%
  rowwise() %>%
  mutate(colid = get_colid(species)) %>%
  select(species, colid)
#> Source: local data frame [5 x 2]
#> Groups: <by row>
#> 
#>                    species    colid
#> 1     Ceanothus prostratus 19544732
#> 2          Abies magnifica 18158318
#> 3 Arctostaphylos canescens 19358934
#> 4         Berberis nervosa 19374077
#> 5        Arbutus menziesii 19358819
```

Let's do something a bit more complicated. Get common names for each taxon in a new column, if more than 1, concatenate into a single character string for easy inclusion in a `data.frame`


```r
sci2comm_concat <- function(x){
  temp <- sci2comm(x, db = "eol")
  if(length(temp) == 0) NA else paste0(temp[[1]], collapse = ", ")
}

dat_new <- tbl_df(dat)[1:5,] %>%
  rowwise() %>%
  mutate(comm = sci2comm_concat(species))
```

To see the new column, do 


```r
dat_new %>% select(comm)
#> Source: local data frame [5 x 1]
#> Groups: <by row>
#> 
#>                                                                          comm
#> 1                      Mahala-mat Ceanothus, prostrate ceanothus, squawcarpet
#> 2 Prächtige Tanne, Goldtanne (Gold-Tanne), Kalifornische Rot-Tanne, Pracht-Ta
#> 3                          hoary manzanita, hoary manzanita, Sonoma manzanita
#> 4 Longleaf Oregon-grape, Cascade barberry, Dull Oregon grape, Oregon grape-ho
#> 5                   pacific madrone, Madrona, madrone, Kalifornianmansikkapuu
```
