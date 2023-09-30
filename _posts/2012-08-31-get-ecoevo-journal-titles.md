---
name: get-ecoevo-journal-titles
layout: post
title: Getting ecology and evolution journal titles from R
date: 2012-08-31
author: Scott Chamberlain
sourceslug: _drafts/2012-08-31-get-ecoevo-journal-titles.Rmd
tags: 
- R
- altmetrics
- ecology
- Evolution
- DOI
---


*********

So I want to mine some #altmetrics data for some research I'm thinking about doing.  The steps would be: 

+ Get journal titles for ecology and evolution journals. 
+ Get DOI's for all papers in all the above journal titles. 
+ Get altmetrics data on each DOI. 
+ Do some fancy analyses. 
+ Make som pretty figs. 
+ Write up results. 

It's early days, so jus working on the first step.  However, getting a list of journals in ecology and evolution is frustratingly hard.  This turns out to not be that easy if you are (1) trying to avoid [Thomson Reuters](http://thomsonreuters.com/), and (2) want a machine interface way to do it (read: API). 

Unfortunately, Mendeley's API does not have methods for getting a list of journals by field, or at least I don't know how to do it using [their API](http://apidocs.mendeley.com/).  No worries though - [Crossref](http://crossref.org/) comes to save the day.   Here's my attempt at this using the [Crossref OAI-PMH](http://help.crossref.org/#using_oai_pmh).

*********

### I wrote a little while loop to get journal titles from the Crossref OAI-PMH. This takes a while to run, but at least it works on my machine - hopefully yours too!

{% highlight r linenos %}
library(XML)
library(RCurl)

token <- "characters"  # define a iterator, also used for gettingn the resumptionToken
nameslist <- list()  # define empty list to put joural titles in to
while (is.character(token) == TRUE) {
    baseurl <- "http://oai.crossref.org/OAIHandler?verb=ListSets"
    if (token == "characters") {
        tok2 <- NULL
    } else {
        tok2 <- paste("&resumptionToken=", token, sep = "")
    }
    query <- paste(baseurl, tok2, sep = "")
    crsets <- xmlToList(xmlParse(getURL(query)))
    names <- as.character(sapply(crsets[[4]], function(x) x[["setName"]]))
    nameslist[[token]] <- names
    if (class(try(crsets[[2]]$.attrs[["resumptionToken"]])) == "try-error") {
        stop("no more data")
    } else token <- crsets[[2]]$.attrs[["resumptionToken"]]
}
{% endhighlight %}


*********

### Yay!  Hopefully it worked if you tried it.  Let's see how long the list of journal titles is.

{% highlight r linenos %}
sapply(nameslist, length)  # length of each list
{% endhighlight %}



{% highlight text %}
                          characters c65ebc3f-b540-4672-9c00-f3135bf849e3 
                               10001                                10001 
6f61b343-a8f4-48f1-8297-c6f6909ca7f7 
                                6864 
{% endhighlight %}



{% highlight r linenos %}
allnames <- do.call(c, nameslist)  # combine to list
length(allnames)
{% endhighlight %}



{% highlight text %}
[1] 26866
{% endhighlight %}


*********


### Now, let's use some `regex` to pull out the journal titles that are likely ecology and evolutionary biology journals.  The `^` symbol says "the string must start here". The `\\s` means whitespace.  The `[]` lets you specify a set of letters you are looking for, e.g., `[Ee]` means capital `E` *OR* lowercase `e`.  I threw in titles that had the words systematic and natrualist too.  Tried to trim any whitespace as well using the `stringr` package.

{% highlight r linenos %}
library(stringr)

ecotitles <- as.character(allnames[str_detect(allnames, "^[Ee]cology|\\s[Ee]cology")])
evotitles <- as.character(allnames[str_detect(allnames, "^[Ee]volution|\\s[Ee]volution")])
systtitles <- as.character(allnames[str_detect(allnames, "^[Ss]ystematic|\\s[Ss]systematic")])
naturalist <- as.character(allnames[str_detect(allnames, "[Nn]aturalist")])

ecoevotitles <- unique(c(ecotitles, evotitles, systtitles, naturalist))  # combine to list
ecoevotitles <- str_trim(ecoevotitles, side = "both")  # trim whitespace, if any
length(ecoevotitles)
{% endhighlight %}



{% highlight text %}
[1] 188
{% endhighlight %}



{% highlight r linenos %}

# Just the first ten titles
ecoevotitles[1:10]
{% endhighlight %}



{% highlight text %}
 [1] "Microbial Ecology in Health and Disease"           
 [2] "Population Ecology"                                
 [3] "Researches on Population Ecology"                  
 [4] "Behavioral Ecology and Sociobiology"               
 [5] "Microbial Ecology"                                 
 [6] "Biochemical Systematics and Ecology"               
 [7] "FEMS Microbiology Ecology"                         
 [8] "Journal of Experimental Marine Biology and Ecology"
 [9] "Applied Soil Ecology"                              
[10] "Forest Ecology and Management"                     
{% endhighlight %}

*********

### Get the .Rmd file used to create this post [at my github account](https://github.com/sckott/sckott.github.com/tree/master/_drafts/2012-08-30-get-ecoevo-journal-titles.Rmd).

*********

### Written in [Markdown](http://daringfireball.net/projects/markdown/), with help from [knitr](http://yihui.name/knitr/), and nice knitr highlighting/etc. in in [RStudio](http://rstudio.org/).
