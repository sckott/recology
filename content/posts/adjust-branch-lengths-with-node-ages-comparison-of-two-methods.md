---
name: adjust-branch-lengths-with-node-ages-comparison-of-two-methods
layout: post
title: "Adjust branch lengths with node ages: comparison of two methods"
author: Scott Chamberlain
date: 2011-04-10 13:02:00.003000 -05:00
sourceslug: _posts/2011-04-10-adjust-branch-lengths-with-node-ages-comparison-of-two-methods.md
tags:
- phylocom
- Methods
- Evolution
- Phylogenetics
- R
---

Here is an approach for comparing two methods of adjusting branch lengths on trees: bladj in the program Phylocom and a fxn written by Gene Hunt at the Smithsonian.

Get the code and example files (tree and node ages) at <https://gist.github.com/938313>

Get phylocom at <http://www.phylodiversity.net/phylocom/>

Gene Hunt's method has many options you can mess with, including setting tip ages (not available in bladj), setting node ages, and minimum branch length imposed. You will notice that Gene's method may be not the appropriate if you only have extant taxa.

The function AdjBrLens uses as input a newick tree file and a text file of node ages, and uses functions you can simply run by "source" the R file bladjing_twomethods.R file from [here](https://gist.github.com/938313).

Note that blad does not like numbers for node names, so you have to put a character in front of a number of just character names for nodes.

```r
# This is where the work happens... 
# Directory below needs to have at least three items:
#  1. phylocom executable for windows or mac
#  2. tree newick file
#  3. node ages file as required by phylocom, see their manual
# Output: trees_out is a list of three trees, the original, bladj, and Gene Hunt's method
# Also, within the function all three trees are written to file as PDFs
setwd("/Mac/R_stuff/Blog_etc/Bladjing") # set working directory
source("bladjing_twomethods.R") # run functions from source file
trees_out <- AdjBrLens("tree.txt", "nodeages.txt")
 
# plot trees of three methods together, 
# with nodes with age estimates labeled
jpeg("threeplots.jpeg", quality=100)
layout(matrix(1:3, 1, 3))
plot(trees_out[[1]])
nodelabels(trees_out[[1]]$node.label, cex = 0.6)
title("original tree")
plot(trees_out[[2]])
nodelabels(trees_out[[2]]$node.label, cex = 0.6)
title("bladj method")
plot(trees_out[[3]])
nodelabels(trees_out[[3]]$node.label, cex = 0.6)
title("gene hunt method, scalePhylo")
dev.off()
```

![](https://2.bp.blogspot.com/-tLK1y12TYlI/TaHwayCs3GI/AAAAAAAAEbU/rPsFYqSEDuI/s1600/threeplots.jpeg)

