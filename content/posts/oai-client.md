---
name: oai-client
layout: post
title: oai - an OAI-PMH client
date: 2015-09-11
author: Scott Chamberlain
sourceslug: _drafts/2015-09-11-oai-client.Rmd
tags:
- literature
- metadata
- datasets
- R
---



`oai` is a general purpose client to work with any 'OAI-PMH' service. The 'OAI-PMH' protocol is described at <https://www.openarchives.org/OAI/openarchivesprotocol.html>. The main functions follow the OAI-PMH verbs: 

* `GetRecord`
* `Identify`
* `ListIdentifiers`
* `ListMetadataFormats`
* `ListRecords`
* `ListSets`

The repo is at <https://github.com/sckott/oai>

I will be using this in a number of packages I maintain that use OAI-PMH data services. If you try it, let me know what you think. 

This package is heading to rOpenSci soon: <https://github.com/ropensci/onboarding/issues/19>

Here's a few usage examples:

## Install

Is on CRAN now, but binaries may not be available yet. 


```r
install.packages("oai")
```

Or install development version from GitHub


```r
devtools::install_github("sckott/oai")
```

Load `oai`


```r
library("oai")
```

## Identify


```r
id("https://oai.datacite.org/oai")
#>   repositoryName                     baseURL protocolVersion
#> 1   DataCite MDS https://oai.datacite.org/oai             2.0
#>           adminEmail    earliestDatestamp deletedRecord
#> 1 admin@datacite.org 2011-01-01T00:00:00Z    persistent
#>            granularity compression compression.1
#> 1 YYYY-MM-DDThh:mm:ssZ        gzip       deflate
#>                                      description
#> 1 oaioai.datacite.org:oai:oai.datacite.org:12425
```

## ListIdentifiers


```r
list_identifiers(from = '2011-05-01T', until = '2011-09-01T')
#> <ListRecords> 925 X 6 
#> 
#>                    identifier            datestamp setSpec setSpec.1
#> 1  oai:oai.datacite.org:32153 2011-06-08T08:57:11Z     TIB  TIB.WDCC
#> 2  oai:oai.datacite.org:32200 2011-06-20T08:12:41Z     TIB TIB.DAGST
#> 3  oai:oai.datacite.org:32220 2011-06-28T14:11:08Z     TIB TIB.DAGST
#> 4  oai:oai.datacite.org:32241 2011-06-30T13:24:45Z     TIB TIB.DAGST
#> 5  oai:oai.datacite.org:32255 2011-07-01T12:09:24Z     TIB TIB.DAGST
#> 6  oai:oai.datacite.org:32282 2011-07-05T09:08:10Z     TIB TIB.DAGST
#> 7  oai:oai.datacite.org:32309 2011-07-06T12:30:54Z     TIB TIB.DAGST
#> 8  oai:oai.datacite.org:32310 2011-07-06T12:42:32Z     TIB TIB.DAGST
#> 9  oai:oai.datacite.org:32325 2011-07-07T11:17:46Z     TIB TIB.DAGST
#> 10 oai:oai.datacite.org:32326 2011-07-07T11:18:47Z     TIB TIB.DAGST
#> ..                        ...                  ...     ...       ...
#> Variables not shown: setSpec.2 (chr), setSpec.3 (chr)
```

## Count Identifiers


```r
count_identifiers()
#>                           url   count
#> 1 https://oai.datacite.org/oai 6350706
```

## ListRecords


