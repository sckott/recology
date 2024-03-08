---
name: crdata-vs-cloudnumbers
layout: post
title: CRdata vs. Cloudnumbers
author: Scott Chamberlain
date: 2011-07-14 08:31:00.001000 -05:00
sourceslug: _posts/2011-07-14-crdata-vs-cloudnumbers.md
tags:
- cloudcomputing
- R
---
<a href="http://www.cloudnumbers.com/">Cloudnumbers</a> and <a href="http://crdata.org/">CRdata</a> are two new cloud computing services.

I tested the two services with a very simple script. The script simply creates a dataframe of 10000 numbers via rnorm, and assigns them to a factor of one of two levels (a or b). I then take the mean of the two factor levels with the aggregate function.

In CRdata you need to put in some extra code to format the output in a browser window. For example, the last line below needs to have '&lt;crdata_object&gt;' on both sides of the output object so it can be rendered in a browser. And etc. for other things that one would print to a console. Whereas you don't need this extra code for using Cloudnumbers.

```r
dat <- data.frame(n = rnorm(10000), p = rep(c('a','b'), each=5000))
out <- aggregate(n ~ p, data = dat, mean)
```

Here is a screenshot of the output from CRdata with the simple script above.<br /><img height="208" src="http://f.cl.ly/items/1D090q2N0Y3a410W262V/Screen%20shot%202011-07-14%20at%208.04.33%20AM.png" width="400" /><br />This simple script ran in about 20 seconds or so from starting the job to finishing. However, it seems like the only output option is html. Can this be right? This seems like a terrible only option.

In Cloudnumbers you have to start a workspace, upload your R code file.<br />Then, start a session...<br />choose your software platform...<br />choose packages (one at a time, very slow)...<br />then choose number of clusters, etc.<br />Then finally star the job.<br />Then it initializes, then finally you can open the console, and<br />Then from here it is like running R as you normally would, except on the web.

<u>Who wins (at least for our very minimal example above)</u>

<ol><li>Speed of entire process (not just running code): CRdata</li><li>Ease of use: CRdata</li><li>Cost: CRdata (free only)</li><li>Least annoying: Cloudnumbers (you don't have to add in extra code to run your own code)</li><li>Opensource: CRdata (you can use publicly available code on the site)</li><li>Long-term use: Cloudnumbers (more powerful, flexible, etc.)</li></ol><div><br /></div><div>I imagine Cloudnumbers could be faster for larger jobs, but you would have to pay for the speed of course.&nbsp;</div><div><br /></div><div>What I really want to see is a cloud computing service that accepts code directly run from R or RStudio. Hmmm...that would be so tasty indeed. I think<a href="http://cloudnumbers.zendesk.com/entries/20199198-using-an-external-terminal-ssh-console"> Cloudnumbers may be able to do this</a>, but haven't tested it yet.&nbsp;&nbsp;</div><div><br /></div><div>Perhaps using the server version of RStudio along with Amazon's EC2 is a better option than both of these. See Karthik Ram's <a href="http://inundata.org/2011/03/30/r-ec2-rstudio-server/">post</a> about using RStudio server along with Amazon's EC2. Even just running RStudio server on your Unbuntu machine or virtual machine is a pretty cool option, even without EC2 (works like a charm on my Parallels Ubuntu vm on my Mac).&nbsp;</div>
