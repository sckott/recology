--- 
name: weecology-can-has-new-mammal-dataset
layout: post
title: Weecology can has new mammal dataset
date: 2011-12-29 08:11:00 -06:00
categories: 
- Datasets
- ggplot2
- plyr 
- R
- ropensci
- stringr
- treebase
- weecology
---


So the <a href="http://weecology.org/" target="_blank">Weecology folks</a>&nbsp;have published a large dataset on mammal communities in a data paper in <a href="http://www.esajournals.org/doi/abs/10.1890/11-0262.1" target="_blank">Ecology</a>. &nbsp;I know nothing about mammal communities, but that doesn't mean one can't play with the data...<br />
<br />
Their dataset consists of five csv files: &nbsp;communities, references, sites, species, and trapping data. <br />
<br />
<b>Where are these sites, and by the way, do they vary much in altitude?</b><br />
<span id="goog_1028233179"></span><span id="goog_1028233180"></span><br />
<div class="separator" style="clear: both; text-align: center;">
<a href="http://3.bp.blogspot.com/-BKqBoPCDA_A/Tvx9nLbMlkI/AAAAAAAAFPA/9_pG_Ihx33I/s1600/usmap.png" imageanchor="1" style="margin-left: 1em; margin-right: 1em;"><br /></a></div>
<div class="separator" style="clear: both; text-align: center;">
<a href="http://1.bp.blogspot.com/-KkU_EcX8-EY/Tvx9n7hiP9I/AAAAAAAAFPI/7LoV0IjRiAM/s1600/worldmap.png" imageanchor="1" style="clear: left; float: left; margin-bottom: 1em; margin-right: 1em;"><img border="0" height="230" src="http://1.bp.blogspot.com/-KkU_EcX8-EY/Tvx9n7hiP9I/AAAAAAAAFPI/7LoV0IjRiAM/s400/worldmap.png" width="400" /></a></div>
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<b>Let's zoom in on just 'the states'?</b><br />
<br />
<a href="http://3.bp.blogspot.com/-BKqBoPCDA_A/Tvx9nLbMlkI/AAAAAAAAFPA/9_pG_Ihx33I/s1600/usmap.png" style="margin-left: 1em; margin-right: 1em;"><img border="0" height="230" src="http://3.bp.blogspot.com/-BKqBoPCDA_A/Tvx9nLbMlkI/AAAAAAAAFPA/9_pG_Ihx33I/s400/usmap.png" width="400" /></a> <br />
<br />
<b>What phylogenies can we get for the species in this dataset?</b><br />
We can use the <a href="http://cran.r-project.org/web/packages/treebase/" target="_blank">rOpenSci package treebase</a> to search the online phylogeny repository <a href="http://www.treebase.org/treebase-web/home.html" target="_blank">TreeBASE</a>.&nbsp; Limiting to returning a max of 1 tree (to save time), we can see that X species are in at least 1 tree on the TreeBASE database.&nbsp; Nice.&nbsp; <br />
<br />
So there are 321 species in the database with at least 1 tree in the TreeBASE database.&nbsp; Of course there could be many more, but we limited results from TreeBASE to just 1 tree per query.&nbsp; <br />
<br />
<b>Here's the code:</b><br />
<br />
<script src="https://gist.github.com/1534730.js?file=mammaldataset.R">
</script>
