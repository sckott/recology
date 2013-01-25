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
## Read the data in to R
dat <- read.csv("~/foo2/Scrophulariaceae.csv")
{% endhighlight %}


***************

#### Lets grab the species and concatenate to genus_species

{% highlight r %}
species <- as.character(ddply(dat[, c("Genus", "Species")], .(), transform, 
    gen_sp = as.factor(paste(Genus, Species, sep = " ")))[, 4])
{% endhighlight %}


***************

#### 

{% highlight r %}
# Install taxize install_github('taxize_', 'ropensci') # install the
# GitHub version, not the CRAN version
library(taxize)
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
Calling http://taxosaurus.org/retrieve/5372a666f6a480dc320a6474f05c3f57
Calling http://taxosaurus.org/retrieve/5680849a8b8eeb6f3d4278dea08c731a
Calling http://taxosaurus.org/retrieve/c5cdb585fa7676ef62890ecfbaa3d3b7
Calling http://taxosaurus.org/retrieve/136bdd353302b4526de8ea84ac7a3795
Calling http://taxosaurus.org/retrieve/dfc193ca59f79e83addd609e9df43fce
Calling http://taxosaurus.org/retrieve/22e5e96767e3f07fde23dccd2ecc58d3
Calling http://taxosaurus.org/retrieve/a19be9a33fd1fd7ec5af5bc1ffe9be0b
Calling http://taxosaurus.org/retrieve/229dba385f4c7137cf508a04b6aa0fe3
Calling http://taxosaurus.org/retrieve/faf7b2844e6a12059ae7a9c556c75e2a
Calling http://taxosaurus.org/retrieve/6dc5d9d36080fb5553a6768621caab7f
Calling http://taxosaurus.org/retrieve/46ed3ef3912a1b0982cfe5d5faa9b265
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


***************

### That's it.  Try it out and let us know if you have any questions at [info@ropensci.org](mailto:info@ropensci.org), or [ask questions/report problems at GitHub](https://github.com/ropensci/taxize_/issues).

***************

#### Get the .Rmd file used to create this post [at my github account](https://github.com/SChamberlain/scott/blob/gh-pages/_drafts/2013-01-25-tnrs-use-case.Rmd) - or [.md file](https://github.com/SChamberlain/scott/blob/gh-pages/_posts/2013-01-25-tnrs-use-case.md).

#### Written in [Markdown](http://daringfireball.net/projects/markdown/), with help from [knitr](http://yihui.name/knitr/).
