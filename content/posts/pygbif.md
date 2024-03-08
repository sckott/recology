---
name: pygbif
layout: post
title: pygbif - GBIF client for Python
date: 2015-11-12
author: Scott Chamberlain
sourceslug: _drafts/2015-11-12-pygbif.Rmd
tags:
- python
- GBIF
- biodiversity
- macroecology
---

I maintain an R client for the GBIF API, at [rgbif][rgbif]. Been working on it for a few years, and recently been thinking that there should be a nice low level client for Python as well. I didn't see one searching Github, etc. so I started working on one recently: [pygbif][pygbif]

It's up on [pypi][pypi].

There's not much in `pygbif` yet - I wanted to get something up to start getting some users to more quickly make the library useful to people.

There's three modules, with a few methods each:

* species
    * `name_backbone()`
    * `name_suggest()`
* registry
    * `nodes()`
    * `dataset_metrics()`
    * `datasets()`
* occurrences
    * `search()`
    * `get()`
    * `get_verbatim()`
    * `get_fragment()`
    * `count()`
    * `count_basisofrecord()`
    * `count_year()`
    * `count_datasets()`
    * `count_countries()`
    * `count_publishingcountries()`
    * `count_schema()`

Here's a quick intro ([in a Jupyter notebook][notebook]):

### Install

```python3
pip install pygbif
```

### Registry/datasets

```python3
from pygbif import registry
registry.dataset_metrics(uuid='3f8a1297-3259-4700-91fc-acc4170b27ce')
```

```python3
{u'colCoveragePct': 79,
 u'colMatchingCount': 24335,
 u'countByConstituent': {},
 u'countByIssue': {u'BACKBONE_MATCH_FUZZY': 573,
  u'BACKBONE_MATCH_NONE': 1306,
  u'VERNACULAR_NAME_INVALID': 7777},
 u'countByKingdom': {u'ANIMALIA': 30,
  u'FUNGI': 3,
  u'INCERTAE_SEDIS': 26,
  u'PLANTAE': 10997,
  u'PROTOZOA': 1},
 ...
}
```

### Taxonomic names

```python3
from pygbif import species
species.name_suggest(q='Puma concolor', limit = 1)
```

```python3
{'data': [{u'canonicalName': u'Puma concolor',
   u'class': u'Mammalia',
   u'classKey': 359,
   u'family': u'Felidae',
   u'familyKey': 9703,
   u'genus': u'Puma',
   u'genusKey': 2435098,
   u'key': 2435099,
   u'kingdom': u'Animalia',
   u'kingdomKey': 1,
   u'nubKey': 2435099,
   u'order': u'Carnivora',
   u'orderKey': 732,
   u'parent': u'Puma',
   u'parentKey': 2435098,
   u'phylum': u'Chordata',
   u'phylumKey': 44,
   u'rank': u'SPECIES',
   u'species': u'Puma concolor',
   u'speciesKey': 2435099}],
 'hierarchy': [{u'1': u'Animalia',
   u'2435098': u'Puma',
   u'359': u'Mammalia',
   u'44': u'Chordata',
   u'732': u'Carnivora',
   u'9703': u'Felidae'}]}
```

### Occurrence data

Search

```python3
from pygbif import occurrences
res = occurrences.search(taxonKey = 3329049, limit = 10)
[ x['phylum'] for x in res['results'] ]
```

```python3
[u'Basidiomycota',
 u'Basidiomycota',
 u'Basidiomycota',
 u'Basidiomycota',
 u'Basidiomycota',
 u'Basidiomycota',
 u'Basidiomycota',
 u'Basidiomycota',
 u'Basidiomycota',
 u'Basidiomycota']
```

Fetch specific occurrences

```python3
occurrences.get(key = 252408386)
```

```python3
{u'basisOfRecord': u'OBSERVATION',
 u'catalogNumber': u'70875196',
 u'collectionCode': u'7472',
 u'continent': u'EUROPE',
 u'country': u'United Kingdom',
 u'countryCode': u'GB',
 u'datasetKey': u'26a49731-9457-45b2-9105-1b96063deb26',
 u'day': 30,
...
}
```

Occurrence counts API

```python3
occurrences.count(isGeoreferenced = True)
```

```python3
500283031
```

### feedback

Would love any feedback...

[rgbif]: https://github.com/ropensci/rgbif
[pygbif]: https://github.com/sckott/pygbif
[pypi]: https://pypi.python.org/pypi/pygbif/0.1.1
[notebook]: https://github.com/sckott/pygbif/blob/master/demos/pygbif-intro.ipynb
