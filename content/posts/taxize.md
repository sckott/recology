---
name: taxize
layout: post
title: One R package for all your taxonomic needs
date: 2012-12-06
author: Scott Chamberlain
sourceslug: _drafts/2012-12-06-taxize.Rmd
tags: 
- R
- open source
- data
- taxonomy
- ropensci
- ritis
- taxize
---

> UPDATE: there were some errors in the tests for `taxize`, so the binaries aren't avaiable yet. You can install from source though, see below. 


Getting taxonomic information for the set of species you are studying can be a pain in the ass. You have to manually type, or paste in, your species one-by-one. Or, if you are lucky, there is a web service in which you can upload a list of species. Encyclopedia of Life (EOL) has a service where you can do this [here](http://gni.globalnames.org/parsers/new). But is this reproducible? No. 

Getting your taxonomic information for your species can now be done programatically in R. Do you want to get taxonomic information from ITIS. We got that. Tropicos? We got that too. uBio? No worries, we got that. What about theplantlist.org? Yep, got that. Encyclopedia of Life? Indeed. What about getting sequence data for a taxon? Oh hell yeah, you can get sequences available for a taxon across all genes, or get all records for a taxon for a specific gene. 

Of course this is all possible because these data providers have open APIs so that we can facilitate your computer talking to their database. Fun! 

Why get your taxonomic data programatically? Because it's 1) faster than by hand in web sites/looking up in books, 2) reproducible, especially if you share your code (damnit!), and 3) you can easily mash up your new taxonomic data to get sequences to build a phylogeny, etc.

I'll give a few examples of using `taxize` based around use cases, that is, stuff someone might actually do instead of what particular functions do.

***************

### Install packages.  You can get from CRAN or GitHub.

```r
# install.packages("ritis") # uncomment if not already installed
# install_github('taxize_', 'ropensci') # uncomment if not already installed
# install.packages("taxize", type="source") # uncomment if not already installed
library(ritis)
library(taxize)
```


***************

### Attach family names to a list of species.

#### I often have a list of species that I studied and simply want to get their family names to, for example, make a table for the paper I'm writing.

```r
# For one species
itis_name(query = "Poa annua", get = "family")
```



```r
Retrieving data for species ' Poa annua '
```



```r
[1] "Poaceae"
```



```r

# For many species
species <- c("Poa annua", "Abies procera", "Helianthus annuus", "Coffea arabica")
famnames <- sapply(species, itis_name, get = "family", USE.NAMES = F)
```



```r

Retrieving data for species ' Poa annua '
```



```r

Retrieving data for species ' Abies procera '
```



```r

Retrieving data for species ' Helianthus annuus '
```



```r

Retrieving data for species ' Coffea arabica '
```



```r
data.frame(species = species, family = famnames)
```



```r
            species     family
1         Poa annua    Poaceae
2     Abies procera   Pinaceae
3 Helianthus annuus Asteraceae
4    Coffea arabica  Rubiaceae
```


***************

### Resolve taxonomic names.

#### This is a common use case for ecologists/evolutionary biologists, or at least should be. That is, species names you have for your own data, or when using other's data, could be old names - and if you need the newest names for your species list, how can you make this as painless as possible? You can query taxonomic data from many different sources with `taxize`.

```r
# The iPlantCollaborative provides access via API to their taxonomic name
# resolution service (TNRS)
mynames <- c("shorea robusta", "pandanus patina", "oryza sativa", "durio zibethinus", 
    "rubus ulmifolius", "asclepias curassavica", "pistacia lentiscus")
iplant_tnrsmatch(retrieve = "all", taxnames = c("helianthus annuus", "acacia", 
    "gossypium"), output = "names")
```



```r
       AcceptedName   MatchFam MatchGenus MatchScore    Accept?
1 Helianthus annuus Asteraceae Helianthus          1 No opinion
2            Acacia   Fabaceae     Acacia          1 No opinion
3                                  Acacia          1 No opinion
4         Gossypium  Malvaceae  Gossypium          1 No opinion
     SubmittedNames
1 helianthus annuus
2            acacia
3            acacia
4         gossypium
```



```r

# The global names resolver is another attempt at this, hitting many
# different data sources
gnr_resolve(names = c("Helianthus annuus", "Homo sapiens"), returndf = TRUE)
```



```r
   data_source_id    submitted_name       name_string score
1               4 Helianthus annuus Helianthus annuus 0.988
3              10 Helianthus annuus Helianthus annuus 0.988
5              12 Helianthus annuus Helianthus annuus 0.988
8             110 Helianthus annuus Helianthus annuus 0.988
11            159 Helianthus annuus Helianthus annuus 0.988
13            166 Helianthus annuus Helianthus annuus 0.988
15            169 Helianthus annuus Helianthus annuus 0.988
2               4      Homo sapiens      Homo sapiens 0.988
4              10      Homo sapiens      Homo sapiens 0.988
6              12      Homo sapiens      Homo sapiens 0.988
7             107      Homo sapiens      Homo sapiens 0.988
9             122      Homo sapiens      Homo sapiens 0.988
10            123      Homo sapiens      Homo sapiens 0.988
12            159      Homo sapiens      Homo sapiens 0.988
14            168      Homo sapiens      Homo sapiens 0.988
16            169      Homo sapiens      Homo sapiens 0.988
                     title
1                     NCBI
3                 Freebase
5                      EOL
8     Illinois Wildflowers
11                 CU*STAR
13                   nlbif
15           uBio NameBank
2                     NCBI
4                 Freebase
6                      EOL
7                AskNature
9                 BioPedia
10                   AnAge
12                 CU*STAR
14 Index to Organism Names
16           uBio NameBank
```



```r

# We can hit the Plantminer API too
plants <- c("Myrcia lingua", "Myrcia bella", "Ocotea pulchella", "Miconia", 
    "Coffea arabica var. amarella", "Bleh")
plantminer(plants)
```



```r
Myrcia lingua 
Myrcia bella 
Ocotea pulchella 
Miconia 
Coffea arabica var. amarella 
Bleh 
```



```r
              fam   genus                    sp             author
1       Myrtaceae  Myrcia                lingua   (O. Berg) Mattos
2       Myrtaceae  Myrcia                 bella           Cambess.
3       Lauraceae  Ocotea             pulchella (Nees & Mart.) Mez
4 Melastomataceae Miconia                    NA        Ruiz & Pav.
5       Rubiaceae  Coffea arabica var. amarella        A. Froehner
6              NA    Bleh                    NA                 NA
            source source.id   status confidence suggestion       database
1              TRO 100227036       NA         NA         NA       Tropicos
2             WCSP    131057 Accepted          H         NA The Plant List
3 WCSP (in review)    989758 Accepted          M         NA The Plant List
4              TRO  40018467       NA         NA         NA       Tropicos
5              TRO 100170231       NA         NA         NA       Tropicos
6               NA        NA       NA         NA       Baea             NA
```



```r

# We made a light wrapper around the Taxonstand package to search
# Theplantlist.org too
splist <- c("Heliathus annuus", "Abies procera", "Poa annua", "Platanus occidentalis", 
    "Carex abrupta", "Arctostaphylos canescens", "Ocimum basilicum", "Vicia faba", 
    "Quercus kelloggii", "Lactuca serriola")
tpl_search(taxon = splist)
```



```r
            Genus      Species Infraspecific Plant.Name.Index
1       Heliathus       annuus                          FALSE
2           Abies      procera                           TRUE
3             Poa        annua                           TRUE
4        Platanus occidentalis                           TRUE
5           Carex      abrupta                           TRUE
6  Arctostaphylos    canescens                           TRUE
7          Ocimum    basilicum                           TRUE
8           Vicia         faba                           TRUE
9         Quercus    kelloggii                           TRUE
10        Lactuca     serriola                           TRUE
   Taxonomic.status      Family      New.Genus  New.Species
1                                    Heliathus       annuus
2          Accepted    Pinaceae          Abies      procera
3          Accepted     Poaceae            Poa        annua
4          Accepted Platanaceae       Platanus occidentalis
5          Accepted  Cyperaceae          Carex      abrupta
6          Accepted   Ericaceae Arctostaphylos    canescens
7          Accepted   Lamiaceae         Ocimum    basilicum
8          Accepted Leguminosae          Vicia         faba
9          Accepted    Fagaceae        Quercus    kelloggii
10         Accepted  Compositae        Lactuca     serriola
   New.Infraspecific Authority  Typo WFormat
1                              FALSE   FALSE
2                       Rehder FALSE   FALSE
3                           L. FALSE   FALSE
4                           L. FALSE   FALSE
5               <NA>     Mack. FALSE   FALSE
6                       Eastw. FALSE   FALSE
7                           L. FALSE   FALSE
8                           L. FALSE   FALSE
9               <NA>     Newb. FALSE   FALSE
10                          L. FALSE   FALSE
```


***************

### Taxonomic hierarchies

#### I often want the full taxonomic hierarchy for a set of species. That is, give me the family, order, class, etc. for my list of species. There are two different easy ways to do this with `taxize`. The first example uses EOL.

***************

#### Using EOL.

```r
pageid <- eol_search("Quercus douglasii")$id[1]  # first need to search for the taxon's page on EOL
out <- eol_pages(taxonconceptID = pageid)  # then we nee to get the taxon ID used by EOL

# Notice that there are multiple different sources you can pull the
# hierarchy from. Note even that you can get the hierarchy from the ITIS
# service via this EOL API.
out
```



```r
  identifier                 scientificName
1   46203061 Quercus douglasii Hook. & Arn.
2   48373995 Quercus douglasii Hook. & Arn.
                                  nameAccordingTo sourceIdentfier
1  Integrated Taxonomic Information System (ITIS)           19322
2 Species 2000 & ITIS Catalogue of Life: May 2012         9723391
  taxonRank
1   Species
2   Species
```



```r

# Then the hierarchy!
eol_hierarchy(out[out$nameAccordingTo == "Species 2000 & ITIS Catalogue of Life: May 2012", 
    "identifier"])
```



```r
  sourceIdentifier  taxonID parentNameUsageID taxonConceptID
1         11017504 48276627                 0            281
2         11017505 48276628          48276627            282
3         11017506 48276629          48276628            283
4         11022500 48373354          48276629           4184
5         11025284 48373677          48373354           4197
  scientificName taxonRank
1        Plantae   kingdom
2  Magnoliophyta    phylum
3  Magnoliopsida     class
4        Fagales     order
5       Fagaceae    family
```



```r
eol_hierarchy(out[out$nameAccordingTo == "Integrated Taxonomic Information System (ITIS)", 
    "identifier"])  # and from ITIS, slightly different than ITIS output below, which includes taxa all the way down.
```



```r
   sourceIdentifier  taxonID parentNameUsageID taxonConceptID
1            202422 46150613                 0            281
2            846492 46159776          46150613        8654492
3            846494 46161961          46159776       28818077
4            846496 46167532          46161961           4494
5            846504 46169010          46167532       28825126
6            846505 46169011          46169010            282
7             18063 46169012          46169011            283
8            846548 46202954          46169012       28859070
9             19273 46202955          46202954           4184
10            19275 46203022          46202955           4197
    scientificName     taxonRank
1          Plantae       kingdom
2   Viridaeplantae    subkingdom
3     Streptophyta  infrakingdom
4     Tracheophyta      division
5  Spermatophytina   subdivision
6     Angiospermae infradivision
7    Magnoliopsida         class
8          Rosanae    superorder
9          Fagales         order
10        Fagaceae        family
```


***************

#### And getting a taxonomic hierarchy using ITIS.

```r
# First, get the taxonomic serial number (TSN) that ITIS uses
mytsn <- get_tsn("Quercus douglasii", "sciname")
```



```r

Retrieving data for species ' Quercus douglasii '
```



```r

# Get the full taxonomic hierarchy for a taxon from the TSN
itis(mytsn, "getfullhierarchyfromtsn")
```



```r
$`1`
        parentName parentTsn      rankName         taxonName    tsn
1                                  Kingdom           Plantae 202422
2          Plantae    202422    Subkingdom    Viridaeplantae 846492
3   Viridaeplantae    846492  Infrakingdom      Streptophyta 846494
4     Streptophyta    846494      Division      Tracheophyta 846496
5     Tracheophyta    846496   Subdivision   Spermatophytina 846504
6  Spermatophytina    846504 Infradivision      Angiospermae 846505
7     Angiospermae    846505         Class     Magnoliopsida  18063
8    Magnoliopsida     18063    Superorder           Rosanae 846548
9          Rosanae    846548         Order           Fagales  19273
10         Fagales     19273        Family          Fagaceae  19275
11        Fagaceae     19275         Genus           Quercus  19276
12         Quercus     19276       Species Quercus douglasii  19322

```



```r

# But this can be even easier!
classification(get_tsn("Quercus douglasii"))  # Boom!
```



```r

Retrieving data for species ' Quercus douglasii '
```



```r
$`1`
        parentName parentTsn      rankName         taxonName    tsn
1                                  Kingdom           Plantae 202422
2          Plantae    202422    Subkingdom    Viridaeplantae 846492
3   Viridaeplantae    846492  Infrakingdom      Streptophyta 846494
4     Streptophyta    846494      Division      Tracheophyta 846496
5     Tracheophyta    846496   Subdivision   Spermatophytina 846504
6  Spermatophytina    846504 Infradivision      Angiospermae 846505
7     Angiospermae    846505         Class     Magnoliopsida  18063
8    Magnoliopsida     18063    Superorder           Rosanae 846548
9          Rosanae    846548         Order           Fagales  19273
10         Fagales     19273        Family          Fagaceae  19275
11        Fagaceae     19275         Genus           Quercus  19276
12         Quercus     19276       Species Quercus douglasii  19322

```



```r

# You can also do this easy-peasy route to a taxonomic hierarchy using
# uBio
classification(get_uid("Ornithorhynchus anatinus"))
```



```r
$`1`
       ScientificName         Rank    UID
1  cellular organisms      no rank 131567
2           Eukaryota superkingdom   2759
3        Opisthokonta      no rank  33154
4             Metazoa      kingdom  33208
5           Eumetazoa      no rank   6072
6           Bilateria      no rank  33213
7           Coelomata      no rank  33316
8       Deuterostomia      no rank  33511
9            Chordata       phylum   7711
10           Craniata    subphylum  89593
11         Vertebrata      no rank   7742
12      Gnathostomata   superclass   7776
13         Teleostomi      no rank 117570
14       Euteleostomi      no rank 117571
15      Sarcopterygii      no rank   8287
16          Tetrapoda      no rank  32523
17            Amniota      no rank  32524
18           Mammalia        class  40674
19        Prototheria      no rank   9254
20        Monotremata        order   9255
21  Ornithorhynchidae       family   9256
22    Ornithorhynchus        genus   9257

```


***************

### Sequences?

#### While you are at doing taxonomic stuff, you often wonder "hmmm, I wonder if there are any sequence data available for my species?" So, you can use `get_seqs` to search for specific genes for a species, and `get_genes_avail` to find out what genes are available for a certain species. These functions search for data on [NCBI](http://www.ncbi.nlm.nih.gov/).

```r
# Get sequences (sequence is provied in output, but hiding here for
# brevity). What's nice about this is that it gets the longest sequence
# avaialable for the gene you searched for, and if there isn't anything
# available, it lets you get a sequence from a congener if you set
# getrelated=TRUE. The last column in the output data.frame also tells you
# what species the sequence is from.
out <- get_seqs(taxon_name = "Acipenser brevirostrum", gene = c("5S rRNA"), 
    seqrange = "1:3000", getrelated = T, writetodf = F)
out[, !names(out) %in% "sequence"]
```



```r
                   taxon                                         gene_desc
1 Acipenser brevirostrum Acipenser brevirostrum 5S rRNA gene, clone BRE92A
     gi_no     acc_no length                 spused
1 60417159 AJ745069.1    121 Acipenser brevirostrum
```



```r

# Search for available sequences
out <- get_genes_avail(taxon_name = "Umbra limi", seqrange = "1:2000", getrelated = F)
out[grep("RAG1", out$genesavail, ignore.case = T), ]  # does the string 'RAG1' exist in any of the gene names
```



```r
        spused length
414 Umbra limi    732
427 Umbra limi    959
434 Umbra limi   1631
                                                                            genesavail
414 isolate UlimA recombinase activating protein 1 (rag1) gene, exon 3 and partial cds
427           recombination-activating protein 1 (RAG1) gene, intron 2 and partial cds
434                        recombination-activating protein 1 (RAG1) gene, partial cds
    predicted
414  JX190826
427  AY459526
434  AY380548
```



---
Get the .Rmd file used to create this post [at my github account](https://github.com/sckott/sckott.github.com/tree/master/_drafts/2012-12-06-taxize.Rmd) - or [.md file](https://github.com/sckott/sckott.github.com/tree/master/_posts/2012-12-06-taxize.md).

Written in [Markdown](http://daringfireball.net/projects/markdown/), with help from [knitr](http://yihui.name/knitr/).
