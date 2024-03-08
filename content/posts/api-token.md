---
name: api-token
layout: post
title: Waiting for an API request to complete
date: 2013-01-26
author: Scott Chamberlain
sourceslug: _drafts/2013-01-26-api-token.Rmd
tags: 
- R
- API
- ropensci
---

### Dealing with API tokens in R

In [my previous post](/posts/2013-01-25-tnrs-use-case/) I showed an example of calling the Phylotastic taxonomic name resolution API `Taxosaurus` [here](https://api.phylotastic.org/tnrs).  When you query their API they give you a token which you use later to retrieve the result (see examples on their page above). However, you don't know when the query will be done, so how do we know when to send the query to rerieve the data?

As the time this takes depends on how big the query is and other things, we don't know when we can get the result. I struggled with this for a bit, but then settled on using a while loop. 

So what does this look like?  Basically we just keep sending the request for data until we get it.


```r
iter <- 0  # make an iterator so each time we call
output <- list()  # make an empty list to put data into
timeout <- "wait"
while (timeout == "wait") {
    iter <- iter + 1  # increase the iterator each time
    temp <- fromJSON(getURL(retrieve))  # send the request and parse the JSON
    if (grepl("is still being processed", temp["message"]) == TRUE) {
        timeout <- "wait"
    } else {
        output[[iter]] <- temp  # put result from query in the list
        timeout <- "done"  # we got the result so timeout is now done, making the while loop stop
    }
}
```


---

Get the .Rmd file used to create this post [at my github account](https://github.com/sckott/sckott.github.com/tree/master/_drafts/2013-01-26-api-token.Rmd) - or [.md file](https://github.com/sckott/sckott.github.com/tree/master/_posts/2013-01-26-api-token.md).

Written in [Markdown](http://daringfireball.net/projects/markdown/), with help from [knitr](http://yihui.name/knitr/).
