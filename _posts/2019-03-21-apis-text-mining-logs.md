---
name: apis-text-mining-logs
layout: post
title: "text mining, apis, and parsing api logs"
date: 2019-03-21
author: Scott Chamberlain
sourceslug: _drafts/2019-03-21-apis-text-mining-logs.Rmd
tags:
- R
- API
- text-mining
- DOI
---



## Acquiring full text articles

[fulltext][] is an R package I maintain to obtain full text versions of research articles
for text mining.

It's a hard problem, with a sphagetti web of code. One of the hard problems is 
figuring out what the URL is for the full text version of an article. Publishers
do not have consistent URL patterns through time, and so you can not set rules once 
and never revisit them. 

The [Crossref API](https://github.com/CrossRef/rest-api-doc) has links available to 
full text versions for publishers that choose to share them. However, even if 
publishers choose to share their full text links, they may be out of date or completely
wrong (not actually lead to the full text). 

There's a variety of other APIs out there for getting links to articles, but none 
really hit the spot, which lead to the creation of the [ftdoi API][ftdoi]. 

## the ftdoi API

The [ftdoi API][ftdoi] is a web API, with it's main goal for getting a best guess at
the URL for the full text version of an article from it's DOI (this is done via the 
`/api/doi/{doi}/` route). The API gives back URLs for all those possible, including
pdf, xml, and html. Most publishers only give full text as PDF, but when XML is
available we give those URLs as well.

