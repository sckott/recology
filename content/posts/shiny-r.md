---
name: shiny-r
layout: post
title: Shiny apps are awesome
date: 2012-12-10
author: Scott Chamberlain
sourceslug: _drafts/2012-12-10-shiny-r.Rmd
tags: 
- R
- RStudio
- ropensci
- shiny
---

RStudio has a new product called `Shiny` that, quoting from their website, "makes it super simple for R users like you to turn analyses into interactive web applications that anyone can use". [See here](http://www.rstudio.com/shiny/) for more information. 

A `Shiny` basically consists of two files: a `ui.r` file and a `server.r` file.  The `ui.r` file, as it says, provides the user interface, and the `server.r` file provides the the server logic.

Below is what it looks like in the wild (on a browser). 

![center](http://sckott.github.io/public/img/shiny_ss.png) 

It was pretty easy (for [Ted Hart of rOpenSci](http://emhart.github.com/)) to build this app to demonstrate output from the [`ropensci rgbif` package](http://cran.r-project.org/web/packages/rgbif/index.html). 

### You may need to install packages first.

```r
install.packages(c("shiny", "ggplot2", "plyr", "rgbif"))
```

### We tried to build in making real time API calls to GBIF's servers, but the calls took too long for web speed.  So we prepare the data first, and then serve it up from saved data in a `.rda` file. Let's first prepare the data. --Well, this is what we do on the app itself, but see the next code block for

```r
library(rgbif)
splist <- c("Accipiter erythronemius", "Junco hyemalis", "Aix sponsa", "Haliaeetus leucocephalus", 
    "Corvus corone", "Threskiornis molucca", "Merops malimbicus")
out <- llply(splist, function(x) occurrencelist(x, coordinatestatus = T, maxresults = 100))
names(out) <- splist  # name each data.frame with the species names
setwd("~/ShinyApps/rgbif2")  # set directory
save(out, file = "speciesdata.rda")  # save the list of data.frames into an .rda file to serve up
```

### Here's the server logic

```r
library(shiny)
library(plyr)
library(ggplot2)
library(rgbif)

## Set up server output
shinyServer(function(input, output) {
    load("speciesdata.rda")
    # define function for server plot output
    output$gbifplot <- reactivePlot(function() {
        species <- input$spec
        df <- out[names(out) %in% species]
        print(gbifmap(df))
    })
    output$cbt <- reactiveText(function() {
    })
})
```

### The user interface

```r
library(shiny)

# Define UI for application that plots random distributions
shinyUI(pageWithSidebar(headerPanel("rgbif example"), sidebarPanel(checkboxGroupInput("spec", 
    "Species to map:", c(`Sharp shinned hawk (Accipiter erythronemius)` = "Accipiter erythronemius", 
        `Dark eyed junco (Junco hyemalis)` = "Junco hyemalis", `Wood duck (Aix sponsa)` = "Aix sponsa", 
        `Bald eagle (Haliaeetus leucocephalus)` = "Haliaeetus leucocephalus", 
        `Carrion crow (Corvus corone)` = "Corvus corone", `Australian White Ibis (Threskiornis molucca)` = "Threskiornis molucca", 
        `Rosy Bee-eater (Merops malimbicus)` = "Merops malimbicus"), selected = c("Bald eagle (Haliaeetus leucocephalus)"))), 
    mainPanel(h5("A map of your selected species: Please note that GBIF is queried for every selection so loading times vary"), 
        plotOutput("gbifplot"))))
```



This should be all you need. To actually serve up the app in the web, request to be part of their beta-test of Shiny server on the web [here](https://rstudio.wufoo.com/forms/shiny-server-beta-program/).

Go play with our Shiny app [here](http://glimmer.rstudio.com/ropensci/rgbif2/) to see the kind of visualization you can do with the `rgbif` package.


Get the .Rmd file used to create this post [at my github account](https://github.com/sckott/sckott.github.com/tree/master/_drafts/2012-12-10-shiny-r.Rmd) - or [.md file](https://github.com/sckott/sckott.github.com/tree/master/_posts/2012-12-10-shiny-r.md).

Written in [Markdown](http://daringfireball.net/projects/markdown/), with help from [knitr](http://yihui.name/knitr/).
