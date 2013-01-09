---
name: is-invasive
layout: post
title: Is invasive?
date: 2012-12-13
author: Scott Chamberlain
tags: 
- R
- ropensci
- taxize
- invasive
---

The Global Invasive Species Database (GISD) (see their website for more info [here](http://www.issg.org/database/welcome/)) has data on the invasiveness status of many species. From `taxize` you can now query the GISD database. 

Introducing the function `gisd_isinvasive`. This function was contributed to `taxize` by [Ignasi Bartomeus](http://www.bartomeus.cat/es/ignasi/), a postdoc at the Swedish University Agricultural Sciences. 

There are two possible outputs from using `gisd_isinvasive`: "Invasive" or "Not in GISD". If you use `simplify=TRUE` in the function you get "Invasive" or "Not in GISD", but if you use `simplify=FALSE` you get verbose description of the invasive species instead of just "Invasive" (and you still just get "Not in GISD"). 

***************

![center](http://schamberlain.github.com/img/gisd_small.png) 

***************

### Install taxize from GitHub

{% highlight r %}
# install_github('taxize_', 'ropensci') # install if you don't already
# have the GitHub version
library(taxize)
{% endhighlight %}


***************

### Make a vector of species

{% highlight r %}
sp <- c("Carpobrotus edulis", "Rosmarinus officinalis", "Nasua nasua", "Martes melampus", 
    "Centaurea solstitialis")
{% endhighlight %}


### Using the function `gisd_isinvasive` you can query the GISD database for the invasiveness status of your species, at least according to GISD. Calling `gisd_isinvasive` with the second parameter set to default `simplify=FALSE`, you get verbose output, with details on the species. 

{% highlight r %}
gisd_isinvasive(sp)
{% endhighlight %}



{% highlight text %}
Checking species 1
Checking species 2
Checking species 3
Checking species 4
Checking species 5
Done

                 species
1     Carpobrotus edulis
2 Rosmarinus officinalis
3            Nasua nasua
4        Martes melampus
5 Centaurea solstitialis
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               status
1                                                                                                                                                                                                                                                  You searched for invasive species named Carpobrotus edulis:     1.  Carpobrotus edulis (succulent)        Carpobrotus edulis is a mat-forming succulent native to South Africa which is invasive primarily in coastal habitats in many parts of the world. It was often introduced as an ornamental plant or used for planting along roadsides, from which it has spread to become invasive. Its main impacts are smothering, reduced regeneration of native flora and changes to soil pH and nutrient regimes.\r\nCommon Names: balsamo, Cape fig, figue marine, freeway iceplant, ghaukum, ghoenavy, highway ice plant, higo del Cabo, higo marino, Hottentosvy, hottentot fig, Hottentottenfeige, iceplant, ikhambi-lamabulawo, Kaapsevy, patata frita, perdevy, pigface, rankvy, sea fig, sour fig, suurvy, umgongozi, vyerank\r\nSynonyms: Mesembryanthemum edule L., Mesembryanthemum edulis
2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         Not in GISD
3                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            You searched for invasive species named Nasua nasua:1.  Nasua nasua (mammal)             Interim profile, incomplete informationCommon Names: Achuni, Coatí, South American Coati, Tejón
4                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       You searched for invasive species named Martes melampus:1.  Martes melampus (mammal)             Interim profile, incomplete informationCommon Names: Japanese Marten, Tsushima Island Marten
5 You searched for invasive species named Centaurea solstitialis:     1.  Centaurea solstitialis (herb)        Centaurea solstitialis is a winter annual that can form dense impenetrable stands that displace desirable vegetation in natural areas, rangelands, and other places. It is best adapted to open grasslands with deep, well-drained soils and an annual precipitation range of 25 to 150cm per year. It is intolerant of shade. Although populations can occur at elevations as high as 2,400 m, most large infestations are found below 1,500 m. Human activities are the primary mechanisms for the long distance movement of C. solstitialis seed. The short, stiff, pappus bristles are covered with barbs that readily adhere to clothing, hair, and fur.  The movement of contaminated hay and uncertified seed are also important long distance transportation mechanisms. Wind disperses seeds over short distances.\r\nCommon Names: geeldissel, golden star thistle, sonnwend-Flockenblume, St. Barnaby's thistle, yellow centaury, yellow cockspur, yellow star thistle\r\nSynonyms: Leucantha solstitialis (L.) A.& D. Löve
{% endhighlight %}


### Simpler output, just the invasive status. 

{% highlight r %}
gisd_isinvasive(sp, simplify = TRUE)
{% endhighlight %}



{% highlight text %}
Checking species 1
Checking species 2
Checking species 3
Checking species 4
Checking species 5
Done

                 species      status
1     Carpobrotus edulis    Invasive
2 Rosmarinus officinalis Not in GISD
3            Nasua nasua    Invasive
4        Martes melampus    Invasive
5 Centaurea solstitialis    Invasive
{% endhighlight %}


*********

#### Get the .Rmd file used to create this post [at my github account](https://github.com/SChamberlain/scott/blob/gh-pages/_drafts/2012-12-13-is-invasive.Rmd) - or [.md file](https://github.com/SChamberlain/scott/blob/gh-pages/_posts/2012-12-13-is-invasive.md).

#### Written in [Markdown](http://daringfireball.net/projects/markdown/), with help from [knitr](http://yihui.name/knitr/).
