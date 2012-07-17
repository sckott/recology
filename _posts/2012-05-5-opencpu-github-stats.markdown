--- 
layout: post
title: Visualize your Github stats (forks and watchers) in a browser with R!
category: information
tags: datavis ggplot2 opencpu.org github R
year: 2012
month: 5
day: 5
published: true
summary: 
---

So [OpenCPU][] is pretty awesome.  You can run R in a browser using URL calls with an alphanumeric code (e.g., x3e50ee0780) defining a stored function, and any arguments you pass to it. 

Go [here][] to store a function.  And you can output lots of different types of things: png, pdf, json, etc - see [here][here2].


Here's a function I created:

<script src="https://gist.github.com/2602432.js?file=getgithubstats.r"></script>

It makes a [ggplot2][] graphic of your watchers and forks on each repo (up to 100 repos), sorted by descending number of forks/watchers.

Here's an example from the function.  Click below and you should get the below figure. 

<a href="http://beta.opencpu.org/R/call/opencpu.demo/gitstats/png">Click this :)</a>

<img src="http://beta.opencpu.org/R/call/opencpu.demo/gitstats/png" width="600" height="600" />




And you can specify user or organization name using arguments in the URL

<a href="http://beta.opencpu.org/R/call/opencpu.demo/gitstats/png?type='org'&id='ropensci'">Click this :)</a>

<img src="http://beta.opencpu.org/R/call/opencpu.demo/gitstats/png?type='org'&id='ropensci'" width="600" height="600" />


Sweet. Have fun. 


[poop]: http://beta.opencpu.org/R/call/opencpu.demo/gitstats/png
[OpenCPU]: http://opencpu.org/
[ggplot2]: http://had.co.nz/ggplot2/
[here]: http://beta.opencpu.org/apps/opencpu.demo/storefunction/
[http://beta.opencpu.org/R/call/store:tmp/x3e50ee0780/png]: http://beta.opencpu.org/R/call/store:tmp/x3e50ee0780/png
[http://beta.opencpu.org/R/call/store:tmp/x3e50ee0780/png?id='ropensci'&type='org']: http://beta.opencpu.org/R/call/store:tmp/x3e50ee0780/png?id='ropensci'&type='org'
[here2]: http://opencpu.org/documentation/outputs/