---
name: rnpn-r-interface-for-national-phenology
layout: post
title: "rnpn: An R interface for the National Phenology Network"
author: Scott Chamberlain
date: 2011-08-31 10:26:00 -05:00
sourceslug: _posts/2011-08-31-rnpn-r-interface-for-national-phenology.md
tags:
- ropensci
- API
- Ecology
- R
- Datasets
---

The team at [rOpenSci](http://ropensci.org/) and I have been working on a wrapper for the [USA National Phenology Network](http://www.usanpn.org/) API. The following is a demo of some of the current possibilities. We will have more functions down the road. Get the publicly available code, and contribute, at Github [here](https://github.com/ropensci/rnpn). If you try this out look at the [Description file](https://github.com/ropensci/rnpn/blob/master/DESCRIPTION) for the required R packages to run rnpn. Let us know at Github ([here](https://github.com/ropensci)) or at our website  [http://ropensci.org/](http://ropensci.org/), or in the comments below, or on twitter (@rOpenSci), what use cases you would like to see with the rnpn package.  
  
**Method and demo of each**:  
_**Get observations for species by day**_  
_From the documentation:_

> This function will return a list of species, containing all the dates which observations were made about the species, and a count of the number of such observations made on that date.

Note, the data below is truncated for blogging brevity...


```r
# Searched for any individuals at stations 507 and 523  
> getindsatstations(c(507, 523)) 
   individual_id individual_name species_id kingdom
1           1200         dogwood         12 Plantae
2           1197    purple lilac         36 Plantae
3           1193         white t         38 Plantae
4           3569     forsythia-1         73 Plantae
5           1206            jack        150 Plantae
6           1199      trout lily        161 Plantae
7           1198           dandy        189 Plantae
8           1192           red t        192 Plantae
9           1710    common lilac         36 Plantae
10          1711  common lilac 2         36 Plantae
11          1712       dandelion        189 Plantae
```

_**Get individuals of species at stations**_  

From the documentation: "This function will return a list of all the individuals, which are members of a species, among  any number of stations."

{{< line_break >}}

Search for individuals of species 35 at stations 60 and 259 in year 2009  
  
```r
> getindspatstations(35, c(60, 259), 2009)
  individual_id individual_name number_observations
1          1715            west                   5
2          1716            east                   5
```

_**Get observation associated with particular observation**_  

From the documentation: "This function will return the comment associated with a particular observation."  

```r  
# The observation for observation number 1938  
> getobscomm(1938)
$observation_comment  
[1] "some lower branches are bare"
```
