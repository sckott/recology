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
devtools::install_github("ropensci/rplos")
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
#> character(0)
#> 
#> [[2]]
#> [1] "Jersey"        "United States"
#> 
#> [[3]]
#> [1] "China"   "Germany"
#> 
#> [[4]]
#> character(0)
#> 
#> [[5]]
#> [1] "Argentina"      "United Kingdom"
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
#> 1 10.1371/journal.pone.0095870
#> 2 10.1371/journal.pone.0110535
#> 3 10.1371/journal.pone.0110991
#> 4 10.1371/journal.pone.0111234
#> 5 10.1371/journal.pone.0111388
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                author_affiliate
#> 1 Institute of Epidemiology and Preventive Medicine, College of Public Health, National Taiwan University, Taipei, Taiwan; Department of Clinical Laboratory Sciences and Medical Biotechnology, College of Medicine, National Taiwan University, Taipei, Taiwan; Department of Gastroenterology, Ren-Ai Branch, Taipei City Hospital, Taipei, Taiwan; Division of Gastroenterology, Department of Internal Medicine, National Taiwan University Hospital and National Taiwan University College of Medicine, Taipei, Taiwan; Liver Research Unit, Chang Gung Memorial Hospital, Chang Gung University College of Medicine, Taipei, Taiwan; Division of Gastroenterology, Department of Medicine, Taipei Veterans General Hospital, Taipei, Taiwan; Cheng Hsin General Hospital, Taipei, Taiwan
#> 2    Durham Nephrology Associates, Durham, North Carolina, United States of America; Scientific Activities Department, The National Kidney Foundation, Inc., New York, New York, United States of America; Covance Inc., Princeton, New Jersey, United States of America; Departments of Medicine and Population Health Sciences, University of Wisconsin School of Medicine and Public Health, Madison, Wisconsin, United States of America; Department of Family Medicine, University at Buffalo, Buffalo, New York, United States of America; Baylor Health Care System, Baylor Heart and Vascular Institute, Dallas, Texas, United States of America; Department of Medicine, Division of Nephrology, Icahn School of Medicine at Mount Sinai, New York, New York, United States of America
#> 3                                                                                                                                                                                                                                                                                                                                                                                                                                  State Key Laboratory of Electronic Thin Films and Integrated Devices, School of Microelectronics and Solid-State electronics, University of Electronic Science and Technology of China, Sichuan, China; Electrical and Computer Engineering, Kaiserslautern University of Technology, Kaiserslautern German Gottlieb-Daimler-Strabe, Kaiserslautern, Germany
#> 4                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         SB RAS Institute of Chemical Biology and Fundamental Medicine, Novosibirsk, Russia; Pacific Institute of Bioorganic Chemistry, Far East Division, Russian Academy of Sciences, Vladivostok, Russia; Novosibirsk State University, Novosibirsk, Russia
#> 5                                                                                                                                                                                                                                                                                                                                                                                   CONICET, Consejo Nacional de Investigaciones Científicas y Técnicas, Ciudad Autónoma de Buenos Aires, Buenos Aires, Argentina; INGEO, Instituto de Geología, Facultad de Ciencias Exactas, Físicas y Naturales, Universidad Nacional de San Juan, San Juan, San Juan, Argentina; School of Geography, Earth and Environmental Sciences, University of Birmingham, Birmingham, West Midlands, United Kingdom
#>                   countries
#> 1                      <NA>
#> 2     Jersey, United States
#> 3            China, Germany
#> 4                      <NA>
#> 5 Argentina, United Kingdom
```

## Bigger data set

Okay, cool, lets do it on a bigger data set, and this time, we'll get another variable `counter_total_all`, which is the combination of page views/pdf downloads for each article. This will allow us to ask _Is number of countries included in the authors related to page views?_. I have no idea if this question makes sense, but nonetheless, it is a question :)


```r
articles <- searchplos(q='*:*', limit = 1000,
    fl=c("id","counter_total_all","author_affiliate"), 
    fq=list('article_type:"Research Article"', "doc_type:full"))
#> 1 
#> 2
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

![plot of chunk unnamed-chunk-10](figure/unnamed-chunk-10-1.png) 

Conclusion: meh, maybe, maybe not

## Into rplos

We'll probably add a function like this into `rplos`, as a convenient way to handle this use case.