```r
list_records(from = '2011-05-01T', until = '2011-08-15T')
#> <ListRecords> 126 X 46 
#> 
#>                    identifier            datestamp setSpec setSpec.1
#> 1  oai:oai.datacite.org:32153 2011-06-08T08:57:11Z     TIB  TIB.WDCC
#> 2  oai:oai.datacite.org:32200 2011-06-20T08:12:41Z     TIB TIB.DAGST
#> 3  oai:oai.datacite.org:32220 2011-06-28T14:11:08Z     TIB TIB.DAGST
#> 4  oai:oai.datacite.org:32241 2011-06-30T13:24:45Z     TIB TIB.DAGST
#> 5  oai:oai.datacite.org:32255 2011-07-01T12:09:24Z     TIB TIB.DAGST
#> 6  oai:oai.datacite.org:32282 2011-07-05T09:08:10Z     TIB TIB.DAGST
#> 7  oai:oai.datacite.org:32309 2011-07-06T12:30:54Z     TIB TIB.DAGST
#> 8  oai:oai.datacite.org:32310 2011-07-06T12:42:32Z     TIB TIB.DAGST
#> 9  oai:oai.datacite.org:32325 2011-07-07T11:17:46Z     TIB TIB.DAGST
#> 10 oai:oai.datacite.org:32326 2011-07-07T11:18:47Z     TIB TIB.DAGST
#> ..                        ...                  ...     ...       ...
#> Variables not shown: title (chr), creator (chr), creator.1 (chr),
#>      creator.2 (chr), creator.3 (chr), creator.4 (chr), creator.5 (chr),
#>      creator.6 (chr), creator.7 (chr), publisher (chr), date (chr),
#>      identifier.2 (chr), identifier.1 (chr), subject (chr), description
#>      (chr), description.1 (chr), contributor (chr), language (chr), type
#>      (chr), type.1 (chr), format (chr), format.1 (chr), rights (chr),
#>      subject.1 (chr), relation (chr), subject.2 (chr), subject.3 (chr),
#>      subject.4 (chr), setSpec.2 (chr), setSpec.3 (chr), format.2 (chr),
#>      subject.5 (chr), subject.6 (chr), subject.7 (chr), description.2
#>      (chr), description.3 (chr), description.4 (chr), description.5 (chr),
#>      title.1 (chr), relation.1 (chr), relation.2 (chr), contributor.1
#>      (chr)
```

## GetRecords


```r
get_records(c("oai:oai.datacite.org:32255", "oai:oai.datacite.org:32325"))
#> <GetRecord> 2 X 23 
#> 
#>                   identifier            datestamp setSpec setSpec.1
#> 1 oai:oai.datacite.org:32255 2011-07-01T12:09:24Z     TIB TIB.DAGST
#> 2 oai:oai.datacite.org:32325 2011-07-07T11:17:46Z     TIB TIB.DAGST
#> Variables not shown: title (chr), creator (chr), creator.1 (chr),
#>      creator.2 (chr), creator.3 (chr), publisher (chr), date (chr),
#>      identifier.1 (chr), subject (chr), subject.1 (chr), description
#>      (chr), description.1 (chr), contributor (chr), language (chr), type
#>      (chr), type.1 (chr), format (chr), format.1 (chr), rights (chr)
```

## List MetadataFormats


```r
list_metadataformats(id = "oai:oai.datacite.org:32348")
#> $`oai:oai.datacite.org:32348`
#>   metadataPrefix
#> 1         oai_dc
#> 2       datacite
#> 3   oai_datacite
#>                                                        schema
#> 1              https://www.openarchives.org/OAI/2.0/oai_dc.xsd
#> 2 https://schema.datacite.org/meta/nonexistant/nonexistant.xsd
#> 3              https://schema.datacite.org/oai/oai-1.0/oai.xsd
#>                             metadataNamespace
#> 1 https://www.openarchives.org/OAI/2.0/oai_dc/
#> 2      https://datacite.org/schema/nonexistant
#> 3     https://schema.datacite.org/oai/oai-1.0/
```

## List Sets


```r
list_sets("https://oai.datacite.org/oai")
#> <ListSets> 1227 X 2 
#> 
#>                     setSpec
#> 1                REFQUALITY
#> 2                      ANDS
#> 3           ANDS.REFQUALITY
#> 4             ANDS.CENTRE-1
#> 5  ANDS.CENTRE-1.REFQUALITY
#> 6             ANDS.CENTRE-2
#> 7  ANDS.CENTRE-2.REFQUALITY
#> 8             ANDS.CENTRE-3
#> 9  ANDS.CENTRE-3.REFQUALITY
#> 10            ANDS.CENTRE-5
#> ..                      ...
#> Variables not shown: setName (chr)
```
