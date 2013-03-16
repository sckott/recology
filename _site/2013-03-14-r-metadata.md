opts_chunk$set(warning=FALSE, message=FALSE, comment=NA, cache=FALSE)

---
name: r-metadata
layout: post
title: Scholarly metadata in R
date: 2013-03-14
author: Scott Chamberlain
tags: 
- R
- ropensci
- metadata
- API
---

Scholarly metadata . 

Using the [Github commits API](http://developer.github.com/v3/repos/commits/) we can gather data on who commited code to a Github repository, and when they did it. Then we can visualize this hitorical record. 

***************

### Install some functions for interacting with the Github API via R

{% highlight r %}
# install_github('rmetadata', 'ropensci') # uncomment to install
library(rmetadata)
{% endhighlight %}


***************

# Count OAI-PMH identifiers for a data provider.
	

{% highlight r %}
# For DataCite.
count_identifiers("datacite")
{% endhighlight %}



{% highlight text %}
##   provider   count
## 1 datacite 1216193
{% endhighlight %}


*********
	
# Lookup article info via CrossRef with DOI and get a citation.

## As Bibtex
	

{% highlight r %}
print(crossref_citation("10.3998/3336451.0009.101"), style = "Bibtex")
{% endhighlight %}



{% highlight text %}
## @Article{,
##   title = {In Google We Trust?},
##   author = {Geoffrey Bilder},
##   journal = {The Journal of Electronic Publishing},
##   year = {2006},
##   month = {01},
##   volume = {9},
##   doi = {10.3998/3336451.0009.101},
## }
{% endhighlight %}

	
## As regular text
	

{% highlight r %}
print(crossref_citation("10.3998/3336451.0009.101"), style = "text")
{% endhighlight %}



{% highlight text %}
## Bilder G (2006). "In Google We Trust?" _The Journal of Electronic
## Publishing_, *9*. <URL:
## http://dx.doi.org/10.3998/3336451.0009.101>.
{% endhighlight %}

	
*********
	
# Search the CrossRef Metatdata for DOIs using free form references.
	
## Search with title, author, year, and journal
	

{% highlight r %}
crossref_search_free(query = "Piwowar Sharing Detailed Research Data Is Associated with Increased Citation Rate PLOS one 2007")
{% endhighlight %}



{% highlight text %}
##                                                                                              text
## 1 Piwowar Sharing Detailed Research Data Is Associated with Increased Citation Rate PLOS one 2007
##   match                   doi score
## 1  TRUE 10.1038/npre.2007.361 4.905
{% endhighlight %}

	
## Get a DOI and get the citation using \code{crossref_search}
	

{% highlight r %}
# Get a DOI for a paper
doi <- crossref_search_free(query = "Piwowar sharing data PLOS one")$doi

# Get the metadata
crossref_search(doi = doi)[, 1:3]
{% endhighlight %}



{% highlight text %}
##                            doi score normalizedScore
## 1 10.1371/journal.pone.0000308 18.19             100
{% endhighlight %}


*********
	
# Get a random set of DOI's through CrossRef.
	

{% highlight r %}
# Default search gets 20 random DOIs
crossref_r()
{% endhighlight %}



{% highlight text %}
##  [1] "10.4314/uniswa-rjast.v9i2.4778"             
##  [2] "10.1137/06067732X"                          
##  [3] "10.1136/vr.132.3.59"                        
##  [4] "10.1002/fedr.19210170804"                   
##  [5] "10.1016/S0015-6264(77)80300-3"              
##  [6] "10.1016/s0367-326x(02)00018-7"              
##  [7] "10.1016/S0002-9394(00)00915-6"              
##  [8] "10.1002/chem.201203218"                     
##  [9] "10.1055/s-0028-1087514"                     
## [10] "10.1016/0141-5425(79)90026-8"               
## [11] "10.2307/20552113"                           
## [12] "10.1007/BF01747978"                         
## [13] "10.1557/PROC-823-W13.8"                     
## [14] "10.1016/0024-3205(73)90065-9"               
## [15] "10.1080/10862969809548004"                  
## [16] "10.1007/bf00457502"                         
## [17] "10.4028/www.scientific.net/MSF.475-479.3177"
## [18] "10.5296/ijafr.v2i1.1544"                    
## [19] "10.1016/s0042-207x(96)00251-5"              
## [20] "10.1371/journal.pone.0014773.t002"
{% endhighlight %}



{% highlight r %}

# Specify you want journal articles only
crossref_r(type = "journal_article")
{% endhighlight %}



{% highlight text %}
##  [1] "10.1107/S0365110X53002039"         
##  [2] "10.1097/00010694-195407000-00022"  
##  [3] "10.1016/0032-0633(62)90041-7"      
##  [4] "10.1145/242417.242469"             
##  [5] "10.1037/h0056386"                  
##  [6] "10.1299/jamdsm.4.107"              
##  [7] "10.1086/449960"                    
##  [8] "10.2307/3499878"                   
##  [9] "10.1159/000220050"                 
## [10] "10.1007/bf01117878"                
## [11] "10.1080/00036810701243073"         
## [12] "10.1016/0271-5317(96)00069-3"      
## [13] "10.1111/j.1746-1561.1952.tb00727.x"
## [14] "10.1016/S0300-7073(05)71261-5"     
## [15] "10.7202/304859ar"                  
## [16] "10.1007/s11060-007-9362-y"         
## [17] "10.1017/S0165070X00006719"         
## [18] "10.1075/babel.44.4.13nik"          
## [19] "10.2977/prims/1166642116"          
## [20] "10.5594/J16920"
{% endhighlight %}

	
*********
	
# Search the CrossRef Metatdata API. 
	

{% highlight r %}
# Search for two different query terms
crossref_search(query = c("renear", "palmer"), rows = 4)[, 1:3]
{% endhighlight %}



{% highlight text %}
##                             doi score normalizedScore
## 1       10.1126/science.1157784 3.253             100
## 2  10.1002/meet.2009.1450460141 2.169              66
## 3 10.4242/BalisageVol3.Renear01 2.102              64
## 4 10.4242/BalisageVol5.Renear01 2.102              64
{% endhighlight %}



{% highlight r %}

# Get results for a certain year
crossref_search(query = c("renear", "palmer"), year = 2010)[, 1:3]
{% endhighlight %}



{% highlight text %}
##                                   doi  score normalizedScore
## 1            10.1002/meet.14504701218 1.0509             100
## 2            10.1002/meet.14504701240 1.0509             100
## 3           10.5270/OceanObs09.cwp.68 1.0442              99
## 4               10.1353/mpq.2010.0003 0.6890              65
## 5                  10.1353/mpq.0.0041 0.6890              65
## 6                  10.1353/mpq.0.0044 0.6890              65
## 7                  10.1353/mpq.0.0057 0.6890              65
## 8                    10.1386/fm.1.1.2 0.6890              65
## 9                    10.1386/fm.1.2.2 0.6890              65
## 10                   10.1386/fm.1.3.2 0.6890              65
## 11       10.1097/ALN.0b013e3181f09404 0.6090              57
## 12      10.1016/j.urology.2010.02.033 0.6090              57
## 13              10.1353/ect.2010.0025 0.6090              57
## 14               10.1117/2.4201001.04 0.6090              57
## 15 10.1111/j.1835-9310.1977.tb01159.x 0.6090              57
## 16    10.4067/S0717-69962010000100001 0.6090              57
## 17    10.4067/S0717-69962010000200001 0.6090              57
## 18           10.2105/AJPH.2009.191098 0.6029              57
## 19              10.1353/mpq.2010.0004 0.5167              49
## 20                 10.1353/mpq.0.0048 0.5167              49
{% endhighlight %}

	
*********
	
# Get a short DOI from shortdoi.org.
	

{% highlight r %}
# Geta a short DOI, just the short DOI returned
short_doi(doi = "10.1371/journal.pone.0042793")
{% endhighlight %}



{% highlight text %}
## [1] "10/f2bfz9"
{% endhighlight %}



{% highlight r %}

# Geta a short DOI, all data returned
short_doi(doi = "10.1371/journal.pone.0042793", justshort = FALSE)
{% endhighlight %}



{% highlight text %}
## $DOI
## [1] "10.1371/journal.pone.0042793"
## 
## $ShortDOI
## [1] "10/f2bfz9"
## 
## $IsNew
## [1] FALSE
{% endhighlight %}

	
*********
	
# Get a record from a OAI-PMH data provider.
	

{% highlight r %}
# Single provider, one identifier
md_getrecord(provider = "pensoft", identifier = "10.3897/zookeys.1.10")
{% endhighlight %}



{% highlight text %}
##                                                                                                 title
## 1 A new candidate for a Gondwanaland distribution in the Zodariidae (Araneae): Australutica in Africa
##       creator date             type
## 1 Jocqué,Rudy 2008 Research Article
{% endhighlight %}



{% highlight r %}

# Single provider, multiple identifiers
md_getrecord(provider = "pensoft", identifier = c("10.3897/zookeys.1.10", "10.3897/zookeys.4.57"))
{% endhighlight %}



{% highlight text %}
##                                                                                                    title
## 1    A new candidate for a Gondwanaland distribution in the Zodariidae (Araneae): Australutica in Africa
## 2 Studies of Tiger Beetles. CLXXVIII. A new Lophyra (Lophyra) from Somaliland (Coleoptera, Cicindelidae)
##         creator date             type
## 1   Jocqué,Rudy 2008 Research Article
## 2 Cassola,Fabio 2008 Research Article
{% endhighlight %}

	
*********
# List available metadata formats from various providers. 
	

{% highlight r %}
# List metadata formats for a provider
md_listmetadataformats(provider = "dryad")
{% endhighlight %}



{% highlight text %}
##   metadataPrefix
## 1         oai_dc
## 2            rdf
## 3            ore
## 4           mets
##                                                        schema
## 1              http://www.openarchives.org/OAI/2.0/oai_dc.xsd
## 2                 http://www.openarchives.org/OAI/2.0/rdf.xsd
## 3 http://tweety.lanl.gov/public/schemas/2008-06/atom-tron.sch
## 4                  http://www.loc.gov/standards/mets/mets.xsd
##                             metadataNamespace
## 1 http://www.openarchives.org/OAI/2.0/oai_dc/
## 2    http://www.openarchives.org/OAI/2.0/rdf/
## 3                 http://www.w3.org/2005/Atom
## 4                    http://www.loc.gov/METS/
{% endhighlight %}



{% highlight r %}

# List metadata formats for a specific identifier for a provider
md_listmetadataformats(provider = "pensoft", identifier = "10.3897/zookeys.1.10")
{% endhighlight %}



{% highlight text %}
##             identifier metadataPrefix
## 1 10.3897/zookeys.1.10         oai_dc
## 2 10.3897/zookeys.1.10           mods
##                                              schema
## 1    http://www.openarchives.org/OAI/2.0/oai_dc.xsd
## 2 http://www.loc.gov/standards/mods/v3/mods-3-1.xsd
##                             metadataNamespace
## 1 http://www.openarchives.org/OAI/2.0/oai_dc/
## 2                  http://www.loc.gov/mods/v3
{% endhighlight %}