---
name: condition-control
layout: post
title: "condition control: I just want that message once"
date: 2018-12-06
author: Scott Chamberlain
sourceslug: _drafts/2018-12-06-condition-control.Rmd
tags:
- R
- open source
- code
- conditions
---



I'm sure there's already a way to do this, but here goes. OR maybe this is an 
anti-pattern. Either way, this is me, asking the stupid question.

I ran into this a few hours ago:


```r
Sys.unsetenv("ENTREZ_KEY")
library(brranching)
mynames <- c("Poa annua", "Salix goodingii", "Helianthus annuus")
phylomatic_names(taxa = mynames, format='rsubmit')
```

```r
No ENTREZ API key provided
 Get one via taxize::use_entrez()
 See https://ncbiinsights.ncbi.nlm.nih.gov/2017/11/02/new-api-keys-for-the-e-utilities/

No ENTREZ API key provided
 Get one via taxize::use_entrez()
 See https://ncbiinsights.ncbi.nlm.nih.gov/2017/11/02/new-api-keys-for-the-e-utilities/

No ENTREZ API key provided
 Get one via taxize::use_entrez()
 See https://ncbiinsights.ncbi.nlm.nih.gov/2017/11/02/new-api-keys-for-the-e-utilities/


[1] "poaceae%2Fpoa%2Fpoa_annua"                   "salicaceae%2Fsalix%2Fsalix_goodingii"        "asteraceae%2Fhelianthus%2Fhelianthus_annuus"
```

The [brranching][] package uses the [taxize][] package internally, calling it's function 
`taxize::tax_name()`. The `taxize::tax_name()` function throws useful messages to the user
if their NCBI Entrez API key is not found, and gives them instructions on how to find it. 

However, the user does not have to get an API key. If they don't they then get subjected
to lots of repeats of the same message. 

I wondered if there's anything that could be done about this. That is, if the same 
message is going to be thrown that was already thrown within a function call, just skip 
additional messages that are the same.  

There is of course `suppressMessages()` for messages, but in package development if you
do want a user to see a message, you don't want to suppress messages. `suppressMessages`
is too blunt of an instrument for this use case. 

## the code

`with_mssgs()` captures values and messages, suppressing the message


```r
with_mssgs <- function(expr) {
  my_mssgs <- NULL
  w_handler <- function(w) {
    my_mssgs <<- c(my_mssgs, list(w))
    invokeRestart("muffleMessage")
  }
  val <- withCallingHandlers(expr, message = w_handler)
  list(value = val, messages = my_mssgs)
}
```

`MessageKeeper` is a little [R6][] class to handle messages, matching, and 
simple checks to see if messages have been used or not.


```r
library(R6)
MessageKeeper <- R6::R6Class("MessageKeeper",
  public = list(
    bucket = NULL,
    print = function(x, ...) {
      cat('MessageKeeper', sep = "\n")
      cat(paste0(' messages: ', length(self$bucket)))
      if (length(self$bucket) > 0) {
        cat("\n")
        for (i in self$bucket) {
          cat(paste0("  ", substring(i, 1, 50)))
        }
      }
    },
    add = function(x) {
      self$bucket <- c(self$bucket, list(x))
      invisible(self)
    },
    remove = function() {
      if (self$length() == 0) return(NULL)
      head <- self$bucket[[1]]
      self$bucket <- self$bucket[-1]
      head
    },
    purge = function() {
      self$bucket <- NULL
    },
    thrown_already = function(x) {
      x %in% self$bucket
    },
    not_thrown_yet = function(x) {
      !self$thrown_already(x)
    }
  )
)
```

MessageKeeper examples


```r
mssger <- MessageKeeper$new()
mssger
#> MessageKeeper
#>  messages: 0
mssger$add("one")
mssger$add("two")
mssger
#> MessageKeeper
#>  messages: 2
#>   one  two
mssger$thrown_already("one")
#> [1] TRUE
mssger$thrown_already("bears")
#> [1] FALSE
mssger$not_thrown_yet("bears")
#> [1] TRUE
mssger$purge()
```

`handle_mssgs()` is a function you wrap your target function in to 
handle the messages


```r
handle_mssgs <- function(expr) {
  res <- with_mssgs(expr)
  if (!is.null(res$messages)) {
    # if not thrown yet, add to bucket and throw it
    if (my_mssger$not_thrown_yet(res$messages[[1]]$message)) {
      my_mssger$add(res$messages[[1]]$message)
      message(res$messages[[1]]$message)
    }
  }
  return(res$value)
}
```

Set up the message keeper


```r
my_mssger <- MessageKeeper$new()
```

`squared()` squares a numeric value and returns it, throwing a message if 
it's greater than 20


```r
squared <- function(x) {
  stopifnot(is.numeric(x))
  y <- x^2
  if (y > 20) message("woops, > than 20! check your numbers")
  return(y)
}
```

`foo()` runs any vector of numbers through `squared()` using `vapply()`



```r
foo <- function(x) {
  vapply(x, function(z) squared(z), numeric(1))
}
```

`bar()` does the same, but uses our MessageKeeper thingy


```r
bar <- function(x) {
  # tear down on exit
  on.exit(my_mssger$purge())
  vapply(x, function(z) handle_mssgs(squared(z)), numeric(1))
}
```

`foo()` annoyingly throws a message for every instance possible


```r
foo(1:20)
#> woops, > than 20! check your numbers
#> woops, > than 20! check your numbers
#> woops, > than 20! check your numbers
#> woops, > than 20! check your numbers
#> woops, > than 20! check your numbers
#> woops, > than 20! check your numbers
#> woops, > than 20! check your numbers
#> woops, > than 20! check your numbers
#> woops, > than 20! check your numbers
#> woops, > than 20! check your numbers
#> woops, > than 20! check your numbers
#> woops, > than 20! check your numbers
#> woops, > than 20! check your numbers
#> woops, > than 20! check your numbers
#> woops, > than 20! check your numbers
#> woops, > than 20! check your numbers
#>  [1]   1   4   9  16  25  36  49  64  81 100 121 144 169 196 225 256 289
#> [18] 324 361 400
```

while `bar()` only throws the message once


```r
bar(1:20)
#> woops, > than 20! check your numbers
#>  [1]   1   4   9  16  25  36  49  64  81 100 121 144 169 196 225 256 289
#> [18] 324 361 400
```


[R6]: https://cran.rstudio.com/web/packages/R6/
[brranching]: https://github.com/ropensci/brranching/
[taxize]: https://github.com/ropensci/taxize/
