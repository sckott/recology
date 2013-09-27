---
name: taxonomy-in-three-acts
layout: post
title: Taxonomy data from the web in three languages
date: 2013-09-27
author: Scott Chamberlain
tags:
- r
- ruby
- python
- taxonomy
---

Eduard Szöcs and I started developing a taxonomic toolbelt for the R language a while back , which lets you interact with a multitude of taxonomic databases on the web. We have a paper in F1000Research if you want to find out more (see [here](http://f1000research.com/articles/2-191/v1)).

I thought it would be fun to rewrite some of taxize in other languages to learn more languages. Ruby and Python made the most sense to try. I did try others (Julia, Node), but gave up on those. 

Anyway, here's use of the same function in three languages: R, Ruby, and Python. The function searches the [Global Names Index](http://gni.globalnames.org/), but is named slightly differently in R (`gni_search`) vs. Ruby/Python (`gniSearch`). (yes, I realize the package names aren't consistent)

### R

Code [here](https://github.com/ropensci/taxize_)

{% highlight r %}
install.packages("taxize")
library(taxize)
{% endhighlight %}

Then search for a taxonomic name

{% highlight r %}
out <- gni_search('Helianthus annuus')
out[1,]
{% endhighlight %}


{% highlight r %}
               name      id
1 Helianthus annuus 3329657
                                                                 lsid
1 urn:lsid:globalnames.org:index:18f9c244-a450-535e-adcd-2bfaf85c9b2e
                              uuid_hex resource_url
1 18f9c244-a450-535e-adcd-2bfaf85c9b2e         none
{% endhighlight %}

<br><br>
### Ruby

Code [here](https://github.com/SChamberlain/tacksize)

{% highlight bash %}
git clone https://github.com/SChamberlain/tacksize.git
cd tacksize
gem install tacksize
{% endhighlight %}

In a Ruby repl, like `irb`, search for a taxonomic name

{% highlight ruby %}
require 'tacksize'
out = Tacksize.gniSearch(:search_term => 'Helianthus annuus')
out[0]
{% endhighlight %}

{% highlight ruby %}
=> {"uuid_hex"=>"18f9c244-a450-535e-adcd-2bfaf85c9b2e", "name"=>"Helianthus annuus", "lsid"=>"urn:lsid:globalnames.org:index:18f9c244-a450-535e-adcd-2bfaf85c9b2e", "resource_uri"=>"http://gni.globalnames.org/name_strings/3329657.xml", "id"=>3329657}
{% endhighlight %}

<br><br>
### Python

Code [here](https://github.com/SChamberlain/pytaxize)

{% highlight bash %}
git clone https://github.com/SChamberlain/pytaxize.git
cd pytaxize
python setup.py
{% endhighlight %}

In a Python repl, like `ipython`, search for a taxonomic name

{% highlight python %}
import pytaxize
out = pytaxize.gniSearch(name = 'Helianthus annuus')
out['name_strings'][0]
{% endhighlight %}

{% highlight python %}
{u'id': 3329657,
 u'lsid': u'urn:lsid:globalnames.org:index:18f9c244-a450-535e-adcd-2bfaf85c9b2e',
 u'name': u'Helianthus annuus',
 u'resource_uri': u'http://gni.globalnames.org/name_strings/3329657.xml',
 u'uuid_hex': u'18f9c244-a450-535e-adcd-2bfaf85c9b2e'}
{% endhighlight %}