---
name: get-taxa-downstream
layout: post
title: Getting taxonomic names downstream
date: 2012-10-16
author: Scott Chamberlain
sourceslug: _drafts/2012-10-16-get-taxa-downstream.Rmd
tags: 
- R
- open access
- data
- taxonomy
- ropensci
- ritis
- taxize
---

It can be a pain in the ass to get taxonomic names. For example, I sometimes need to get all the Class names for a set of species.  This is a relatively easy problem using the [ITIS API](http://www.itis.gov/ws_description.html) (example below).  

The much harder problem is getting all the taxonomic names downstream. ITIS doesn't provide an API method for this - well, they do ([`getHirerachyDownFromTSN`](http://www.itis.gov/ws_hierApiDescription.html#getHierarchyDn)), but it only provides direct children (e.g., the genera within a tribe - but it won't give all the species within each genus).  

So in the `taxize` package, we wrote a function called `downstream`, which allows you to get taxonomic names to any downstream point, e.g.:

+ get all Classes within Animalia,
+ get all Species within a Family
+ etc.

### Install packages.  You can get other packages from CRAN, but taxize is only on GitHub for now. 

{% highlight r linenos %}
# install_github('ritis', 'ropensci') # uncomment if not already installed
# install_github('taxize_', 'ropensci') # uncomment if not already
# installed
library(ritis)
library(taxize)
{% endhighlight %}


### Get upstream taxonomic names.

{% highlight r linenos %}
# Search for a TSN by scientific name
df <- searchbyscientificname("Tardigrada")
tsn <- df[df$combinedname %in% "Tardigrada", "tsn"]

# Get just one immediate higher taxonomic name
gethierarchyupfromtsn(tsn = tsn)
{% endhighlight %}



{% highlight text %}
  parentName parentTsn rankName  taxonName    tsn
1   Animalia    202423   Phylum Tardigrada 155166
{% endhighlight %}



{% highlight r linenos %}

# Get full hierarchy upstream from TSN
getfullhierarchyfromtsn(tsn = tsn)
{% endhighlight %}



{% highlight text %}
  parentName parentTsn rankName        taxonName    tsn
1                       Kingdom         Animalia 202423
2   Animalia    202423   Phylum       Tardigrada 155166
3 Tardigrada    155166    Class     Eutardigrada 155362
4 Tardigrada    155166    Class Heterotardigrada 155167
5 Tardigrada    155166    Class   Mesotardigrada 155358
{% endhighlight %}


### Get taxonomc names downstream.

{% highlight r linenos %}
# Get genera downstream fromthe Class Bangiophyceae
downstream(846509, "Genus")
{% endhighlight %}



{% highlight text %}
    tsn parentName parentTsn   taxonName rankId rankName
1 11531 Bangiaceae     11530      Bangia    180    Genus
2 11540 Bangiaceae     11530    Porphyra    180    Genus
3 11577 Bangiaceae     11530 Porphyrella    180    Genus
4 11580 Bangiaceae     11530 Conchocelis    180    Genus
{% endhighlight %}



{% highlight r linenos %}

# Get families downstream from Acridoidea
downstream(650497, "Family")
{% endhighlight %}



{% highlight text %}
      tsn parentName parentTsn      taxonName rankId rankName
1  102195 Acridoidea    650497      Acrididae    140   Family
2  650502 Acridoidea    650497     Romaleidae    140   Family
3  657472 Acridoidea    650497    Charilaidae    140   Family
4  657473 Acridoidea    650497   Lathiceridae    140   Family
5  657474 Acridoidea    650497     Lentulidae    140   Family
6  657475 Acridoidea    650497    Lithidiidae    140   Family
7  657476 Acridoidea    650497   Ommexechidae    140   Family
8  657477 Acridoidea    650497    Pamphagidae    140   Family
9  657478 Acridoidea    650497  Pyrgacrididae    140   Family
10 657479 Acridoidea    650497    Tristiridae    140   Family
11 657492 Acridoidea    650497 Dericorythidae    140   Family
{% endhighlight %}



{% highlight r linenos %}

# Get species downstream from Ursus
downstream(180541, "Species")
{% endhighlight %}



{% highlight text %}
     tsn parentName parentTsn        taxonName rankId rankName
1 180542      Ursus    180541  Ursus maritimus    220  Species
2 180543      Ursus    180541     Ursus arctos    220  Species
3 180544      Ursus    180541 Ursus americanus    220  Species
4 621850      Ursus    180541 Ursus thibetanus    220  Species
{% endhighlight %}


*********
#### Get the .Rmd file used to create this post [at my github account](https://github.com/sckott/sckott.github.com/tree/master/_drafts/2012-10-16-get-taxa-downstream.Rmd) - or [.md file](https://github.com/sckott/sckott.github.com/tree/master/_posts/2012-10-16-get-taxa-downstream.md).

#### Written in [Markdown](http://daringfireball.net/projects/markdown/), with help from [knitr](http://yihui.name/knitr/).
