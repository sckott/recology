---
name: open-science-challenge
layout: post
title: Open Science Challenge
date: 2013-01-08
author: Scott Chamberlain
sourceslug: _drafts/2013-01-08-open-science-challenge.Rmd
tags: 
- R
- ropensci
---

![center](https://raw.github.com/sckott/sckott.github.com/master/public/img/ropensci_challenge.png)


### __Open Science__

Science is becoming more open in many areas: publishing, data sharing, lab notebooks, and software. There are many benefits to open science. For example, sharing research data alongside your publications leads to increased citation rate (Piwowar _et. al._ 2007). In addition, data is becoming easier to share and reuse thanks to efforts like [FigShare](http://figshare.com/) and [Dryad](http://datadryad.org/). 

If you don't understand the problem we are currently facing due to lack of open science, watch this video:

{{< rawhtml >}}
<iframe width="560" height="315" src="http://www.youtube.com/embed/N2zK3sAtr-4" frameborder="0" allowfullscreen></iframe>
{{< /rawhtml >}}

### __I just want Data__

Another way to look at this challenge is to think about how you can get data more easily. Right now you probably go to a website that has an interface to a database. You do a search, and then download a .csv file perhaps. Then you open it in Excel, and do some pivot tables to get the data in the right format. Only then will you bring the data in to R. 

The advantage of using our packages is that they allow you to do that data collection part in a few lines of code. Therefore, you can easily do all those steps in the above paragraph using a few lines of code in one R file. Why does this matter? You can more easily reproduce your own work months later after that summer vacation. In addition, others can reproduce your research more easily. 


### __The challenge__

We ([ropensci](http://ropensci.org/)) have just kicked off the [rOpenSci Open Science Challenge](http://ropensci.org/open-science-challenge/). If you aren't familiar with rOpenSci, it is a software collective connecting scientists to open science data on the web. Since R is the most popular programming language for life scientists, it made sense to do this in R (instead of Python e.g.). 


### __What is the challenge about?__

At rOpenSci, we create R software to make getting open source text from publications and open source data easy. An important result of this is that we are facilitating open science. Why? Because R is an open source programming language, and all of our software is open source. . This challenge asks you to propose a project using one or more of our packages - or perhaps you want to propose a new dataset to connect to R. The rOpenSci core developer team will help you with any problems using our packages, and attempt to modify packages according to feedback from participants. Do you use one or more of our R packages? If you do, great. If not, check out our packages [here](http://ropensci.org/packages/index.html). 


### __How to apply__

Just send an email to [info@ropensci.org](mailto:info@ropensci.org?subject=rOpenSci Open Science Challenge). 


### __The deadline__

January 31, 2013


#### Get the .Rmd file used to create this post [at my github account](https://github.com/sckott/sckott.github.com/tree/master/_drafts/2013-01-08-open-science-challenge.Rmd) - or [.md file](https://github.com/sckott/sckott.github.com/tree/master/_posts/2013-01-08-open-science-challenge.md).

#### Written in [Markdown](http://daringfireball.net/projects/markdown/), with help from [knitr](http://yihui.name/knitr/), and [knitcitations](https://github.com/cboettig/knitcitations) from [Carl Boettiger](http://www.carlboettiger.info/).


#### References

{{< rawhtml >}}
<p>Piwowar HA, Day RS, Fridsma DB and Ioannidis J (2007).
&ldquo;Sharing Detailed Research Data is Associated With Increased Citation Rate.&rdquo;
<EM>Plos One</EM>, <B>2</B>.
<a href="http://dx.doi.org/10.1371/journal.pone.0000308">http://dx.doi.org/10.1371/journal.pone.0000308</a>.
{{< /rawhtml >}}
