---
name: openstates-from-r-via-api-watch-your-elected-representatives
layout: post
title: "OpenStates from R via API: watch your elected representatives"
author: Scott Chamberlain
date: 2011-06-10 23:19:00 -05:00
sourceslug: _posts/2011-06-10-openstates-from-r-via-api-watch-your-elected-representatives.md
tags:
- R
- Datasets
---

I am writing some functions to acquire data from the [OpenStates project,](http://openstates.sunlightlabs.com/) via [their API](http://openstates.sunlightlabs.com/api/). They have [a great support community](http://groups.google.com/group/fifty-state-project) at Google Groups as well. 

On its face this post is not obviously about ecology or evolution, but well, our elected representatives do, so to speak, hold our environment in a noose, ready to let the Earth hang any day. 

Code [I am developing is over at Github](https://SChamberlain@github.com/SChamberlain/ropstates.git). Here is an example of its use in R, in this case using the Bill Search option (billsearch.R on my Github site), and in this case you do not provide your API key in the function call, but instead put it in your .Rprofile file, which is called when you open R. 

We are searching here for the term 'agriculture' in Texas ('tx'), in the 'upper' chamber.


```r
> temp <- billsearch('agriculture', state = 'tx', chamber = 'upper')

> length(temp)
[1] 21

> temp[[1]]
$title
[1] "Congratulating John C. Padalino of El Paso for being appointed to the United States Department of Agriculture."

$created_at
[1] "2010-08-11 07:59:46"

$updated_at
[1] "2010-09-02 03:34:39"

$chamber
[1] "upper"

$state
[1] "tx"

$session
[1] "81"

$type
$type[[1]]
[1] "resolution"


$subjects
$subjects[[1]]
[1] "Resolutions"

$subjects[[2]]
[1] "Other"


$bill_id
[1] "SR 1042"
```

Apparently, the first bill (SR 2042, see $bill_id at the bottom of the list output) that came up was to congratulate John Paladino for being appointed to the USDA.

The other function I have ready is getting basic metadata on a state, called statemetasearch.

I plan to develop more functions for all the possible API calls to the OpenStates project.
