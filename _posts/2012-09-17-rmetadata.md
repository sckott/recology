---
name: rmetadata
layout: post
title: Scholarly metadata from R
date: 2012-09-17
author: Scott Chamberlain
sourceslug: _posts/2012-09-17-rmetadata.md
tags:
- R
- open access
- data
- metadata
- OAI-PMH
---

Metadata!  Metadata is very cool.  It's super hot right now - everybody is talking about it.  Okay, maybe not everyone, but it's an important part of archiving scholarly work.

We are working on [a repo on GitHub `rmetadata`](https://github.com/ropensci/rmetadata) to be a one stop shop for querying metadata from around the web.  Various repos on GitHub we have started - [rpmc](https://github.com/ropensci/rpmc), [rdatacite](https://github.com/ropensci/rpmc), [rdryad](https://github.com/ropensci/rpmc), [rpensoft](https://github.com/ropensci/rpmc), [rhindawi](https://github.com/ropensci/rpmc) - will at least in part be folded into `rmetadata`.

As a start we are writing functions to hit any metadata services that use the [OAI-PMH: "Open Archives Initiative Protocol for Metadata Harvesting"](http://www.openarchives.org/OAI/openarchivesprotocol.html) framework.  `OAI-PMH` has six methods (or verbs as they are called) for data harvesting that are the same across different metadata providers:

+ `GetRecord`
+ `Identify`
+ `ListIdentifiers`
+ `ListMetadataFormats`
+ `ListRecords`
+ `ListSets`

`OAI-PMH` provides an updating list of data providers, which we can easily use to get the base URLs for their data.  Then we just use one of the six above methods to query their metadata.

### Let's install rmetadata first.

{% highlight r linenos %}
install_github("rmetadata", "ropensci")
library(rmetadata)
{% endhighlight %}


### The most basic thing you can do with `OAI-PMH` is identify the data provider, getting their basic information. The `Identify` verb.

{% highlight r linenos %}
# one provider
md_identify(provider = "datacite")
{% endhighlight %}



{% highlight text %}
repositoryName                     baseURL protocolVersion
1   DataCite MDS http://oai.datacite.org/oai             2.0
        adminEmail    earliestDatestamp deletedRecord
1 admin@datacite.org 2011-01-01T00:00:00Z            no
         granularity compression compression.1
1 YYYY-MM-DDThh:mm:ssZ        gzip       deflate
                                                                                                                                                    description
1 oai, oai.datacite.org, :, oai:oai.datacite.org:12425, http://www.openarchives.org/OAI/2.0/oai-identifier http://www.openarchives.org/OAI/2.0/oai-identifier.xsd
{% endhighlight %}



{% highlight r linenos %}

# many providers
md_identify(provider = c("datacite", "pensoft"))
{% endhighlight %}



{% highlight text %}
    repositoryName                     baseURL protocolVersion
1       DataCite MDS http://oai.datacite.org/oai             2.0
2 Pensoft Publishers       http://oai.pensoft.eu             2.0
        adminEmail    earliestDatestamp deletedRecord
1 admin@datacite.org 2011-01-01T00:00:00Z            no
2               NULL           2008-07-04            no
         granularity compression compression.1
1 YYYY-MM-DDThh:mm:ssZ        gzip       deflate
2           YYYY-MM-DD        NULL          NULL
                                                                                                                                                    description
1 oai, oai.datacite.org, :, oai:oai.datacite.org:12425, http://www.openarchives.org/OAI/2.0/oai-identifier http://www.openarchives.org/OAI/2.0/oai-identifier.xsd
2                                                                                                                                                            NULL
{% endhighlight %}



{% highlight r linenos %}

# no match for one, two matches for other
md_identify(provider = c("harvard", "journal"))
{% endhighlight %}



{% highlight text %}
$harvard
             x
1 no match found

$journal
                                             repo_name
1       Hrcak - Portal of scientific journals of Croatia
2 International journal of Power Electronics Engineering

{% endhighlight %}



{% highlight r linenos %}

# let's pick one from the second
md_identify(provider = "Hrcak")
{% endhighlight %}



{% highlight text %}
                                  repositoryName
1 Hrcak - Portal of scientific journals of Croatia
                  baseURL protocolVersion    adminEmail
1 http://hrcak.srce.hr/oai/             2.0 hrcak@srce.hr
earliestDatestamp deletedRecord granularity
1        2005-12-01            no  YYYY-MM-DD
                                                                                                                                                                        description
1 oai, hrcak.srce.hr, :, oai:hrcak.srce.hr:anIdentifier, http://www.openarchives.org/OAI/2.0/oai-identifier                    http://www.openarchives.org/OAI/2.0/oai-identifier.xsd
{% endhighlight %}


### There are a variety of metadata formats, depending on the data provider - list them with the `ListMetadataFormats` verb.

{% highlight r linenos %}
# List metadata formats for a provider
md_listmetadataformats(provider = "dryad")
{% endhighlight %}



{% highlight text %}
metadataPrefix
1         oai_dc
2            rdf
3            ore
4           mets
                                                     schema
1              http://www.openarchives.org/OAI/2.0/oai_dc.xsd
2                 http://www.openarchives.org/OAI/2.0/rdf.xsd
3 http://tweety.lanl.gov/public/schemas/2008-06/atom-tron.sch
4                  http://www.loc.gov/standards/mets/mets.xsd
                          metadataNamespace
1 http://www.openarchives.org/OAI/2.0/oai_dc/
2    http://www.openarchives.org/OAI/2.0/rdf/
3                 http://www.w3.org/2005/Atom
4                    http://www.loc.gov/METS/
{% endhighlight %}



{% highlight r linenos %}

# List metadata formats for a specific identifier for a provider
md_listmetadataformats(provider = "pensoft", identifier = "10.3897/zookeys.1.10")
{% endhighlight %}



{% highlight text %}
          identifier metadataPrefix
1 10.3897/zookeys.1.10         oai_dc
2 10.3897/zookeys.1.10           mods
                                           schema
1    http://www.openarchives.org/OAI/2.0/oai_dc.xsd
2 http://www.loc.gov/standards/mods/v3/mods-3-1.xsd
                          metadataNamespace
1 http://www.openarchives.org/OAI/2.0/oai_dc/
2                  http://www.loc.gov/mods/v3
{% endhighlight %}


### The `ListRecords` verb is used to harvest records from a repository

{% highlight r linenos %}
head(md_listrecords(provider = "datacite")[[1]][, 2:4])
{% endhighlight %}



{% highlight text %}
                identifier            datestamp setSpec
1 oai:oai.datacite.org:32153 2011-06-08T08:57:11Z     TIB
2 oai:oai.datacite.org:32200 2011-06-20T08:11:08Z     TIB
3 oai:oai.datacite.org:32220 2011-06-28T14:11:08Z     TIB
4 oai:oai.datacite.org:32241 2011-06-30T13:24:45Z     TIB
5 oai:oai.datacite.org:32255 2011-07-01T12:09:24Z     TIB
6 oai:oai.datacite.org:32282 2011-07-05T09:08:10Z     TIB
{% endhighlight %}


### `ListIdentifiers` is an abbreviated form of `ListRecords`, retrieving only headers rather than records.

{% highlight r linenos %}
# Single provider
md_listidentifiers(provider = "datacite", set = "REFQUALITY")[[1]][1:10]
{% endhighlight %}



{% highlight text %}
[1] "oai:oai.datacite.org:32426" "oai:oai.datacite.org:32152"
[3] "oai:oai.datacite.org:25453" "oai:oai.datacite.org:25452"
[5] "oai:oai.datacite.org:25451" "oai:oai.datacite.org:25450"
[7] "oai:oai.datacite.org:25449" "oai:oai.datacite.org:25407"
[9] "oai:oai.datacite.org:48328" "oai:oai.datacite.org:48439"
{% endhighlight %}



{% highlight r linenos %}
md_listidentifiers(provider = "dryad", from = "2012-07-15")[[1]][1:10]
{% endhighlight %}



{% highlight text %}
[1] "oai:datadryad.org:10255/dryad.9106"
[2] "oai:datadryad.org:10255/dryad.33780"
[3] "oai:datadryad.org:10255/dryad.33901"
[4] "oai:datadryad.org:10255/dryad.33902"
[5] "oai:datadryad.org:10255/dryad.34472"
[6] "oai:datadryad.org:10255/dryad.34558"
[7] "oai:datadryad.org:10255/dryad.39975"
[8] "oai:datadryad.org:10255/dryad.35065"
[9] "oai:datadryad.org:10255/dryad.35081"
[10] "oai:datadryad.org:10255/dryad.35082"
{% endhighlight %}



{% highlight r linenos %}

# Many providers
out <- md_listidentifiers(provider = c("datacite", "pensoft"), from = "2012-08-21")
llply(out, function(x) x[1:10])  # display just a few of them
{% endhighlight %}



{% highlight text %}
[[1]]
[1] "oai:oai.datacite.org:1099317" "oai:oai.datacite.org:1099572"
[3] "oai:oai.datacite.org:1099824" "oai:oai.datacite.org:1099695"
[5] "oai:oai.datacite.org:1088239" "oai:oai.datacite.org:1088122"
[7] "oai:oai.datacite.org:1088190" "oai:oai.datacite.org:1175749"
[9] "oai:oai.datacite.org:1175288" "oai:oai.datacite.org:1115603"

[[2]]
[1] "10.3897/phytokeys.16.2884" "10.3897/phytokeys.16.3602"
[3] "10.3897/phytokeys.16.3186" "10.3897/zookeys.216.3407"
[5] "10.3897/zookeys.216.3332"  "10.3897/zookeys.216.3224"
[7] "10.3897/zookeys.216.3769"  "10.3897/zookeys.216.3360"
[9] "10.3897/zookeys.216.3646"  "10.3897/neobiota.14.3140"

{% endhighlight %}


### With `ListSets` you can retrieve the set structure of a repository.

{% highlight r linenos %}
# arXiv, returns a data.frame
head(md_listsets(provider = "arXiv")[[1]])
{% endhighlight %}



{% highlight text %}
           setName          setSpec
1   Computer Science               cs
2        Mathematics             math
3 Nonlinear Sciences             nlin
4            Physics          physics
5       Astrophysics physics:astro-ph
6   Condensed Matter physics:cond-mat
{% endhighlight %}



{% highlight r linenos %}

# many providers, returns a list
md_listsets(provider = c("pensoft", "arXiv"))
{% endhighlight %}



{% highlight text %}
[[1]]
                                setName            setSpec
1                                 ZooKeys            zookeys
2                                 BioRisk            biorisk
3                               PhytoKeys          phytokeys
4                                NeoBiota           neobiota
5         Journal of Hymenoptera Research                jhr
6  International Journal of Myriapodology                ijm
7                Comparative Cytogenetics        compcytogen
8                    Subterranean Biology           subtbiol
9                     Nature Conservation natureconservation
10                               MycoKeys           mycokeys

[[2]]
                                  setName          setSpec
1                          Computer Science               cs
2                               Mathematics             math
3                        Nonlinear Sciences             nlin
4                                   Physics          physics
5                              Astrophysics physics:astro-ph
6                          Condensed Matter physics:cond-mat
7  General Relativity and Quantum Cosmology    physics:gr-qc
8          High Energy Physics - Experiment   physics:hep-ex
9             High Energy Physics - Lattice  physics:hep-lat
10      High Energy Physics - Phenomenology   physics:hep-ph
11             High Energy Physics - Theory   physics:hep-th
12                     Mathematical Physics  physics:math-ph
13                       Nuclear Experiment  physics:nucl-ex
14                           Nuclear Theory  physics:nucl-th
15                          Physics (Other)  physics:physics
16                          Quantum Physics physics:quant-ph
17                     Quantitative Biology            q-bio
18                     Quantitative Finance            q-fin
19                               Statistics             stat

{% endhighlight %}


### Retrieve an individual metadata record from a repository using the `GetRecord` verb.

{% highlight r linenos %}
# Single provider, one identifier
md_getrecord(provider = "pensoft", identifier = "10.3897/zookeys.1.10")
{% endhighlight %}



{% highlight text %}
          identifier  datestamp
1 10.3897/zookeys.1.10 2008-07-04
                                                                                           dc.title
1 A new candidate for a Gondwanaland distribution in the Zodariidae (Araneae): Australutica in Africa
 dc.creator  dc.subject dc.subject.1 dc.subject.2 dc.subject.3
1 Jocqué,Rudy new species Gondwanaland Soutpansberg      Araneae
       dc.source
1 ZooKeys 1: 59-66
                                                                                                                                                                                                                                                                                                                   dc.description
1 Two new species of Australutica Jocqué, 1995, a genus formerly only known from Australia, are described from South Africa: A. africana n. sp. from Soutpansberg and A. normanlarseni n. sp. from the Cape Peninsula. The taxonomic position of the new species is discussed and a key to the species of Australutica is provided.
      dc.publisher dc.date          dc.type dc.format
1 Pensoft Publishers    2008 Research Article text/html
                         dc.identifier
1 http://dx.doi.org/10.3897/zookeys.1.10
                                    dc.identifier.1 dc.language
1 http://www.pensoft.net/journals/zookeys/article/10/          en
                                                                                 dc..attrs
1 http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd
{% endhighlight %}



{% highlight r linenos %}

# Single provider, multiple identifiers
md_getrecord(provider = "pensoft", identifier = c("10.3897/zookeys.1.10", "10.3897/zookeys.4.57"))
{% endhighlight %}



{% highlight text %}
          identifier  datestamp
1 10.3897/zookeys.1.10 2008-07-04
2 10.3897/zookeys.4.57 2008-12-17
                                                                                              dc.title
1    A new candidate for a Gondwanaland distribution in the Zodariidae (Araneae): Australutica in Africa
2 Studies of Tiger Beetles. CLXXVIII. A new Lophyra (Lophyra) from Somaliland (Coleoptera, Cicindelidae)
   dc.creator    dc.subject dc.subject.1 dc.subject.2 dc.subject.3
1   Jocqué,Rudy   new species Gondwanaland Soutpansberg      Araneae
2 Cassola,Fabio Tiger Beetles Cicindelidae      Lophyra   Somaliland
       dc.source
1 ZooKeys 1: 59-66
2 ZooKeys 4: 65-69
                                                                                                                                                                                                                                                                                                                                                                                                                 dc.description
1                                                                                               Two new species of Australutica Jocqué, 1995, a genus formerly only known from Australia, are described from South Africa: A. africana n. sp. from Soutpansberg and A. normanlarseni n. sp. from the Cape Peninsula. The taxonomic position of the new species is discussed and a key to the species of Australutica is provided.
2 A new tiger beetle species, Lophyra (Lophyra) praetermissa n. sp. (Coleoptera, Cicindelidae), obviously a close relative of L. (L.) histrio (Tschitschérine, 1903), is described from the environs of Erigavo, Somaliland (northern Somalia). Its discovery thus brings up to 73 the number of the species of this genus presently known worldwide (39 species of which - 29 from Africa - belong to the typonominal subgenus).
      dc.publisher dc.date          dc.type dc.format
1 Pensoft Publishers    2008 Research Article text/html
2 Pensoft Publishers    2008 Research Article text/html
                         dc.identifier
1 http://dx.doi.org/10.3897/zookeys.1.10
2 http://dx.doi.org/10.3897/zookeys.4.57
                                    dc.identifier.1 dc.language
1 http://www.pensoft.net/journals/zookeys/article/10/          en
2 http://www.pensoft.net/journals/zookeys/article/57/          en
                                                                                 dc..attrs
1 http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd
2 http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd
{% endhighlight %}


Cool, so I hope people find this post and package useful.  Let me know what you think in comments below, or if you have code specific comments or additions, go to [the GitHub repo for `rmetadata`](https://github.com/ropensci/rmetadata).  In a upcoming post I will show an example  of what you can do with `rmetadata` in terms of an actual research question.

*********
#### Get the .Rmd file used to create this post [at my github account](https://github.com/sckott/sckott.github.com/tree/master/_drafts/2012-09-15-rmetadata.Rmd) - or [.md file](https://github.com/sckott/sckott.github.com/tree/master/_posts/2012-09-17-rmetadata.md).

#### Written in [Markdown](http://daringfireball.net/projects/markdown/), with help from [knitr](http://yihui.name/knitr/), and nice knitr highlighting/etc. in in [RStudio](http://rstudio.org/).
