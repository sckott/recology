---
name: getting-data
layout: post
title: Getting data from figures in published papers
date: 2012-09-13
author: Scott Chamberlain
tags: 
- R
- open access
- data
- digitize
- API
- meta-analysis
---


*********

## The problem:
There are a lot of figures in published papers in the scholarly literature.  At some point, a scientist wants to ask a question for which they can synthesize the knowledge on that question by collecting data from the published literature.  This often requires:

1. Search for relavant papers (e.g., via Google Scholar) 
2. Collect the papers, decide which are useable
3. Collect data from the figures using software on a personal computer. Examples are [GraphClick](http://www.arizona-software.ch/graphclick/), [ImageJ](http://rsbweb.nih.gov/ij/), and more.  
4. Analyze data - publish paper. 

This workflow needs revamping, particularly in step number 3 - collecting the data. The variety of programs to collect data is a good thing as you have a choice, but we can do better. 

## A solution
Specifically, this data collection process can be part of modern technology, and be based in the browser. Think of the benefits of a browser based data collection approach:

+ Cross-platform: a data digitization program that lives in the browser can be more easily cross-platform than a native app. 
+ Linked data: with the increasing abundance of APIs (application programming interfaces), we can link the data going into this app, and data going out easily.  Not so easy in a native app. 
+ Automatic updates: a web based browser can be updated easily without requiring a user to go get updates. 
+ User-based: a web based browser can easily integrate user login so that users can be associated with data collected, allowing for quantification of user-based error, and eventually user based scores/badges/etc. 
+ 

## What could this be in the future?
I think this idea could be huge, or a total flop.  The reason I think it could be huge is based on two observations: 

1. There is a seemingly endless supply of academic papers with figures in them from which data can be extracted. 
2. There is increasing use of meta-analysis in science, which is fed by just this kind of data. 




*********

### Get the .Rmd file used to create this post [at my github account](https://github.com/SChamberlain/schamberlain.github.com/blob/master/_drafts/2012-09-13-getting-data.Rmd) - or [.md file](https://github.com/SChamberlain/schamberlain.github.com/tree/master/_posts/2012-09-13-getting-data.md).

*********

### Written in [Markdown](http://daringfireball.net/projects/markdown/), with help from [knitr](http://yihui.name/knitr/), and nice knitr highlighting/etc. in in [RStudio](http://rstudio.org/).
