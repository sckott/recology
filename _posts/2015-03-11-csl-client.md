---
name: csl-client
layout: post
title: csl - an R client for Citation Style Language data
date: 2015-03-11
author: Scott Chamberlain
sourceslug: _drafts/2015-03-11-csl-client.Rmd
tags:
- R
- metadata
---



CSL (Citation Style Language) is used quite widely now to specify citations in a standard fashion. `csl` is an R client for exploring CSL styles, and is inspired by the Ruby gem [csl](https://github.com/inukshuk/csl-ruby). For example, csl is given back in the PLOS Lagotto article level metric API (follow [http://alm.plos.org/api/v5/articles?ids=10.1371%252Fjournal.pone.0025110&info=detail&source_id=crossref](http://alm.plos.org/api/v5/articles?ids=10.1371%252Fjournal.pone.0025110&info=detail&source_id=crossref)).

Let me know if you have any feedback at the repo [https://github.com/ropensci/csl](https://github.com/ropensci/csl)

## Install


```r
install.packages("devtools")
devtools::install_github("ropensci/csl")
```


```r
library("csl")
```

## Load CSL style from a URL

You can load CSL styles from either a URL or a local file on your machine. Firt, from a URL. In this case from the Zotero style repository, for the American Journal or Political Science.


```r
jps <- style_load('http://www.zotero.org/styles/american-journal-of-political-science')
```

A list is returned, which you can index to various parts of the style specification.


```r
jps$info
#> $title
#> [1] "American Journal of Political Science"
#> 
#> $title_short
#> [1] "AJPS"
#> 
#> $id
#> [1] "http://www.zotero.org/styles/american-journal-of-political-science"
#> 
#> $author
...
```


```r
jps$title
#> [1] "American Journal of Political Science"
```


```r
jps$citation_format
#> [1] "author-date"
```


```r
jps$links_template
#> [1] "http://www.zotero.org/styles/american-political-science-association"
```


```r
jps$editor
#> $editor
#> $editor$variable
#> [1] "editor"
#> 
#> $editor$delimiter
#> [1] ", "
#> 
#> 
#> $label
#> $label$form
...
```


```r
jps$author
#> $author
#> $author$variable
#> [1] "author"
#> 
#> 
#> $label
#> $label$form
#> [1] "short"
#> 
#> $label$prefix
...
```

## Get raw XML

You can also get raw XML if you'd rather deal with that format.


```r
style_xml('http://www.zotero.org/styles/american-journal-of-political-science')
#> <?xml version="1.0" encoding="utf-8"?>
#> <style xmlns="http://purl.org/net/xbiblio/csl" class="in-text" version="1.0" demote-non-dropping-particle="sort-only" default-locale="en-US">
#>   <info>
#>     <title>American Journal of Political Science</title>
#>     <title-short>AJPS</title-short>
#>     <id>http://www.zotero.org/styles/american-journal-of-political-science</id>
#>     <link href="http://www.zotero.org/styles/american-journal-of-political-science" rel="self"/>
#>     <link href="http://www.zotero.org/styles/american-political-science-association" rel="template"/>
#>     <link href="http://www.ajps.org/AJPS%20Style%20Guide.pdf" rel="documentation"/>
#>     <author>
...
```

## Get styles

There is a GitHub repository of CSL styles at  [https://github.com/citation-style-language/styles-distribution](https://github.com/citation-style-language/styles-distribution). These don't come with the `csl` package, so you have to run `get_styles()` to get them on your machine. The default path is `Sys.getenv("HOME")/styles`, which for me is `/Users/sacmac/styles`. You can change where files are saved by using the `path` parameter.


```r
get_styles()
#> 
#> Done! Files put in /Users/sacmac/styles
```

After getting styles locally you can load them just as we did with `style_load()`, but from your machine. However, since the file is local, we can make this easier by allowing just the name of the style, like


```r
style_load("apa")
#> $info
#> $info$title
#> [1] "American Psychological Association 6th edition"
#> 
#> $info$title_short
#> [1] "APA"
#> 
#> $info$id
#> [1] "http://www.zotero.org/styles/apa"
#> 
...
```

If you are unsure if a style exists, you can use `style_exists()`


```r
style_exists("helloworld")
#> [1] FALSE
style_exists("acs-nano")
#> [1] TRUE
```

In addition, you can list the path for a single style, more than 1, or all styles with `styles()`


```r
styles("apa")
#> [1] "/Users/sacmac/styles/apa.csl"
```

All of them, truncated for blog brevity


```r
styles()
#> $independent
#>    [1] "academy-of-management-review"                                                         
#>    [2] "acm-sig-proceedings-long-author-list"                                                 
#>    [3] "acm-sig-proceedings"                                                                  
#>    [4] "acm-sigchi-proceedings-extended-abstract-format"                                      
#>    [5] "acm-sigchi-proceedings"                                                               
#>    [6] "acm-siggraph"                                                                         
#>    [7] "acs-nano"                                                                             
#>    [8] "acta-anaesthesiologica-scandinavica"                                                  
#>    [9] "acta-anaesthesiologica-taiwanica"                                                     
...
```

## Get locales

In addition to styles, there is a GitHub repo for locales at  [https://github.com/citation-style-language/locales](https://github.com/citation-style-language/locales). These also don't come with the `csl` package, so you have to run `get_locales()` to get them on your machine. Same goes here for paths as above for styles.


```r
get_locales()
#> 
#> Done! Files put in /Users/sacmac/locales
```

