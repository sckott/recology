---
name: conditionality-meta-analysis
layout: post
title: Conditionality meta-analysis data
date: 2014-10-06
author: Scott Chamberlain
tags:
- R
- data
---

## The paper

One paper from my graduate work asked most generally ~ "How much does the variation in magnitudes and signs of species interaction outcomes vary?". More specifically, we wanted to know if variation differed among species interaction classes (mutualism, competition, predation), and among various "gradients" (space, time, etc.). To answer this question, we used a meta-analysis approach (rather than e.g., a field experiment). We [published the paper][ecolett] recently.

> p.s. I really really wish we would have put it in an open access journal...

## The data

Anyway, I'm here to talk about the __data__. We didn't get the data up with the paper, but it is [up on Figshare][fig] now. The files there are the following:

* `coniditionality.R` - script used to process the data from `variables_prelim.csv`
* `variables_prelim.csv` - description of variables in the preliminary data set, matches `conditionality_data_prelim.csv`
* `variables_used.csv` - description of variables in the used data set, matches `conditionality_data_used.csv`
* `conditionality_data_prelim.csv` - preliminary data, the raw data
* `conditionality_data_used.csv` - the data used for our paper
* `README.md` - the readme
* `paper_selection.csv` - the list of papers we went through, with remarks about paper selection

Please do play with the data, publish some papers, etc, etc. It took 6 of us about 4 years to collect this data; we skimmed through ~11,000 papers on the first pass (aka. skimming through abstracts in Google Scholar and Web of Science), then decided on nearly 500 papers to get data from, and narrowed down to 247 papers for the publication mentioned above. Now, there was no funding for this, so it was sort of done in between other projects, but still, it was simply __A LOT__ of tables to digitize, and graphs to extract data points from. __Anyway__, hopefully you will find this data useful :p

## EML

I think this dataset would be a great introduction to the potential power of EML ([Ecological Metadata Langauge][eml]). At [rOpenSci](http://ropensci.org/), one of our team [Carl Boettiger][carl], along with Claas-Thido Pfaff, Duncan Temple Lang, Karthik Ram, and Matt Jones, have created an R client for EML, to parse EML files and to create and publish them.

## What is EML?/Why EML?

A demonstration is in order...

## Example using EML with this dataset

### Install EML


```r
library("devtools")
install.packages("RHTMLForms", repos = "http://www.omegahat.org/R/", type="source")
install_github("ropensci/EML", build=FALSE, dependencies=c("DEPENDS", "IMPORTS"))
```

Load `EML`


```r
library('EML')
```

### Prepare metadata


```r
# dataset
prelim_dat <- read.csv("conditionality_data_prelim.csv")
# variable descriptions for each column
prelim_vars <- read.csv("variables_prelim.csv", stringsAsFactors = FALSE)
```

Get column definitions in a vector


```r
col_defs <- prelim_vars$description
```

Create unit definitions for each column


```r
unit_defs <- list(
  c(unit = "number",
    bounds = c(0, Inf)),
  c(unit = "number",
    bounds = c(0, Inf)),
  "independent replicates",
  c(unit = "number",
    bounds = c(0, Inf)),

  ... <CUTOFF>
)
```




### Write an EML file


```r
eml_write(prelim_dat,
          unit.defs = unit_defs,
          col.defs = col_defs,
          creator = "Scott Chamberlain",
          contact = "myrmecocystus@gmail.com",
          file = "conditionality_data_prelim_eml.xml")
```

```
## [1] "conditionality_data_prelim_eml.xml"
```

### Validate the EML file


```r
eml_validate("conditionality_data_prelim_eml.xml")
```

```
## EML specific tests XML specific tests 
##               TRUE               TRUE
```

### Read data and metadata


```r
gg <- eml_read("conditionality_data_prelim_eml.xml")
eml_get(gg, "contact")
```

```
## [1] "myrmecocystus@gmail.com"
```

```r
eml_get(gg, "citation_info")
```

```
## Chamberlain S (2014-10-06). _metadata_.
```

```r
dat <- eml_get(gg, "data.frame")
head(dat[,c(1:10)])
```

```
##   order i indrep avg author_last  finit_1 finit_2 finit_abv co_author
## 1     1 1      a   1      Devall margaret       s        ms     Thein
## 2     2 1      a   2      Devall margaret       s        ms     Thein
## 3     3 1      a   3      Devall margaret       s        ms     Thein
## 4     4 1      a   4      Devall margaret       s        ms     Thein
## 5     5 1      a   5      Devall margaret       s        ms     Thein
## 6     6 1      a   6      Devall margaret       s        ms     Thein
##   sinit_1
## 1 leonard
## 2 leonard
## 3 leonard
## 4 leonard
## 5 leonard
## 6 leonard
```

### Publish

We can also use the `EML` package to publish the data, here to [Figshare](http://figshare.com).

First, install `rfigshare`


```r
install.packages("rfigshare")
library('rfigshare')
```

Then publish using `eml_publish()`


```r
figid <- eml_publish(
            file = "conditionality_data_prelim_eml.xml",
            description = "EML file for Chamberlain, S.A., J.A. Rudgers, and J.L. Bronstein. 2014. How context-dependent are species interactions. Ecology Letters",
            categories = "Ecology",
            tags = "EML",
            destination = "figshare",
            visibility = "public",
            title = "condionality data, EML")
fs_make_public(figid)
```

![](/public/img/2014-10-06-conditionality-meta-analysis/figshare_conditional.png)

[ecolett]: http://scottchamberlain.info/publications/
[fig]: http://figshare.com/articles/Conditionality_data/1097657
[eml]: https://knb.ecoinformatics.org/#external//emlparser/docs/index.html
[carl]: http://www.carlboettiger.info/
