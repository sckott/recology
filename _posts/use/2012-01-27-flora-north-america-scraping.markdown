--- 
layout: post
title: Scraping Flora of North America
date: 2012-01-27
tags: R scraping
---

Written by ~ Scott Chamberlain

So [Flora of North America][fna] is an awesome collection of taxonomic information for plants across the continent.  However, the information within is not easily machine readable.  

So, a little web scraping is called for.

[rfna][] is an R package to collect information from the Flora of North America. 

So far, you can:
1. Get taxonomic names from web pages that index the names.
2. Then get daughter URLs for those taxa, which then have their own 2nd order daughter URLs you can scrape, or scrape the 1st order daughter page. 
3. Query Asteraceae taxa for whether they have paleate or epaleate receptacles.  This function is something I needed, but more functions will be made like this to get specific traits. 

Further functions will do search, etc.

You can install by:

{% highlight r %}
install.packages("devtools")
require(devtools)
install_github("rfna", "rOpenSci")
require(rfna)
{% endhighlight %}

Here is an example where a set of URLs is acquired using function ```getdaughterURLs```, then the function ```receptacle``` is used to ask whether of each the taxa at those URLs have paleate or epaleate receptacles. 


<script src="https://gist.github.com/1690353.js?file=rfna_demo.r"></script>


[fna]: http://fna.huh.harvard.edu/
[rfna]: https://github.com/ropensci/rfna
