--- 
name: treebase-trees-from-r
layout: post
title: Treebase trees from R
date: 2011-05-03 10:00:00.001000 -05:00
categories: 
- Phylogenetics
- R
---
UPDATE: See Carl Boettiger's functions/package at Github for searching Treebase <a href="https://github.com/ropensci/treeBASE">here</a>.<br /><br /><br /><br />Treebase is a great resource for phylogenetic trees, and has a nice interface for searching for certain types of trees. However, if you want to simply download a lot of trees for analyses (like that in <a href="http://biology.mcgill.ca/faculty/davies/pdfs/Davies_etal_Evolution_2011.pdf">Davies et al.</a>), then you want to be able to access trees in bulk (I believe Treebase folks are working on an API though). I wrote some simple code for extracting trees from <a href="http://treebase.org/">Treebase.org</a>.<br /><br />It reads an xml file of (in this case consensus) URL's for each tree, parses the xml, makes a vector of URL's, reads the nexus files with error checking, remove trees that gave errors, then a simple plot looking at metrics of the trees.<br /><br />Is there an easier way to do this?<br /><br /><br /><br /><script src="https://gist.github.com/953468.js?file=treebase_code.R"></script><br /><div class="separator" style="clear: both; text-align: center;"><a href="http://2.bp.blogspot.com/-AaMexPVCreo/TcAW171ZBaI/AAAAAAAAEbc/bDafe7YgGcw/s1600/sampetreebaseplot.png" imageanchor="1" style="clear: left; float: left; margin-bottom: 1em; margin-right: 1em;"><img border="0" height="256" src="http://2.bp.blogspot.com/-AaMexPVCreo/TcAW171ZBaI/AAAAAAAAEbc/bDafe7YgGcw/s320/sampetreebaseplot.png" width="320" /></a></div>
