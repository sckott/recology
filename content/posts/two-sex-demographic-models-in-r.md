---
name: two-sex-demographic-models-in-r
layout: post
title: Two-sex demographic models in R
author: Scott Chamberlain
date: 2011-10-26 09:31:00 -05:00
sourceslug: _posts/2011-10-26-two-sex-demographic-models-in-r.md
tags:
- Papers
- Ecology
- R
---

Tom Miller (a prof here at Rice) and Brian Inouye have a paper out in Ecology ([paper](http://www.esajournals.org/doi/abs/10.1890/11-0028.1), [appendices](http://www.esapubs.org/archive/archive_E.htm)) that confronts two-sex models of dispersal with empirical data. They conducted the first confrontation of two-sex demographic models with empirical data on lab populations of bean beetles _Callosobruchus_. Their R code for the modeling work is available at Ecological Archives (link [here](http://www.esapubs.org/archive/ecol/E092/186/)). Here is a figure made from running the five blocks of code in 'Miller\_and\_Inouye\_figures.txt' that reproduces Fig. 4 (A-E) in their Ecology paper (p = proportion female, Nt = density). Nice!  

A: Saturating density dependence  
B: Over-compensatory density dependence  
C: Sex-specific gamma's (but bM=bF=0.5)  
D: Sex-specific b's (but gammaM=gammaF=1) Sex-specific b's (but gammaM=gammaF=2)

[![](http://2.bp.blogspot.com/-Ht7fPEjDhQY/TqgYoiQQlPI/AAAAAAAAFEU/ehhPrxOseK4/s400/Screen+Shot+2011-10-26+at+9.26.11+AM.png)](http://2.bp.blogspot.com/-Ht7fPEjDhQY/TqgYoiQQlPI/AAAAAAAAFEU/ehhPrxOseK4/s1600/Screen+Shot+2011-10-26+at+9.26.11+AM.png)