The API uses the rules maintained in the [pubpatterns](https://github.com/ropenscilabs/pubpatterns/tree/master/src)
repo. The rules are only rough guidelines though and often require at least one 
step of making a web request to the publishers site or another site, that's NOT 
specified in the pubpatterns rules. For example, the [Biorxiv file](https://github.com/ropenscilabs/pubpatterns/blob/master/src/biorxiv.json)
has notes about how to get the parts necessary for the full URL, but the actual logic 
to do so in in the API code base [here](https://github.com/ropenscilabs/pubpatternsapi/blob/master/utils.rb#L590-L601). 

The ftdoi API caches responses for requests for 24 hrs, so even if a request takes 5 seconds
or so to process, at least for the next 24 hrs it will be nearly instantaneous. We don't 
want to cache indefinitely because URLs may be changed at any time by the publishers.

The `fulltext` package uses the ftdoi API internally, mostly hidden from users, to 
get a full text URL.

## But why an API?

Why not just have a set of rules in the `fulltext` R package, and go from there?
An API was relatively easy for me to stand up, and i think it has many benefits:
can be used by anything/anyone, not just R users; updates to publisher specific
rules for generating URLs can evolve independently of `fulltext`; the logs
can be used as a tool to improve the API.

## what do people actually want?

The ftdoi API has been running for a while now, maybe a year or so, and I've been 
collecting logs. Seems smart to look at the logs to determine what publishers 
users are requesting articles from that the ftdoi API does not currently support,
so that the API can hopefully add those publishers. For obvious reasons, I can't share
the log data.

Load packages and define file path. 


```r
library(rcrossref)
library(dplyr)
library(rex)
logs <- "~/pubpatterns_api_calls.log"
```

Use the awesome [rex][] package from Kevin Ushey et al. to parse the logs, pulling out
just the Crossref member ID in the API request, as well as the HTTP status code. There
are of course other API requests in the logs, but we're only interested here in the ones
to the `/api/doi/{doi}/` route.


```r
df <- tbl_df(scan(logs, what = "character", sep = "\n") %>%
  re_matches(
    rex(
      "/api/members/",
        capture(name = "route",
          one_or_more(numbers)
        ),
      "/",

      space, space, "HTTP/", numbers, ".", numbers, space,

      capture(name = "status_code",
        one_or_more(numbers)
      )
    )
  ))
df$route <- as.numeric(df$route)
df
#> # A tibble: 896,035 x 2
#>    route status_code
#>    <dbl> <chr>      
#>  1    NA <NA>       
#>  2   317 200        
#>  3    19 400        
#>  4  2308 400        
#>  5   239 400        
#>  6  2581 400        
#>  7    27 400        
#>  8   297 200        
#>  9  7995 400        
#> 10    NA <NA>       
#> # … with 896,025 more rows
```

Filter to those requests that resulted in a 400 HTTP status code, that is, they 
resulted in no returned data, indicating that we likely do not have a mapping for that 
Crossref member.



```r
res <- df %>%
  filter(status_code == 400) %>%
  select(route) %>% 
  group_by(route) %>%
  summarize(count = n()) %>% 
  arrange(desc(count))
res
#> # A tibble: 530 x 2
#>    route  count
#>    <dbl>  <int>
#>  1    10 345045
#>  2   530   7165
#>  3   286   3062
#>  4   276   2975
#>  5   239   2493
#>  6  8611   1085
#>  7    56    853
#>  8   235    722
#>  9   382    706
#> 10   175    590
#> # … with 520 more rows
```

Add crossref metadata


```r
(members <- cr_members(res$route))
#> $meta
#> NULL
#> 
#> $data
#> # A tibble: 530 x 56
#>       id primary_name location last_status_che… total.dois current.dois
#>    <int> <chr>        <chr>    <date>           <chr>      <chr>       
#>  1    10 American Me… 330 N. … 2019-03-20       600092     14714       
#>  2   530 FapUNIFESP … FAP-UNI… 2019-03-20       353338     38339       
#>  3   286 Oxford Univ… Academi… 2019-03-20       3696643    289338      
#>  4   276 Ovid Techno… 100 Riv… 2019-03-20       2059352    167272      
#>  5   239 BMJ          BMA Hou… 2019-03-20       891239     61267       
#>  6  8611 AME Publish… c/o NAN… 2019-03-20       20067      15666       
#>  7    56 Cambridge U… The Edi… 2019-03-20       1529029    84018       
#>  8   235 American So… 1752 N … 2019-03-20       178890     13984       
#>  9   382 Joule Inc.   1031 Ba… 2019-03-20       12666      1868        
#> 10   175 The Royal S… 6 Carlt… 2019-03-20       89219      7262        
#> # … with 520 more rows, and 50 more variables: backfile.dois <chr>,
#> #   prefixes <chr>, coverge.affiliations.current <chr>,
#> #   coverge.similarity.checking.current <chr>,
#> #   coverge.funders.backfile <chr>, coverge.licenses.backfile <chr>,
#> #   coverge.funders.current <chr>, coverge.affiliations.backfile <chr>,
#> #   coverge.resource.links.backfile <chr>, coverge.orcids.backfile <chr>,
#> #   coverge.update.policies.current <chr>,
#> #   coverge.open.references.backfile <chr>, coverge.orcids.current <chr>,
#> #   coverge.similarity.checking.backfile <chr>,
#> #   coverge.references.backfile <chr>,
#> #   coverge.award.numbers.backfile <chr>,
#> #   coverge.update.policies.backfile <chr>,
#> #   coverge.licenses.current <chr>, coverge.award.numbers.current <chr>,
#> #   coverge.abstracts.backfile <chr>,
#> #   coverge.resource.links.current <chr>, coverge.abstracts.current <chr>,
#> #   coverge.open.references.current <chr>,
#> #   coverge.references.current <chr>,
#> #   flags.deposits.abstracts.current <chr>,
#> #   flags.deposits.orcids.current <chr>, flags.deposits <chr>,
#> #   flags.deposits.affiliations.backfile <chr>,
#> #   flags.deposits.update.policies.backfile <chr>,
#> #   flags.deposits.similarity.checking.backfile <chr>,
#> #   flags.deposits.award.numbers.current <chr>,
#> #   flags.deposits.resource.links.current <chr>,
#> #   flags.deposits.articles <chr>,
#> #   flags.deposits.affiliations.current <chr>,
#> #   flags.deposits.funders.current <chr>,
#> #   flags.deposits.references.backfile <chr>,
#> #   flags.deposits.abstracts.backfile <chr>,
#> #   flags.deposits.licenses.backfile <chr>,
#> #   flags.deposits.award.numbers.backfile <chr>,
#> #   flags.deposits.open.references.backfile <chr>,
#> #   flags.deposits.open.references.current <chr>,
#> #   flags.deposits.references.current <chr>,
#> #   flags.deposits.resource.links.backfile <chr>,
#> #   flags.deposits.orcids.backfile <chr>,
#> #   flags.deposits.funders.backfile <chr>,
#> #   flags.deposits.update.policies.current <chr>,
#> #   flags.deposits.similarity.checking.current <chr>,
#> #   flags.deposits.licenses.current <chr>, names <chr>, tokens <chr>
#> 
#> $facets
#> NULL
```

Add Crossref member names to the log data.


```r
alldat <- left_join(res, select(members$data, id, primary_name),
  by = c("route" = "id"))
alldat
#> # A tibble: 530 x 3
#>    route  count primary_name                             
#>    <dbl>  <int> <chr>                                    
#>  1    10 345045 American Medical Association (AMA)       
#>  2   530   7165 FapUNIFESP (SciELO)                      
#>  3   286   3062 Oxford University Press (OUP)            
#>  4   276   2975 Ovid Technologies (Wolters Kluwer Health)
#>  5   239   2493 BMJ                                      
#>  6  8611   1085 AME Publishing Company                   
#>  7    56    853 Cambridge University Press (CUP)         
#>  8   235    722 American Society for Microbiology        
#>  9   382    706 Joule Inc.                               
#> 10   175    590 The Royal Society                        
#> # … with 520 more rows
```

Theres **A LOT** of requests to the American Medical Association. Coming in
a distant second is FapUNIFESP (SciELO), then the Oxford University Press,
Ovid Technologies (Wolters Kluwer Health), BMJ, and AME Publishing Company, 
all with greater than 1000 requests.

These are some clear leads for publishers to work into the ftdoi API, working
my way down the data.frame to less frequently requested publishers.


## more work to do

I've got a good list of publishers which I know users want URLs for, so 
I can get started implementing rules/etc. for those publishers. And I can 
repeat this process from time to time to add more publishers in high demand.



[fulltext]: https://github.com/ropensci/fulltext/
[ftdoi]: https://ftdoi.org/
[rex]: https://github.com/kevinushey/rex/
