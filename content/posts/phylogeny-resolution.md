--- 
name: phylogeny-resolution
layout: post
title: Function for phylogeny resolution
author: Scott Chamberlain
date: 2012-01-13
sourceslug: _posts/2012-01-12-phylogeny-resolution.md
tags: 
- R
- ape
- phylogenetics
---

UPDATE:  Yeah, so the treeresstats function had a problem in one of the calculations.  I fixed that and added some more calulcations to the function. 

I couldn't find any functions to calculate number of polytomies, and related metrics. 

Here's a simple function that gives four metrics on a phylo tree object:

```r
# calculate tree resolution stats
treeresstats <- function(x) {
  require(phangorn) # load the phangorn package
  todo <- ( 1+Ntip(x)) : (Ntip(x) + Nnode(x) )
  trsize_tips <- Ntip(x)
  trsize_nodes <- Nnode(x)
  polytomyvec <- sapply(todo, function(y) length(Children(x, y)))
  numpolys <- length(polytomyvec[polytomyvec > 2])
  numpolysbytrsize_tips <- numpolys/trsize_tips
  numpolysbytrsize_nodes <- numpolys/trsize_nodes
  proptipsdescpoly <- sum(polytomyvec[polytomyvec > 2])/trsize_tips
  propnodesdich <- length(polytomyvec[polytomyvec == 2])/trsize_nodes
  list(trsize_tips = trsize_tips, trsize_nodes = trsize_nodes, 
       numpolys = numpolys, numpolysbytrsize_tips = numpolysbytrsize_tips,
       numpolysbytrsize_nodes = numpolysbytrsize_nodes,
       proptipsdescpoly = proptipsdescpoly, propnodesdich = propnodesdich)
}

# Single tree example
tree <- read.tree(text="((((((artemisia_species:44,lactuca_species:44,senecio_species:44)6:46,campanula_species:90)5:17.75,((asclepias_species:71,galium_species:71)8:18.375,plantago_species:89.375)7:18.375)4:17.75,((cerastium_species:41.833332,silene_species:41.833332)10:41.833332,chenopodium_species:83.666664)9:41.833336)3:17.75,((geum_species:47,potentilla_species:47)12:48.125,lepidium_species:95.125)11:48.125)2:17.75,(bromus_species:12,elymus_species:12)13:149)1;")

dat <- treeresstats(tree)

dat


# Many trees example
maketrees <- function(numtrees) {
  require(ape); require(plyr)
  trees <- rmtree(numtrees, 20)
  llply(trees, di2multi, tol = 0.5)
}
trees <- maketrees(30)
dat <- ldply(trees, function(x) data.frame(treeresstats(x)))
dat
```

Here's output from the gist above:

```r
$trsize_tips
[1] 15

$trsize_nodes
[1] 13

$numpolys
[1] 1

$numpolysbytrsize_tips
[1] 0.06666667

$numpolysbytrsize_nodes
[1] 0.07692308

$proptipsdescpoly
[1] 0.2

$propnodesdich
[1] 0.9230769
```

And an example with many trees:

{{< table >}}
| trsize_tips |   trsize_nodes |   numpolys |   numpolysbytrsize_tips |   numpolysbytrsize_nodes |   proptipsdescpoly |   propnodesdich |
| ------------- | -------------- | ---------- | ----------------------- | ------------------------ | ------------------ | --------------- |
|  20            | 13            |  4          | 0.20                   |  0.31                    |  0.7                | 0.69|
|   20           |  7             |  3         |  0.15                   |  0.43                    |  0.9               |  0.57|
|   20           |  11             | 6         |  0.30                    | 0.55                    |  1.0               |  0.45|
|   20           |  13             | 4         |  0.20                    | 0.31                    |  0.7               |  0.69|
|   20           |  9              | 5         |  0.25                    | 0.56                    |  1.0               |  0.44 |

{{< /table >}}
