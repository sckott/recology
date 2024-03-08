---
name: taxizedb-update
layout: post
title: "taxizedb: an update"
date: 2020-08-17
author: Scott Chamberlain
sourceslug: _drafts/2020-08-17-taxizedb-update.Rmd
tags:
- R
- taxonomy
- database
---




[taxizedb][] arose from pain in using [taxize][] when dealing with large amounts of data in a single request or doing a lot of requests of any data size. [taxize][] works with remote data sources on the web, so there's a number of issues that can slow the response down: internet speed, server response speed (was a response already cached or not; or do they even use caching), etc.

The idea with [taxizedb][] was to allow users to do the same things as taxize allows, but much faster by accessing the entire database for a data source on their own computer. The previous versions of taxizedb used a variety of different databases (MySQL/MariaDB, PostgreSQL, SQLite), so the technical barrier to entry was pretty high. In the newest version just released, we've drastically simplified the database situation, among other things.

[taxadb][] was developed as an alternative approach to taxizedb and should also be considered when dealing with taxonomic names. It takes a different approach for the data, with tabular files hosted on GitHub releases, but is similar in that after downloading the data is put into a SQL database, SQLite by default (with other options for databases). taxadb user facing functions are different from those in taxizedb, and largely don't overlap. 

taxizedb quick links:

- [taxizedb repo][taxizedb]
- [taxizedb on cran](https://cloud.r-project.org/web/packages/taxizedb/)
- [taxizedb docs][docs]

Install the latest version, if you don't get `v0.2.0` with


```r
install.packages("taxizedb")
```

then use


```r
install.packages("taxizedb", repos = "https://dev.ropensci.org")
```

Load the package


```r
library(taxizedb)
```

<br>

## All SQLite!

SQLite is shipped in nearly every device these days, so taxizedb now uses only SQLite for the database backend for each data source. Every person that installs taxizedb should have SQLite already installed. In addition, there's no usernames/passwords/ports to setup with. How we've accomplished this is partly through automation:

- NCBI: SQLite built within R from tabular files
- ITIS: they provide a SQLite dump
- Plantlist: is no longer updated; we build a SQLite manually from csv files
- COL: a SQLite is built once a day via GitHub Actions
- GBIF: a SQLite is built once a day via GitHub Actions
- Wikidata: SQLite built within R from a tabular file
- World Flora Online: SQLite built within R from a tabular file

Some of the databases have indices to speed up queries, making them a bit larger relative to no indices, but these days most people likely are willing to use up a little more disk space on their computer to have faster queries. 

<br>

## New data sources

Three new data sources were added:

- [NCBI taxonomy](https://www.ncbi.nlm.nih.gov/taxonomy) - all of this work was done by [Zebulun Arendsee](https://github.com/arendsee)
- [World Flora Online](https://www.worldfloraonline.org/) - the replacement for The Plant List
- [Wikidata](https://zenodo.org/record/1213477) - the table `wikidata-taxon-info`, extracted taxon objects from Wikidata, last updated April 2018, on Zenodo

<br>

## New functions: taxize equivalents

Three new high level functions matching those in taxize were added: `children`, `classification`, `downstream`. The taxize version of those functions are still good for smaller requests, but with larger requests, its probably best to use taxizedb. The most common problem where taxize becomes frustrating is with `downstream` where a user wants all species within a high taxonomic rank like phylum. The original work for these functions was done by [Zebulun Arendsee](https://github.com/arendsee).

Here's a comparison of taxize vs. taxizedb with `downstream` - getting all species within the genus _Bombus_ (bumble bees)


```r
id_tx <- taxize::get_tsn("Bombus")
system.time(taxize::downstream(id_tx, db = "itis", downto = "species"))
#>    user  system elapsed 
#>   2.144   0.130  20.533

id_txdb <- taxizedb::name2taxid('Bombus', db = "itis")
system.time(taxizedb::downstream(id_txdb, db = "itis", downto = "species"))
#>    user  system elapsed 
#>   0.132   0.051   0.186
```

<br>

In addition, three new "mapping" functions were added that are similar to those in taxize, but with different names: `name2taxid` (scientific or common name to taxonomy ID); `taxid2name` (taxonomy ID to scientific name); `taxid2rank` (taxonomy ID to rank). 

We saw `name2taxid` above. Below we get the taxonomic ID for COL, ITIS and GBIF for _Bombus_


```r
name2taxid('Bombus', db = "col")
#> [1] "3993765"
name2taxid('Bombus', db = "itis")
#> [1] "154397"
name2taxid('Bombus', db = "gbif")
#> [1] "1340278"
```

Get the scientific name from a taxonomic ID


```r
taxid2name(3993765, db = "col")
#> [1] "Bombus"
taxid2rank(3993765, db = "col")
#> [1] "genus"
```

These functions are quite fast too:


```r
x <- taxize::names_list(rank = "species", size = 10000L)
system.time(name2taxid(x, db = "gbif", out_type = "summary"))
#>    user  system elapsed 
#>   0.096   0.206   1.053
```

<br>

## Thoughts?

Get in touch if you have any feedback at <https://github.com/ropensci/taxizedb/issues>



[taxizedb]: https://github.com/ropensci/taxizedb
[taxize]: https://github.com/ropensci/taxize
[taxadb]: https://github.com/ropensci/taxadb
[docs]: https://ropensci.github.io/taxizedb/

