---
name: base-r-and-limiting-dependencies
layout: post
title: "Base R and limiting dependencies in R package development"
date: 2018-10-01
author: Scott Chamberlain
sourceslug: _drafts/2018-10-01-base-r-and-limiting-dependencies.Rmd
tags:
- R
- open source
- code
---

The longer you do anything, the more preferences you may develop for that thing. One of these things is making R packages.  

One preference I've developed is in limiting package dependencies - or at least limiting to the least painful dependencies - in the packages I maintain. Ideally, if a base R solution can be done then do it that way. Everybody has base R packages if they are using R, so you can't fail there, at least on package installation. 

### why?

There's sure to be different opinions on this, but this is why I defend this hill:

* why introduce more complexity if it can be avoided? even if a package is easy to install, there's no compiled code, etc. 
* it's one more thing out of your control. sure, in a perfect world package API's never break, at least after a certain version (v1 or so), but we can't depend on that. 
* rolling your own solution for a problem (aka function/class/etc.) means its completely under your control
* there's a lot of great packages out there. however, in my opinion, many packages, including many of my own, are targeted at interactive users, not neccesarily optimizing for other packages to use. so even though a package may do X really well, you can also do X on your own if it's simple enough.

### base R solutions

Some examples of base R solutions I like to use rather than using an off the shelf package:

* remove `NULL` elements from a list. The function `function(l) Filter(Negate(is.null), l)` is stolen from `plyr::compact` originally. I include it as a utility function in many of my packages. It's simple base R stuff. easy peasy.
* extract string form another string based on a pattern. The function `function(x, y) regmatches(x, regexpr(y, x))` is what `stringr::str_extract` used to do before it moved to wrapping `stringi` functions. I like the pattern of the input first, and your pattern second, but don't want to import a huge dependency (`stringi`) if I know i just need a simple string extraction.
* infix function `%||%`. originally saw this in `dplyr`, but now has left that package. the function: `function(x, y) if (is.null(x) || length(x) == 0) y else x`. it provides an elegant solution of a in place defined default value for when you can't be certain of the result. it's a very brief function, so no need to import a package just for this function. 
* trim whitespace off ends of a string. the function `function(str) gsub("^\\s+|\\s+$", "", str)` is probably not the most comprehensive, but seems to work for me.
* check that a parameter input is of the right type. R doesn't have type checking like some other languages. we can do it internally within the package though. There are packages to do this, but instead of importing a package, I do something like the below:

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

### easier packages

Some examples of solutions with easier to install packages:

* combine many rows/lists into a data.frame. `dplyr::bind_rows` and `data.table::rbindlist` do this (there's probably others too). I've found that `data.table` is a slightly/somewhat easier dependency wrt installation, so I commonly use the below function for binding named lists into rows of a `data.frame`, with the optional conversion to a `tbl_df`.

```
function(x) {
  tibble::as_tibble((x <- data.table::setDF(
    data.table::rbindlist(x, use.names = TRUE, fill = TRUE, idcol = "id"))
  ))
}
```

* another example ...

### but

There are of course great reasons to just import the package that's best at doing X or Y and leave it at that. Sometimes I do that too. I don't always stay on my hill. 
