--- 
name: new-approach-to-analysis-of-phylogenetic-community-structure
layout: post
title: New approach to analysis of phylogenetic community structure
date: 2011-01-05 07:54:00.001000 -06:00
categories: 
- Evolution
- Papers
- Ecology
- Phylogenetics
- Picante
- R
---

Anthony Ives, of University of Wisconsin-Madison, and Matthew Helmus of the Xishuangbanna Tropical Botanical Garden, present a new statistical method for analyzing phylogenetic community structure in an early view paper in Ecological Monographs. See the abstract [here][esa]. 

Up to now, most phylogenetic community structure papers have calculated metrics and used randomization tests to determine if observed metrics are different from random. The approach of Ives and Helmus fits models to observed data, instead of calculating single metrics.

Furthermore, their approach gets around the limitation in studies of phylogenetic community structure of conducting many separate statistical tests, thereby inflating your chances of finding a significant effect purely by chance.

Their approach uses generalized linear mixed models (GLMMs). They provide Matlab code for running these models, but R code will be available in the Picante package in the future.

[esa]: http://www.esajournals.org/doi/abs/10.1890/10-1264.1
