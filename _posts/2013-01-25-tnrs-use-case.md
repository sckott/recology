---
name: tnrs-use-case
layout: post
title: Resolving species names when you have a lot of them
date: 2013-01-25
author: Scott Chamberlain
tags: 
- R
- ropensci
- taxize
- taxonomic
---

### __taxize use case: Resolving species names when you have a lot of them__

Species names can be a pain in the ass, especially if you are an ecologist. We ecologists aren't trained in taxonomy, yet we often end up with huge species lists.  Of course we want to correct any spelling errors in the names, and get the newest names for our species, resolve any synonyms, etc. 

We are building tools into our R package [`taxize`](http://ropensci.github.com/taxize_/), that will let you check your species names to make sure they are correct. 

An important use case is when you have a lot of species. Someone wrote to us recently, saying that they had thousands of species, and they wanted to know how to check their species names efficiently in R. 

Below is an example of how to do this. 

***************

#### Install taxize

{% highlight r %}
# install_github('taxize_', 'ropensci') # install the GitHub version, not
# the CRAN version, uncomment if you don't have it installed
library(taxize)
{% endhighlight %}


***************

#### Get some species, in this case all species in the Scrophulariaceae family from theplantlist.org

{% highlight r %}
tpl_get(dir_ = "~/foo2", family = "Scrophulariaceae")
{% endhighlight %}



{% highlight text %}
## Reading and writing csv files to ~/foo2...
{% endhighlight %}


{% highlight r %}
dat <- read.csv("~/foo2/Scrophulariaceae.csv")
{% endhighlight %}


***************

#### Lets grab the species and concatenate to genus_species

{% highlight r %}
species <- as.character(ddply(dat[, c("Genus", "Species")], .(), transform, 
    gen_sp = as.factor(paste(Genus, Species, sep = " ")))[, 4])
{% endhighlight %}


***************

#### It's better to do many smaller calls to a web API instead of few big ones to be nice to the database maintainers.

{% highlight r %}
## Define function to split up your species list into useable chuncks
slice <- function(input, by = 2) {
    starts <- seq(1, length(input), by)
    tt <- lapply(starts, function(y) input[y:(y + (by - 1))])
    llply(tt, function(x) x[!is.na(x)])
}
species_split <- slice(species, by = 100)
{% endhighlight %}


***************

#### Query for your large species list with pauses between calls, with 3 seconds in between calls to not hit the web service too hard. Using POST method here instead of GET - required when you have a lot of species.

{% highlight r %}
tnrs_safe <- failwith(NULL, tnrs)  # in case some calls fail, will continue
out <- llply(species_split, function(x) tnrs_safe(x, getpost = "POST", sleep = 3))
{% endhighlight %}


{% highlight text %}
Calling http://taxosaurus.org/retrieve/90fcd9ae425ad7c6103b06dd9fd78ae2
Calling http://taxosaurus.org/retrieve/223f73b83fcddcb8b6187966963660a8
Calling http://taxosaurus.org/retrieve/72bacdbb8938316e321d4c709c8cdd09
Calling http://taxosaurus.org/retrieve/979ce9cc4dec376710f61de162e1294e
Calling http://taxosaurus.org/retrieve/03a39a124561fec2fdfc0f483d9fb607
Calling http://taxosaurus.org/retrieve/d4bf4e5a1403f45a1be1ca3dd87785d7
Calling http://taxosaurus.org/retrieve/a9a9bdde6fda7e325d80120e27ccb480
Calling http://taxosaurus.org/retrieve/215ccdcf2b00362278bf19d1942e1395
Calling http://taxosaurus.org/retrieve/9d43c0b99b4dfb5ea1b435adab17b980
Calling http://taxosaurus.org/retrieve/42e166f8e43f1fb349e36459cd5938b3
Calling http://taxosaurus.org/retrieve/2c42e4b5227c5464f9bfeeafcdf0651d
{% endhighlight %}



{% highlight r %}

# Looks like we got some data back for each element of our species list
lapply(out, head)[1:2]  # just look at the first two
{% endhighlight %}



{% highlight text %}
[[1]]
                 submittedName                 acceptedName    sourceId
1        Aptosimum welwitschii                              iPlant_TNRS
2        Anticharis ebracteata        Anticharis ebracteata iPlant_TNRS
3            Aptosimum lineare            Aptosimum lineare iPlant_TNRS
4     Antherothamnus pearsonii     Antherothamnus pearsonii iPlant_TNRS
5 Barthlottia madagascariensis Barthlottia madagascariensis iPlant_TNRS
6         Agathelpis mucronata                              iPlant_TNRS
  score                  matchedName     annotations
1     1        Aptosimum welwitschii                
2     1        Anticharis ebracteata          Schinz
3     1            Aptosimum lineare Marloth & Engl.
4     1     Antherothamnus pearsonii        N.E. Br.
5     1 Barthlottia madagascariensis      Eb. Fisch.
6     1         Agathelpis mucronata                
                                    uri
1                                      
2 http://www.tropicos.org/Name/29202501
3 http://www.tropicos.org/Name/29202525
4 http://www.tropicos.org/Name/29202728
5 http://www.tropicos.org/Name/50089700
6                                      

[[2]]
                     submittedName           acceptedName    sourceId
1 Buddleja pichinchensis x bullata Buddleja pichinchensis iPlant_TNRS
2                 Buddleja soratae       Buddleja soratae iPlant_TNRS
3              Buddleja euryphylla    Buddleja euryphylla iPlant_TNRS
4                  Buddleja incana        Buddleja incana iPlant_TNRS
5                  Buddleja incana                 Incana        NCBI
6                    Buddleja nana Buddleja brachystachya iPlant_TNRS
  score            matchedName        annotations
1   0.9 Buddleja pichinchensis              Kunth
2   1.0       Buddleja soratae           Kraenzl.
3   1.0    Buddleja euryphylla Standl. & Steyerm.
4   1.0        Buddleja incana        Ruiz & Pav.
5   1.0        Buddleja incana               none
6   1.0          Buddleja nana              Diels
                                          uri
1       http://www.tropicos.org/Name/19000333
2       http://www.tropicos.org/Name/19001018
3       http://www.tropicos.org/Name/19000790
4       http://www.tropicos.org/Name/19000596
5 http://www.ncbi.nlm.nih.gov/taxonomy/405077
6       http://www.tropicos.org/Name/19001133
{% endhighlight %}



{% highlight r %}

# Now we can put them back together as so into one data.frame if you like
outdf <- ldply(out)
head(outdf)
{% endhighlight %}



{% highlight text %}
                 submittedName                 acceptedName    sourceId
1        Aptosimum welwitschii                              iPlant_TNRS
2        Anticharis ebracteata        Anticharis ebracteata iPlant_TNRS
3            Aptosimum lineare            Aptosimum lineare iPlant_TNRS
4     Antherothamnus pearsonii     Antherothamnus pearsonii iPlant_TNRS
5 Barthlottia madagascariensis Barthlottia madagascariensis iPlant_TNRS
6         Agathelpis mucronata                              iPlant_TNRS
  score                  matchedName     annotations
1     1        Aptosimum welwitschii                
2     1        Anticharis ebracteata          Schinz
3     1            Aptosimum lineare Marloth & Engl.
4     1     Antherothamnus pearsonii        N.E. Br.
5     1 Barthlottia madagascariensis      Eb. Fisch.
6     1         Agathelpis mucronata                
                                    uri
1                                      
2 http://www.tropicos.org/Name/29202501
3 http://www.tropicos.org/Name/29202525
4 http://www.tropicos.org/Name/29202728
5 http://www.tropicos.org/Name/50089700
6
{% endhighlight %}


Note that there are multiple names for some species because data sources have different names for the same species (resulting in more than one row in the data.frame 'outdf' for a species). We are leaving this up to the user to decide which to use. For example, for the species _Buddleja montana_ there are two names for in the output

{% highlight r %}
data <- ddply(outdf, .(submittedName), summarize, length(submittedName))
outdf[outdf$submittedName %in% as.character(data[data$..1 > 1, ][6, "submittedName"]), 
    ]
{% endhighlight %}



{% highlight text %}
       submittedName     acceptedName    sourceId score      matchedName
123 Buddleja montana Buddleja montana iPlant_TNRS     1 Buddleja montana
124 Buddleja montana          Montana        NCBI     1 Buddleja montana
         annotations                                         uri
123 Britton ex Rusby       http://www.tropicos.org/Name/19000601
124             none http://www.ncbi.nlm.nih.gov/taxonomy/441235
{% endhighlight %}


The source iPlant matched the name, but NCBI actually gave back a genus of cricket (follow the link under the column uri for _Montana_). If you look at the page for _Buddleja_ on NCBI [here](http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?id=26473) there is no _Buddleja montana_ at all. 

Another thing we could do is look at the score that is returned. Let's look at those that are less than 1 (i.e., )

{% highlight r %}
outdf[outdf$score < 1, ]
{% endhighlight %}



{% highlight text %}
                        submittedName           acceptedName    sourceId
94   Buddleja pichinchensis x bullata Buddleja pichinchensis iPlant_TNRS
340                Diascia ellaphieae                        iPlant_TNRS
495              Eremophila decipiens                        iPlant_TNRS
500            Eremophila grandiflora             Eremophila iPlant_TNRS
808           Jamesbrittneia hilliard                        iPlant_TNRS
1051                 Verbascum patris              Verbascum iPlant_TNRS
1081             Verbascum barnadesii              Verbascum iPlant_TNRS
1097              Verbascum calycosum              Verbascum iPlant_TNRS
     score            matchedName annotations
94    0.90 Buddleja pichinchensis       Kunth
340   0.98      Diascia ellaphiae            
495   0.98  Eremophila decipiense            
500   0.50             Eremophila      R. Br.
808   0.50         Jamesbrittenia            
1051  0.50              Verbascum          L.
1081  0.50              Verbascum          L.
1097  0.50              Verbascum          L.
                                       uri
94   http://www.tropicos.org/Name/19000333
340                                       
495                                       
500  http://www.tropicos.org/Name/40004761
808                                       
1051 http://www.tropicos.org/Name/40023766
1081 http://www.tropicos.org/Name/40023766
1097 http://www.tropicos.org/Name/40023766
{% endhighlight %}


As we got this speies list from [theplantlist.org](http://www.theplantlist.org/), there aren't that many mistakes, but if it was my species list you know there would be many :)


***************

### That's it.  Try it out and let us know if you have any questions at [info@ropensci.org](mailto:info@ropensci.org), or [ask questions/report problems at GitHub](https://github.com/ropensci/taxize_/issues).

***************

#### Get the .Rmd file used to create this post [at my github account](https://github.com/SChamberlain/schamberlain.github.com/tree/master/2013-01-25-tnrs-use-case.Rmd) - or [.md file](https://github.com/SChamberlain/schamberlain.github.com/tree/master/_posts/2013-01-25-tnrs-use-case.md).

#### Written in [Markdown](http://daringfireball.net/projects/markdown/), with help from [knitr](http://yihui.name/knitr/).