--- 
name: flora-north-america-scraping
layout: post
title: Scraping Flora of North America
author: Scott Chamberlain
date: 2012-01-27
sourceslug: _posts/2012-01-27-flora-north-america-scraping.md
tags: 
- R
- scraping
---

So [Flora of North America][fna] is an awesome collection of taxonomic information for plants across the continent.  However, the information within is not easily machine readable.  

So, a little web scraping is called for.

[rfna][] is an R package to collect information from the Flora of North America. 

So far, you can:
1. Get taxonomic names from web pages that index the names.
2. Then get daughter URLs for those taxa, which then have their own 2nd order daughter URLs you can scrape, or scrape the 1st order daughter page. 
3. Query Asteraceae taxa for whether they have paleate or epaleate receptacles.  This function is something I needed, but more functions will be made like this to get specific traits. 

Further functions will do search, etc.

You can install by:

```r
install.packages("devtools")
require(devtools)
install_github("rfna", "rOpenSci")
require(rfna)
```

Here is an example where a set of URLs is acquired using function `getdaughterURLs`, then the function `receptacle` is used to ask whether of each the taxa at those URLs have paleate or epaleate receptacles. 


```r
# A web page with taxa names you want to get trait data from
pg1 <- 'http://www.efloras.org/browse.aspx?flora_id=1&start_taxon_id=10074&page=1'


# Get the daughter URLs from the taxa on the page, using doMC to speed things up
urls <- getdaughterURLs(pg1, cores=TRUE, no_cores=2)
  |======================================================================================================| 100%


# Get the receptacle trait state for the taxa
ldply(urls, receptacle, .progress='text')
  |======================================================================================================| 100%
                  V1        V2
1      Acamptopappus  epaleate
2     Acanthospermum   paleate
3           Achillea   paleate
4       Achyrachaena   paleate
5            Acmella   paleate
6           Acourtia   paleate
7         Acroptilon  epaleate
8        Adenocaulon  epaleate
9       Adenophyllum  epaleate
10         Ageratina  epaleate
11          Ageratum  epaleate
12         Agnorhiza   paleate
13          Agoseris   paleate
14        Almutaster  epaleate
15       Amauriopsis  epaleate
16          Amberboa  epaleate
17       Amblyolepis  epaleate
18      Amblyopappus  epaleate
19          Ambrosia not found
20        Ampelaster  epaleate
21      Amphiachyris  epaleate
22       Amphipappus  epaleate
----#RESULTS CUT OFF FOR BREVITY#----
```


[fna]: http://fna.huh.harvard.edu/
[rfna]: https://github.com/ropensci/rfna
