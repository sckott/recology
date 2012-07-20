--- 
name: opencpu-github
layout: post
title: Visualize your Github stats (forks and watchers) in a browser with R!
date: 2012-05-5
author: Scott Chamberlain
tags: 
- datavisualization
- ggplot2
- opencpu.org
- github
---

So [OpenCPU][] is pretty awesome.  You can run R in a browser using URL calls with an alphanumeric code (e.g., x3e50ee0780) defining a stored function, and any arguments you pass to it. 

Go [here][] to store a function.  And you can output lots of different types of things: png, pdf, json, etc - see [here][here2].


Here's a function I created:

<script src="https://gist.github.com/2602432.js?file=getgithubstats.r"></script>

It makes a [ggplot2][] graphic of your watchers and forks on each repo (up to 100 repos), sorted by descending number of forks/watchers.

Here's an example from the function.  Paste the following in to your browser and you should get the below figure. 

http://beta.opencpu.org/R/call/opencpu.demo/gitstats/png

![had](/img/hadley.png)



And you can specify user or organization name using arguments in the URL

http://beta.opencpu.org/R/call/opencpu.demo/gitstats/png?type='org'&id='ropensci'

![ropensci](/img/ropensci.png)



Sweet. Have fun. 

[ggplot2]: http://had.co.nz/ggplot2/
[OpenCPU]: http://opencpu.org/
[here]: http://beta.opencpu.org/apps/opencpu.demo/storefunction/
[http://beta.opencpu.org/R/call/store:tmp/x3e50ee0780/png]: http://beta.opencpu.org/R/call/store:tmp/x3e50ee0780/png
[http://beta.opencpu.org/R/call/store:tmp/x3e50ee0780/png?id='ropensci'&type='org']: http://beta.opencpu.org/R/call/store:tmp/x3e50ee0780/png?id='ropensci'&type='org'
[here2]: http://opencpu.org/documentation/outputs/