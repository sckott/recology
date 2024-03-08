---
name: fylopic
layout: post
title: Fylopic, an R wrapper to Phylopic
date: 2013-06-01
author: Scott Chamberlain
sourceslug: _drafts/2013-06-01-fylopic.Rmd
tags: 
- R
- phylogenetic
- API
---

## What is PhyloPic?

PhyloPic is an awesome new service - I'll let the creator, [Mike Keesey](http://tmkeesey.net/), explain what it is (paraphrasing here): 

> PhyloPic stores silhouette images of organisms, and each image is associated with taxonomic names, and stores the taxonomy of all taxa, allowing searching by taxonomic names. Anyone can submit silhouettes to PhyloPic. 

What is a silhouette?  It's like this:

![A silhouette](http://phylopic.org/assets/images/submissions/bedd622a-4de2-4067-8c70-4aa44326d229.128.png)

*by Gareth Monger*


What makes PhyloPic not just awesome, but super awesome? All or most images are licensed under [Creative Commons licenses](http://creativecommons.org/). This means you can use the silhouettes without having to ask or pay - just attribute. 


## What is fylopic?

The idea behind Fylopic is to create modular bits and pieces (i.e., functions) to allow you to add silhouettes to not only ggplot2 plots, but base plots as well. That is, you can simply load fylopic in your R session, and add some silhouettes to your phylogeny, or your barchart, etc. - that is, `fylopic` is meant to be a helper in your workflow to add in silhouettes to visualizations. 

Some people prefer base plots while others prefer ggplot2 plots (me!), so it would be nice to have both options. Phylogenies at the moment render faster in base plots. I don't yet have implementations for base plots, but will come soon, or you can send a pull request to add it. 

One interesting use case could be to be able to get a set of silhouettes, then get a phylogeny for taxa associatd with the silhouettess using the NCBI taxonomy, but it's not easily available yet (though I may be able to use [Ben Morris' phylocommons](https://github.com/bendmorris/phylocommons) soon. This isn't doable yet, so in the example below the function `make_phylo` creates a phylogeny using `ape::rcoal`.

You could also do the reverse -> you have a phylogeny and then you could search Phylopic for silhouettes. 


## Info

Check out the Phylopic website [here](http://phylopic.org/), and Phylopic API developer documentation [here](http://phylopic.org/api/). 

Also check out Ben Morris' Python wrapper to Phylopic [here](https://github.com/bendmorris/python-phylopic). 


## What can you do with fylopic?


#### Install fylopic

```r
install.packages("devtools")
library(devtools)
install_github("fylopic", "sckott")
```



```r
library(fylopic, quietly = TRUE)
```



#### Plot a phylogeny with silhouettes at the tips

Here, I search for names based on keyword *Homo sapiens* - which returns many matche codes. With those results we search for any silhouettes associated with those codes. Then we download images. Finally, make a phylogeny with the silhouettes at the tips. Note that in this eample the phylogeny is just a random coalescent tree made using `ape::rcoal` - obviously, in the real world you'd want to do something more useful. 


```r
## search on Homo sapiens
searchres <- search_text(text = "Homo sapiens", options = "names")

### which returns UUIDs
searchres[1:3]
```



```r
[1] "74aea16b-666b-497a-b2cb-72201ad75a8e"
[2] "1ee65cf3-53db-4a52-9960-a9f7093d845d"
[3] "cc9ad8ee-3a82-4add-8d50-bc78f4ff6956"
```



```r

## search for images based on the UUIds
output <- search_images(uuid = searchres, options = c("pngFiles", "credit", 
    "canonicalName"))

### we got eight matches
output
```



```r
$`15444b9c-f17f-4d6e-89b5-5990096bcfb0`
$`15444b9c-f17f-4d6e-89b5-5990096bcfb0`$supertaxa
[1] "e547cd01-7dd1-495b-8239-52cf9971a609"
[2] "bd88f674-6976-4cb2-a46e-e6a12a8ba463"


$`fedf0e5f-f20a-442c-accf-eb84a3af8c6b`
$`fedf0e5f-f20a-442c-accf-eb84a3af8c6b`$supertaxa
[1] "e547cd01-7dd1-495b-8239-52cf9971a609"
[2] "bd88f674-6976-4cb2-a46e-e6a12a8ba463"


$`a88d3a4c-44d3-409e-87b6-516bd188c709`
$`a88d3a4c-44d3-409e-87b6-516bd188c709`$supertaxa
[1] "e547cd01-7dd1-495b-8239-52cf9971a609"
[2] "bd88f674-6976-4cb2-a46e-e6a12a8ba463"


$`d88164ec-3152-444b-b41c-4757a344a764`
$`d88164ec-3152-444b-b41c-4757a344a764`$supertaxa
[1] "9c6af553-390c-4bdd-baeb-6992cbc540b1"


$`da5eaeb7-1ed2-4b2e-ad4a-49993881d706`
$`da5eaeb7-1ed2-4b2e-ad4a-49993881d706`$supertaxa
[1] "9c6af553-390c-4bdd-baeb-6992cbc540b1"
```



```r

## download images
myobjs <- get_image(uuids = output, size = "128")

## make the phylogeny
make_phylo(pngobj = myobjs)
```

![center](/2013-06-01-fylopic/unnamed-chunk-1.png) 



#### Plot a silhouette behind a plot

Notice in the below example that you can use normal `ggplot2` syntax, and simply add another layer (`add_phylopic` from `fylopic`) to the plot.


```r
library(ggplot2)
img <- get_image("27356f15-3cf8-47e8-ab41-71c6260b2724", size = "512")[[1]]
qplot(x = Sepal.Length, y = Sepal.Width, data = iris, geom = "point") + add_phylopic(img)
```

![center](/2013-06-01-fylopic/unnamed-chunk-2.png) 



## What's next?

This is a side project, so if anyone has interest in helping please do contribute code, report bugs, request features, etc. 
