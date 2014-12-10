---
name: museum-aamsf
layout: post
title: Museum metadata - the Asian Art Museum of San Francisco
date: 2014-12-10
author: Scott Chamberlain
tags:
- R
- history
- scraping
---



I was in San Francisco last week for an altmetrics conference at PLOS. While there, I visited the [Asian Art Museum](http://www.asianart.org/), just the [Roads of Arabia exhibition](http://www.asianart.org/exhibitions_index/roads-of-arabia).

It was a great exhibit. While I was looking at the pieces, I read many labels, and thought, "hey, what if someone wants this metadata"? 

Since we have an R package in development for scraping museum metadata (called [musemeta](https://github.com/ropensci/musemeta)), I just started some scraping code for this museum. Unfortunately, I don't think the pieces from the Roads of Arabia exhibit are on their site, so no metadata to get. But they do have their main collection searchable online at [http://www.asianart.org/collections/collection](http://www.asianart.org/collections/collection). Examples follow. 

## Installation


```r
install.packages("devtools")
devtools::install_github("ropensci/musemeta")
```


```r
library("musemeta")
```

## Get metadata for a single object

You have to get the ID for the piece from their website, e.g., `11462` from the url `http://searchcollection.asianart.org/view/objects/asitem/nid/11462`. Once you have an ID you can pass it in ot the `aam()` function.


```r
(out <- aam(11462))
#> <AAM metadata> Molded plaque (tsha tsha)
#>   Object id: 1992.96
#>   Object name: Votive plaque
#>   Date: approx. 1992
#>   Artist: 
#>   Medium: Plaster mixed with resin and pigment
#>   Credit line: Gift of Robert Tevis
#>   On display?: no
#>   Collection: Decorative Arts
#>   Department: Himalayan Art
#>   Dimensions: 
#>   Label: Molded plaques (tsha tshas) are small sacred images, flat or
#>           three-dimensional, shaped out of clay in metal molds. The
#>           images are usually unbaked, and sometimes seeds, paper, or
#>           human ashes were mixed with the clay. Making tsha tshas is
#>           a meritorious act, and monasteries give them away to
#>           pilgrims. Some Tibetans carry tsha tshas inside the amulet
#>           boxes they wear or stuff them into larger images as part of
#>           the consecration of those images. In Bhutan tsha tshas are
#>           found in mani walls (a wall of stones carved with prayers)
#>           or piled up in caves.The practice of making such plaques
#>           began in India, and from there it spread to other countries
#>           in Asia with the introduction of Buddhism. Authentic tsha
#>           tshas are cast from clay. Modern examples , such as those
#>           made for the tourist trade in Tibet, are made of plaster
#>           and cast from ancient (1100-1200) molds and hand colored to
#>           give them the appearance of age.
```

The output is printed for clarity, but you can dig into each element, like 


```r
out$label
#> [1] "Molded plaques (tsha tshas) are small sacred images, flat or three-dimensional, shaped out of clay in metal molds. The images are usually unbaked, and sometimes seeds, paper, or human ashes were mixed with the clay. Making tsha tshas is a meritorious act, and monasteries give them away to pilgrims. Some Tibetans carry tsha tshas inside the amulet boxes they wear or stuff them into larger images as part of the consecration of those images. In Bhutan tsha tshas are found in mani walls (a wall of stones carved with prayers) or piled up in caves.The practice of making such plaques began in India, and from there it spread to other countries in Asia with the introduction of Buddhism. Authentic tsha tshas are cast from clay. Modern examples , such as those made for the tourist trade in Tibet, are made of plaster and cast from ancient (1100-1200) molds and hand colored to give them the appearance of age."
```

## Get metadata for many objects

The `aam()` function is not vectorized, but you can easily get data for many IDs via `lapply` type functions, etc. 


```r
lapply(c(17150,17140,17144), aam)
#> [[1]]
#> <AAM metadata> Boys sumo wrestling
#>   Object id: 2005.100.35
#>   Object name: Woodblock print
#>   Date: approx. 1769
#>   Artist: Suzuki HarunobuJapanese, 1724 - 1770
#>   Medium: Ink and colors on paper
#>   Credit line: Gift of the Grabhorn Ukiyo-e Collection
#>   On display?: no
#>   Collection: Prints And Drawings
#>   Department: Japanese Art
#>   Dimensions: H. 12 5/8 in x W. 5 3/4 in, H. 32.1 cm x W. 14.6 cm
#>   Label: 40 é木Ø春t信M 相'撲oVびÑSuzuki Harunobu, 1725?1770Boys sumo wrestling ( Sumō
#>           ?)c. 1769Woodblock print ( nishiki-e) Hosoban
#> 
#> [[2]]
#> <AAM metadata> Autumn Moon of Matsukaze
#>   Object id: 2005.100.25
#>   Object name: Woodblock print
#>   Date: 1768-1769
#>   Artist: Suzuki HarunobuJapanese, 1724 - 1770
#>   Medium: Ink and colors on paper
#>   Credit line: Gift of the Grabhorn Ukiyo-e Collection
#>   On display?: no
#>   Collection: Prints And Drawings
#>   Department: Japanese Art
#>   Dimensions: H. 12 1/2 in x W. 5 3/4 in, H. 31.7 cm x W. 14.6 cm
#>   Label: 30 é木Ø春t信M 『w流¬æ八"ª景i』x 「u松¼のÌ秋H月」vSuzuki Harunobu, 1725?1770"Autumn Moon of
#>           Matsukaze" (Matsukaze no shū ?)From Fashionable Eight Views
#>           of Noh Chants (Fū ?ū ?17681769Woodblock print
#>           (nishiki-e)Hosoban
#> 
#> [[3]]
#> <AAM metadata> Hunting for fireflies
#>   Object id: 2005.100.29
#>   Object name: Woodblock print
#>   Date: 1767-1768
#>   Artist: Suzuki HarunobuJapanese, 1724 - 1770
#>   Medium: Ink and colors on paper
#>   Credit line: Gift of the Grabhorn Ukiyo-e Collection
#>   On display?: no
#>   Collection: Prints And Drawings
#>   Department: Japanese Art
#>   Dimensions: H. 10 1/2 in x W. 8 in, H. 26.7 cm x W. 20.3 cm
#>   Label: 34 é木Ø春t信M u狩ëりèSuzuki Harunobu, 1725?1770Hunting for
#>           fireflies17671768Woodblock print ( nishiki-e) Chū ?
```

## No search, boo

Note that there is no search functionality yet for this source. Maybe someone can add that via pull requests :)

## Like the others

The others sources in `musemeta` mostly work the same way as the above.
