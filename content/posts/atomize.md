---
name: atomize
layout: post
title: atomize - make new packages from other packages
date: 2016-04-07
sourceslug: _drafts/2016-04-07-atomize.Rmd
tags:
- R
- package
---



We (rOpenSci) just held our 3rd annual rOpenSci unconference (<https://unconf16.ropensci.org/>) in San Francisco. There were [a lot of ideas](https://github.com/ropensci/unconf16/issues), and lots of awesome projects from awesome people came out of the 2 day event.

One weird idea I had comes from looking at the Node world, where there are lots of tiny packages, instead of the often larger packages we have in the R world. One reason for tiny in Node is that of course you want a library to be tiny if running in the browser for faster load times (esp. on mobile).

So the idea is, what if we could separate all the functions in a package, or any particular function of your choice, into new packages, with all the internal functions and dependencies. And automatically as well, not manually.

So what are the use cases? I can't imagine this being used to create stable packages to disperse to the world on CRAN, but it could be really useful for development purposes, or for R users/analysts that want lighter weight dependencies (e.g., a package with just the one function needed from a larger package).

This approach of course has drawbacks. The new created package is now broken apart from the original - however, beause it's automated, you can just re-create it.

Another pain point would surely be with packages that have C/C++ code in them.

The package: `atomize`.

The package was made possible by the awesome [functionMap](https://github.com/MangoTheCat/functionMap) package by [Gábor Csárdi](https://github.com/gaborcsardi), and the more well-known `devtools`.

Expect bugs, the package has no tests. Sorry :(

## Installation


```r
devtools::install_github("ropenscilabs/atomize")
```


```r
library("atomize")
```

## usage

### atomize a fxn into separate package

You can select one function, or many. Here, I'm using another package I maintain, [rredlist](https://github.com/ropenscilabs/rredlist), a pkg to interact with the [IUCN Redlist API](https://apiv3.iucnredlist.org/api/v3/docs).

In this example, I want a new package called `foobar` with just the function `rl_citation()`. The function `atomize::atomizer()` takes the path for the package to extract from, then a path for the new package, then the function names.


```r
atomizer(path_ref = "../rredlist", path_new = "../foobar", funcs = "rl_citation")
```

This creates a new package in the `path_new` directory

### install

Now we need to install the new package, can do easily with `devtools::install()`


```r
devtools::install("../foobar")
```

### load

Then load the new package


```r
library("foobar")
```

### call function

Now call the function in the new package


```r
foobar::rl_citation()
#> [1] "IUCN 2015. IUCN Red List of Threatened Species. Version 2015-4 <www.iucnredlist.org>"
```

it's identical to the same function in the old package


```r
identical(rredlist::rl_citation(), foobar::rl_citation())
#> [1] TRUE
```
