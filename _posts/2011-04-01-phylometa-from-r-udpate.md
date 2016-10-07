---
name: phylometa-from-r-udpate
layout: post
title: Phylometa from R - UDPATE
author: Scott Chamberlain
date: 2011-04-01 16:18:00.003000 -05:00
sourceslug: _posts/2011-04-01-phylometa-from-r-udpate.md
tags:
- ggplot2
- meta-analysis
- Phylogenetics
- R
---

A while back I posted some messy code to run Phylometa from R, especially useful for processing the output data from Phylometa which is not easily done. The code is still quite messy, but it should work now. I have run the code with tens of different data sets and phylogenies so it should work.

I fixed errors when parentheses came up against numbers in the output, and other things. You can use the code for up to 4 levels of your grouping variable. In addition, there are some lines of code to plot the effect sizes with confidence intervals, comparing random and fixed effects models and phylogenetic and traditional models.

The code is in a Gist at <https://gist.github.com/sckott/939970>, and embedde below:

<script src="https://gist.github.com/sckott/939970.js"></script>

Use the first file to do the work, calling the second file using `source()`.

This new code works with Marc's new version of Phylometa, so please update: <http://lajeunesse.myweb.usf.edu>

Again, please let me know if it doesn't work, if it's worthless, what changes could make it better.

Some notes on tree formatting for Phylometa.

* Trees cannot have node labels - remove them (e.g., tree$node.label &lt; NULL)
* Trees cannot have zero length branches. This may seem like a non-problem, but it might be for example if you have resolved polytomies and zero length branches are added to resolve the polytomy.
* I think you cannot have a branch length on the root branch.
