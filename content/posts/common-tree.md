---
name: common-tree
layout: post
title: Getting a simple tree via NCBI
date: 2013-02-14
author: Scott Chamberlain
sourceslug: _drafts/2013-02-14-common-tree.Rmd
tags: 
- R
- phylogenetic
---

I was just at the [Phylotastic hackathon](http://www.evoio.org/wiki/Phylotastic) in Tucson, AZ at the [iPlant](http://www.iplantcollaborative.org/) facilities at the UofA.

A problem that needs to be solved is getting the incrasingly vast phylogenetic information to folks not comfortable building their own phylogenies. [Phylomatic](http://phylodiversity.net/phylomatic/) has made this super easy for people that want plant phylogenies (at least 250 or so papers have used and cited Phylomatic in their papers) - however, there are few options for those that want phylogenies for other taxonomic groups. 

One cool tool that was brought up was the [Common Tree](http://www.ncbi.nlm.nih.gov/Taxonomy/CommonTree/wwwcmt.cgi) service provided by NCBI. [Here's](http://www.ncbi.nlm.nih.gov/Taxonomy/CommonTree/cmthelp.html) some help on the service. Unlike Phylomatic, Common Tree is purely based off of taxonomic relationships (A and B are both in the C family, so are sisters), not an actual phylogeny as Phylomatic is based on. 

But how do you use Common Tree?

### Get a species list
Grab the taxon list from my github account [here](https://raw.github.com/sckott/sckott.github.com/master/public/img/species.txt) 

### Go to the site
Go to the Common Tree site [here](http://www.ncbi.nlm.nih.gov/Taxonomy/CommonTree/wwwcmt.cgi)

### Choose file
Hit the "choose file" button, then select the `species.txt` file you downloaded in the first step. 

### Add the species list to make the tree
Then hit "add from file", and you got a "tree"

![image](https://raw.github.com/sckott/sckott.github.com/master/public/img/ncbi.png)

## Download
You can download the tree in a variety of formats, including a .phy file

![image](https://raw.github.com/sckott/sckott.github.com/master/public/img/ncbi2.png)

## Plot the tree on your machine
Make a tree, in R for me


```r
# install.packages('ape') # install if you don't have ape
library(ape)

# Read the tree in. YOu get the tree back with alot of newlines (\n) -
# can easily take these out with a good text editor.
tree <- read.tree(text = "(Lampetra:4,((((((Umbra:4,((Lota:4,Microgadus:4)Gadiformes:4,((Culaea:4,Apeltes:4,Pungitius:4,Gasterosteus:4)Gasterosteidae:4,(Morone:4,(Ambloplites:4,Micropterus:4,Lepomis:4)Centrarchidae:4,(Sander:4,Perca:4)Percidae:4)Percoidei:4,Cottus:4)Percomorpha:4)Holacanthopterygii:4)Neognathi:4,(((Prosopium:4,Coregonus:4)Coregoninae:4,(Salvelinus:4,Salmo:4,Oncorhynchus:4)Salmoninae:4)Salmonidae:4,Osmerus:4)Protacanthopterygii:4)Euteleostei:4,(Alosa:4,(Ameiurus:4,(Catostomus:4,(Semotilus:4,Rhinichthys:4,Margariscus:4,Couesius:4,Pimephales:4,Luxilus:4,Notemigonus:4,Notropis:4,Carassius:4)Cyprinidae:4)Cypriniformes:4)Otophysi:4)Otocephala:4)Clupeocephala:4,Anguilla:4)Elopocephala:4,Acipenser:4)Actinopteri:4,Scyliorhinus:4)Gnathostomata:4)Vertebrata:4;")

# stretch the branches so tips line up
tree2 <- compute.brlen(tree, method = "Grafen")

# Plot the tree
plot(tree2, no.margin = TRUE, cex = 0.7)
```


### w00p, there it is...

![image4](https://raw.github.com/sckott/sckott.github.com/master/public/img/ncbi_tree.png)

And the answer is _NO_ to the question: Is there an API for Common Tree?

---

Get the .Rmd file used to create this post [at my github account](https://github.com/sckott/sckott.github.com/tree/master/_drafts/2013-02-14-common-tree.Rmd) - or [.md file](https://github.com/sckott/sckott.github.com/tree/master/_posts/2013-02-14-common-tree.md).

Written in [Markdown](http://daringfireball.net/projects/markdown/), with help from [knitr](http://yihui.name/knitr/).
