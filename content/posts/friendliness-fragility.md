---
name: friendliness-fragility
layout: post
title: "Balancing user friendliness and code fragility"
date: 2018-07-27
author: Scott Chamberlain
sourceslug: _drafts/2018-07-27-friendliness-fragility.Rmd
tags:
- R
- open source
- code
---

I occasionally think about these various topics and ping back and forth between them, thinking I've got to make a package more user friendly, then back to thinking oh, I really should make this package easier to maintain, but what if that makes it less user friendly?  

I've wanted to get these thoughts written down for a while now, so here goes.


## User friendliness and code fragility

It's an unassailable good to make your code more user friendly. There's no point of making your package harder to use unless you really don't want people using it. 

Having said that, can a user friendly API come at the cost of code simplicity/maintainability?  

An example of user friendly code vs. not user friendly code is: Let's say you have a function `foo()`. There's a lot of things you can do to make the function user friendly, e.g., the function:

- errors/returns as early as possible
- has good documentation
- has well named parameters
- returns easy to understand output (see also good docs)
- handles complexity sufficiently so the user doesn't have to

This is all well and good, and most of the points above don't have to trade off with making code more complex/harder to maintain. However, the last point does I think. 

That is, handling complexity for the user is a good thing, BUT it makes for more code and probably more complex code. I'll highlight one particular example of this that I often deal with.

## Pagination

I make many packages that interact with web APIs, many of which have pagination. Pagination is just as it sounds: you don't get back all possible results for your query but instead you get back a certain number of results, then you have to request the next set, and so on. This helps lighten the load on the server delivering the data. And pagination is useful for users so you can get a sense of what the data looks like without have to wait for all the data, which in some cases can be quite large. 

Here's the question: Do you let the user handle pagination themselves with parameters to a function `foo()`? Or do you handle pagination internally within the function `foo()` with the user just stating how many results they want? The former scenario means that if the user wants 30 results they do: 

```r
foo(limit = 10, page = 1)
foo(limit = 10, page = 2)
foo(limit = 10, page = 3)
# ... and so on
```

While the latter means: 

```r
foo(limit = 30)
```

The second example is definitely easier for the user. There are still three HTTP requests being made, so probably the code runs no faster, but it's easier from a user standpoint. 

Here's how `foo()` might handle the paging internally:

```r
myGET <- function(x) {
  conn <- crul::HttpClient$new("https://someurl.com")
  res <- conn$get()
  txt <- res$parse(encoding = "UTF-8")
  jsonlite::fromJSON(txt)
}

foo <- function(limit = 10) {
  limit <- plyr::round_any(limit, 10)
  out <- list()
  for (i in seq(limit / 10)) out[[i]] <- myGET(limit, page = i)
  df <- dplyr::bind_rows(out)
  return(df)
}
```

> This is psuedocode, so you can't run this. 

In general I like to return data.frame's to users whenever possible as I think most users are most familiar with data.frame's. 

In the above example we need to do a few things when dealing with pagination:

* sort out how many requests to make. the above doesn't yet check that the `limit` value is a numeric or integer, and there's all kinds of edge cases depending on what number is given by the user with respect to pagination
* make each http request. I used a for loop, but anything similar can be used. one needs to decide how to handle errors if you're doing multiple requests. do you stop with an error if there's an error in one of the requests, or do you catch that and proceed? If you do catch it how do you let the user know, or do you just remove that error from results?
* combine results into a single output (data.frame most likely/ideally). we want the user to get the same results back whether they request one page of results or many, so we need to do the work to make sure the output looks the same. This step also introduces possible pain points in that any result record can have novel things in it that cause your result combining code to error. Do you do a minimal combination approach (e.g. let `jsonlite::fromJSON` convert to list/data.frame's where possible; but this means that there can be nested lists in data.frame's, which many users do not like); or do you roll your own bespoke data munging/combination code to make sure the output data.frame is really easy to use with no nested lists, etc.?  If you do the latter that will most likely be slower, but will be better output for the user. However, maybe most users want to combine the data on their own, so perhaps you should take up as little time as possible parsing/munging data so the user has to wait less time. 

The overall message here is that there's many points throughout this process that require decisions to be made with respect to how much complexity you'd like to take care of yourself as the developer vs. how much you'd like to leave up to the user. 

With complexity inside the function, there's more to maintain and more possible bugs, but it's easier for the user. 

With complexity exposed to the user, and simpler code inside the function, each user has to sort out how to work with the output and/or do the pagination (or whatever it is) themselves. But with less complexity inside the function, there will likely be fewer bugs.

> Note: i've been trying to make pagination with web APIs easier, check out the Paginator helper in the crul package <https://github.com/ropensci/crul/blob/master/R/paginator.R>

## So what?

Perhaps others have figured this out and I'm the only one struggling with this? I'm sure I'll continue to go back and forth on this pendulum. Would love to know how others think about this. 

