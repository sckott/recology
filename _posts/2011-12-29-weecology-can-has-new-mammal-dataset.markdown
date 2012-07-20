--- 
name: weecology-can-has-new-mammal-dataset
layout: post
title: Weecology can has new mammal dataset
author: Scott Chamberlain
date: 2011-12-29 08:11:00 -06:00
tags: 
- Datasets
- ggplot2
- plyr 
- R
- ropensci
- stringr
- treebase
- weecology
---


So the [Weecology][] folks have published a large dataset on mammal communities in a data paper in [Ecology][]. I know nothing about mammal communities, but that doesn't mean one can't play with the data...

### Their dataset consists of five csv files: 
+ communities, 
+ references,
+ sites,
+ species, and 
+ trapping data

### Where are these sites, and by the way, do they vary much in altitude?

<a href="http://3.bp.blogspot.com/-BKqBoPCDA_A/Tvx9nLbMlkI/AAAAAAAAFPA/9_pG_Ihx33I/s1600/usmap.png" style="margin-left: 1em; margin-right: 1em;"><img src="http://3.bp.blogspot.com/-BKqBoPCDA_A/Tvx9nLbMlkI/AAAAAAAAFPA/9_pG_Ihx33I/s1600/usmap.png" height="230" width="400"/>

<a href="http://1.bp.blogspot.com/-KkU_EcX8-EY/Tvx9n7hiP9I/AAAAAAAAFPI/7LoV0IjRiAM/s1600/worldmap.png" style="margin-left: 1em; margin-right: 1em;"><img src="http://1.bp.blogspot.com/-KkU_EcX8-EY/Tvx9n7hiP9I/AAAAAAAAFPI/7LoV0IjRiAM/s1600/worldmap.png" height="230" width="400"/>

### Let's zoom in on just the states

<a href="http://3.bp.blogspot.com/-BKqBoPCDA_A/Tvx9nLbMlkI/AAAAAAAAFPA/9_pG_Ihx33I/s1600/usmap.png" style="margin-left: 1em; margin-right: 1em;"><img src="http://3.bp.blogspot.com/-BKqBoPCDA_A/Tvx9nLbMlkI/AAAAAAAAFPA/9_pG_Ihx33I/s1600/usmap.png" height="230" width="400"/>

### What phylogenies can we get for the species in this dataset?

We can use the [rOpenSci package treebase] to search the online phylogeny repository [TreeBASE][]. Limiting to returning a max of 1 tree (to save time), we can see that X species are in at least 1 tree on the TreeBASE database. Nice.

So there are 321 species in the database with at least 1 tree in the TreeBASE database. Of course there could be many more, but we limited results from TreeBASE to just 1 tree per query.

### Here's the code:

<script src="https://gist.github.com/1534730.js?file=mammaldataset.R"></script>



[Weecology]: http://weecology.org/
[Ecology]: http://www.esajournals.org/doi/abs/10.1890/11-0262.1
[rOpenSci package treebase]: http://cran.r-project.org/web/packages/treebase/
[TreeBASE]: http://www.treebase.org/treebase-web/home.html