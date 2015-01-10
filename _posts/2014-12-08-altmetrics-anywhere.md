---
name: icanhaz-altmetrics
layout: post
title: Altmetrics from anywhere
date: 2014-12-08
author: Scott Chamberlain
sourceslug: _drafts/2014-12-08-icanhaz-altmetrics.Rmd
tags:
- R
- API
- altmetrics
---



The Lagotto application is a Rails app that collects and serves up via RESTful API article level metrics data for research objects. So far, this application has only been applied to scholarly articles, but will [see action on datasets soon](http://articlemetrics.github.io/MDC/). 

[Martin Fenner](http://blog.martinfenner.org/) has lead the development of Lagotto. He recently set up [a discussion site](http://discuss.lagotto.io/) if you want to chat about it.

The application has a [nice GUI interface](http://alm.plos.org/), and a quite nice [RESTful API](http://alm.plos.org/docs/api). 

Lagotto is open source! Because of this, and the quality of the software, other publishers have started using it to gather and deliver publicly article level metrics data, including:

* [eLife](http://lagotto.svr.elifesciences.org/)
* [Public Knowledge Project (PKP)](http://pkp-alm.lib.sfu.ca/)
* [Copernicus](http://metricus.copernicus.org/)
* [Crossref](http://det.labs.crossref.org/)
* [Pensoft](http://alm.pensoft.net:81/)

The PLOS instance at [http://alm.plos.org/](http://alm.plos.org/) is always the most up to date with the Lagotto software, but [Crossref](http://det.labs.crossref.org/) has the largest number of articles. 

I've been working on three clients for the Lagotto REST API, including for a while now on `R`, recently on `Python`, and just last week on `Ruby`. 

Please do try the clients, report bugs, request features - you know the open source drill...

I'd say the R client is the most mature, while Python is less so, end the Ruby gem the least mature. 

## Installation

R


```r
install.packages("devtools")
devtools::install_github("ropensci/alm")
```

Python


```r
git clone https://github.com/cameronneylon/pyalm.git
cd pyalm
git checkout scott
python setup.py install
```

Ruby


```r
gem install httparty json rake
git clone https://github.com/sckott/alm.git
cd alm
make # which runs build and install tasks
```

If you don't have `make`, then just run `gem build alm.gemspec` and 	`gem install alm-0.1.0.gem` seperately.

## Example

In this example, we'll get altmetrics data for two DOIs: [10.1371/journal.pone.0029797](http://www.plosone.org/article/info%3Adoi%2F10.1371%2Fjournal.pone.0029797), and [10.1371/journal.pone.0029798](http://www.plosone.org/article/info%3Adoi%2F10.1371%2Fjournal.pone.0029798) (click on links to go to paper).

### R


```r
library('alm')
ids <- c("10.1371/journal.pone.0029797","10.1371/journal.pone.0029798")
alm_ids(ids, info="summary")
#> $meta
#>   total total_pages page error
#> 1     2           1    1    NA
#> 
#> $data
#> $data$`10.1371/journal.pone.0029798`
#> $data$`10.1371/journal.pone.0029798`$info
#>                            doi
#> 1 10.1371/journal.pone.0029798
#>                                                                                     title
#> 1 Mitochondrial Electron Transport Is the Cellular Target of the Oncology Drug Elesclomol
#>                                                                canonical_url
#> 1 http://www.plosone.org/article/info%3Adoi%2F10.1371%2Fjournal.pone.0029798
#>       pmid   pmcid                        mendeley_uuid
#> 1 22253786 3256171 b08cc99e-b526-3f0c-adaa-d5ee6d0d978a
#>            update_date     issued
#> 1 2014-12-09T02:52:47Z 2012-01-11
#> 
#> $data$`10.1371/journal.pone.0029798`$signposts
#>                            doi viewed saved discussed cited
#> 1 10.1371/journal.pone.0029798   4346    14         2    26
#> 
#> 
#> $data$`10.1371/journal.pone.0029797`
#> $data$`10.1371/journal.pone.0029797`$info
#>                            doi
#> 1 10.1371/journal.pone.0029797
#>                                                                             title
#> 1 Ecological Guild Evolution and the Discovery of the World's Smallest Vertebrate
#>                                                                canonical_url
#> 1 http://www.plosone.org/article/info%3Adoi%2F10.1371%2Fjournal.pone.0029797
#>       pmid   pmcid                        mendeley_uuid
#> 1 22253785 3256195 897fbbd6-5a23-3552-8077-97251b82c1e1
#>            update_date     issued
#> 1 2014-12-09T02:52:46Z 2012-01-11
#> 
#> $data$`10.1371/journal.pone.0029797`$signposts
#>                            doi viewed saved discussed cited
#> 1 10.1371/journal.pone.0029797  34282    81       244     8
```

### Python


```r
import pyalm
ids = ["10.1371/journal.pone.0029797","10.1371/journal.pone.0029798"]
pyalm.get_alm(ids, info="summary")

#> {'articles': [<ArticleALM Mitochondrial Electron Transport Is the Cellular Target of the Oncology Drug Elesclomol,
#> DOI 10.1371/journal.pone.0029798>,
#>   <ArticleALM Ecological Guild Evolution and the Discovery of the World's Smallest Vertebrate,
#>         DOI 10.1371/journal.pone.0029797>],
#>  'meta': {u'error': None, u'page': 1, u'total': 2, u'total_pages': 1}}
```

### Ruby


```r
require 'alm'
Alm.alm(ids: ["10.1371/journal.pone.0029797","10.1371/journal.pone.0029798"], key: ENV['PLOS_API_KEY'])

#> => {"total"=>2,
#>  "total_pages"=>1,
#>  "page"=>1,
#>  "error"=>nil,
#>  "data"=>
#>   [{"doi"=>"10.1371/journal.pone.0029798",
#>     "title"=>"Mitochondrial Electron Transport Is the Cellular Target of the Oncology Drug Elesclomol",
#>     "issued"=>{"date-parts"=>[[2012, 1, 11]]},
#>     "canonical_url"=>"http://www.plosone.org/article/info%3Adoi%2F10.1371%2Fjournal.pone.0029798",
#>     "pmid"=>"22253786",
#>     "pmcid"=>"3256171",
#>     "mendeley_uuid"=>"b08cc99e-b526-3f0c-adaa-d5ee6d0d978a",
#>     "viewed"=>4346,
#>     "saved"=>14,
#>     "discussed"=>2,
#>     "cited"=>26,
#>     "update_date"=>"2014-12-09T02:52:47Z"},
#>    {"doi"=>"10.1371/journal.pone.0029797",
#>     "title"=>"Ecological Guild Evolution and the Discovery of the World's Smallest Vertebrate",
#>     "issued"=>{"date-parts"=>[[2012, 1, 11]]},
#>     "canonical_url"=>"http://www.plosone.org/article/info%3Adoi%2F10.1371%2Fjournal.pone.0029797",
#>     "pmid"=>"22253785",
#>     "pmcid"=>"3256195",
#>     "mendeley_uuid"=>"897fbbd6-5a23-3552-8077-97251b82c1e1",
#>     "viewed"=>34282,
#>     "saved"=>81,
#>     "discussed"=>244,
#>     "cited"=>8,
#>     "update_date"=>"2014-12-09T02:52:46Z"}]}
```
