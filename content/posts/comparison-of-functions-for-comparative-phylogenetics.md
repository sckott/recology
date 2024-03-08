--- 
name: comparison-of-functions-for-comparative-phylogenetics
layout: post
title: Comparison of functions for comparative phylogenetics
author: Scott Chamberlain
date: 2011-05-11 10:08:00 -05:00
sourceslug: _posts/2011-05-11-comparison-of-functions-for-comparative-phylogenetics.md
tags: 
- Evolution
- ape
- Phylogenetics
- R
- motmot
---

With all the packages (and beta stage groups of functions) for comparative phylogenetics in R (tested here: picante, geiger, ape, motmot, Liam Revell's functions), I was simply interested in which functions to use in cases where multiple functions exist to do the same thing. I only show default settings, so perhaps these functions would differ under different parameter settings. [I am using a Mac 2.4 GHz i5, 4GB RAM]

Get motmot here: [https://r-forge.r-project.org/R/?group\_id=782](https://r-forge.r-project.org/R/?group_id=782)  

Get Liam Revell's functions here: [http://anolis.oeb.harvard.edu/~liam/R-phylogenetics/](http://anolis.oeb.harvard.edu/~liam/R-phylogenetics/)


```r
> # Load 
require(motmot); require(geiger); require(picante)
source("http://anolis.oeb.harvard.edu/~liam/R-phylogenetics/phylosig/v0.3/phylosig.R")
source("http://anolis.oeb.harvard.edu/~liam/R-phylogenetics/fastBM/v0.4/fastBM.R")
 
# Make tree
tree <- rcoal(10)
 
# Transform branch lengths
> system.time( replicate(1000, transformPhylo(tree, model = "lambda", lambda = 0.5)) ) # motmot
   user  system elapsed 
  1.757   0.004   1.762 
> system.time( replicate(1000, lambdaTree(tree, 0.9)) ) # geiger
   user  system elapsed 
  3.708   0.008   3.716 
>   # motmot wins!!!


# Simulate trait evolution
system.time( replicate(1000, transformPhylo.sim(tree, model = "bm")) ) # motmot
   user  system elapsed 
  3.732   0.007   3.741 
> system.time( replicate(1000, rTraitCont(tree, model = "BM")) ) # ape
   user  system elapsed 
  0.312   0.009   0.321 
> system.time( replicate(1000, fastBM(tree)) ) # Revell
   user  system elapsed 
  1.315   0.005   1.320 
>   # ape wins!!!

# Phylogenetically independent contrasts
trait <- rnorm(10)
names(trait) <- tree$tip.label
 
> system.time( replicate(10000, pic.motmot(trait, tree)$contr[,1])  ) # motmot
   user  system elapsed 
  3.062   0.007   3.070 
> system.time( replicate(10000, pic(trait, tree)) ) # ape
   user  system elapsed 
  2.846   0.007   2.853 
>   # ape wins!!!

# Phylogenetic signal, Blomberg's K
> system.time( replicate(100, Kcalc(trait, tree))  ) # picante
   user  system elapsed 
  1.311   0.005   1.316 
> system.time( replicate(100, phylosig(tree, trait, method = "K")) ) # Revell
   user  system elapsed 
  0.201   0.000   0.202 
>   # Liam Revell wins!!!

# Ancestral character state estimation
> system.time( replicate(100, ace(trait, tree)$ace) ) # ape
   user  system elapsed 
  4.988   0.018   5.007 
> system.time( replicate(100, getAncStates(trait, tree)) ) # geiger
   user  system elapsed 
  2.253   0.005   2.258 
>   # geiger wins!!!
```


It's hard to pick an overall winner because not all functions are available in all packages, but there are definitely some functions that are faster than others.
