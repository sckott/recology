---
name: limiting-dependencies
layout: post
title: "limiting dependencies in R package development"
date: 2018-10-02
author: Scott Chamberlain
sourceslug: _drafts/2018-10-02-limiting-dependencies.Rmd
tags:
- R
- open source
- code
---

The longer you do anything, the more preferences you may develop for that thing. One of these things is making R packages.  

One preference I've developed is in limiting package dependencies - or at least limiting to the least painful dependencies - in the packages I maintain. Ideally, if a base R solution can be done then do it that way. Everybody has base R packages if they are using R, so you can't fail there, at least on package installation. 

This is largely not about trusting individual packages ([cf. Jeff Leek's post](https://simplystatistics.org/posts/2015-11-06-how-i-decide-when-to-trust-an-r-package/)), but trust does play a role in deciding which packages to use (see _choosing among packages that do the same thing_ below). 

### why?

There's sure to be different opinions on this, but this is why I defend this hill:

* Why introduce more complexity if it can be avoided?
* It's one more thing out of your control. sure, in a perfect world package API's never break, at least after a certain version (v1 or so), but we can't depend on that. 
* Rolling your own solution for a problem (aka function/class/etc.) means its completely under your control
* There's a lot of great packages out there. However, in my opinion, many packages, including many of my own, are targeted at interactive users, not necessarily optimizing for other packages to use. So even though a package may do X really well, you can also do X on your own if it's simple enough.

### base R solutions

Some examples of base R solutions I like to use rather than using an off the shelf package:

* Remove `NULL` elements from a list. The function `function(l) Filter(Negate(is.null), l)` is stolen from `plyr::compact` originally. I include it as a utility function in many of my packages. It's simple base R stuff. Easy peasy.
* Extract string form another string based on a pattern. The function `function(x, y) regmatches(x, regexpr(y, x))` is what `stringr::str_extract` used to do before it moved to wrapping `stringi` functions. I like the pattern of the input first, and your pattern second, but don't want to import a huge dependency (`stringi`) if I know i just need a simple string extraction.
* Infix function `%||%`. originally saw this in `dplyr`, but now has left that package. the function: `function(x, y) if (is.null(x) || length(x) == 0) y else x`. It provides an elegant solution of a in place defined default value for when you can't be certain of the result. It's a very brief function, so no need to import a package just for this function. 
* Check that a parameter input is of the right type. R doesn't have type checking like some other languages. we can do it internally within the package though. There are packages to do this (check out [assertr][]), but instead of importing a package, I do something like the below:

```r
assert <- function (x, y) {
  if (!is.null(x)) {
    if (!inherits(x, y)) {
      stop(deparse(substitute(x)), " must be of class ",
          paste0(y, collapse = ", "), call. = FALSE)
    }
  }
}
```

It seems simple enough that I don't think importing a package is warranted. 

### choosing among packages that do the same thing

* I often need to combine many rows/lists into a data.frame in my packages. `dplyr::bind_rows` and `data.table::rbindlist` do this (there's probably others too). I've found that `data.table` is a slightly/somewhat easier dependency WRT installation, so I commonly use the below function for binding named lists into rows of a `data.frame`, with the optional conversion to a `tbl_df`.

```r
function(x) {
  tibble::as_tibble((x <- data.table::setDF(
    data.table::rbindlist(x, use.names = TRUE, fill = TRUE, idcol = "id"))
  ))
}
```

### other bits

* [Jim Hester](https://github.com/jimhester) did a presentation on the [glue][] package: [Glue Strings to Data with Glue](https://rawgit.com/jimhester/presentations/master/2018_07_13-Glue_strings_to_data_with_glue/2018_03_28-Glue_string_to_data_with_glue.html#/glue-is-for-packages) - and emphasized on one slide that `glue` is for packages because it has zero dependencies, is customizable, and fast - all things you want in a dependency in your own package.
* As I was wrapping up this post I found a few papers: 
    * Claes et al. [^1] found that "occurrence of errors in CRAN packages over a period of three months ... resulted mostly from updates in the packages’ dependencies ..."
    * In another paper Plakidas et al. [^2] extend the previous finding and say "... this potentially implies a heavy workload for package maintainers when they depend on a package that is frequently updated"
    * These statements mirror my hesitation to depend on other packages if in fact X task can be done internally
- Contributors: if you do write your own internal functions, or borrow from elsewhere, new contributors to your package may need to understand your internal function instead of an imported function from another package - but the plus side is if the function resides in your own package you can change it easily.
- Rapid development phase: often package development involves a rapid change phase where you want to get to a working prototype first, then refine later. During this development phase it makes sense to use off the shelf packages to get things working. Later, you may want to swap out packages or write your own R or compiled code to speed things up, or introduce different behavior, etc. 

### but

There are of course good reasons to just import the package that's best at doing X or Y and leave it at that. Sometimes I do that too. I don't always stay on my hill. 

And: Maybe I'm totally wrong here? Maybe I should be at all times using other packages to do X, Y, and Z? Despite the dozens of packages I maintain, I am fully aware I could be completely wrong here. 

thanks to [Maëlle Salmon](https://masalmon.eu/) for helpful advice on this post!

### references

[^1]: Claes, M., Mens, T., & Grosjean, P. (2014). On the maintainability of CRAN packages. 2014 Software Evolution Week - IEEE Conference on Software Maintenance, Reengineering, and Reverse Engineering (CSMR-WCRE). <https://doi.org/10.1109/csmr-wcre.2014.6747183>
[^2]: Plakidas, K., Schall, D., & Zdun, U. (2017). Evolution of the R software ecosystem: Metrics, relationships, and their impact on qualities. Journal of Systems and Software, 132, 119–146. <https://doi.org/10.1016/j.jss.2017.06.095>


[glue]: https://github.com/tidyverse/glue
[assertr]: https://github.com/ropensci/assertr
