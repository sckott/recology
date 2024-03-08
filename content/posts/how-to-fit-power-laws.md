--- 
name: how-to-fit-power-laws
layout: post
title: How to fit power laws
author: Scott Chamberlain
date: 2011-06-07 15:24:00 -05:00
sourceslug: _posts/2011-06-07-how-to-fit-power-laws.md
tags: 
- Methods
- Papers
- Statistics
- R
---

A new paper out in Ecology by Xiao and colleagues (in press, [here](http://www.esajournals.org/doi/abs/10.1890/11-0538.1)) compares the use of log-transformation to non-linear regression for analyzing power-laws.  
  
They suggest that the error distribution should determine which method performs better. When your errors are additive, homoscedastic, and normally distributed, they propose using non-linear regression. When errors are multiplicative, heteroscedastic, and lognormally distributed, they suggest using linear regression on log-transformed data. The assumptions about these two methods are different, so cannot be correct for a single dataset.  
  
They will provide their R code for their methods once they are up on Ecological Archives (they weren't up there by the time of this post).
