---
name: gbifrb-release
layout: post
title: "gbifrb: Ruby client for the GBIF API"
date: 2017-09-07
author: Scott Chamberlain
sourceslug: _drafts/2017-09-07-gbifrb.Rmd
tags:
- ruby
- species
- occurrence
- maps
---



`gbifrb` is a new Ruby client for the [GBIF API][gbifapi].

* docs: <https://www.rubydoc.info/gems/gbifrb/>
* rubygems: <https://rubygems.org/gems/gbifrb>
* code: <https://github.com/sckott/gbifrb>

I maintain (w/ help) two other GBIF API clients:

- Python: [pygbif](https://github.com/sckott/pygbif)
- R: [rgbif](https://github.com/ropensci/rgbif)

## API

Here's the `gbifrb` methods in relation to [GBIF API][gbifapi] routes

registry

* `/node` - `Gbif::Registry.nodes`
* `/network` - `Gbif::Registry.networks`
* `/installations` - `Gbif::Registry.installations`
* `/organizations` - `Gbif::Registry.organizations`
* `/dataset_metrics` - `Gbif::Registry.dataset_metrics`
* `/datasets` - `Gbif::Registry.datasets`
* `/dataset_suggest` - `Gbif::Registry.dataset_suggest`
* `/dataset_search` - `Gbif::Registry.dataset_search`

species

* `/species/match` - `Gbif::Species.name_backbone`
* `/species/suggest` - `Gbif::Species.name_suggest`
* `/species/search` - `Gbif::Species.name_lookup`
* `/species` - `Gbif::Species.name_usage`

occurrences

* `/search` - `Gbif::Occurrences.search`
* `/get` - `Gbif::Occurrences.get`
* `/get_verbatim` - `Gbif::Occurrences.get_verbatim`
* `/get_fragment` - `Gbif::Occurrences.get_fragment`


## Install

```
gem install gbifrb
```

## Registry

Nodes

```ruby
require 'gbifrb'
registry = Gbif::Registry
registry.nodes(limit: 5)
```

Networks

```ruby
registry.networks(uuid: '16ab5405-6c94-4189-ac71-16ca3b753df7')
```

## Species

GBIF backbone

```ruby
species = Gbif::Species
species.name_backbone(name: "Helianthus")
```

Suggester

```ruby
species.name_suggest("Helianthus")
```

## Occurrences

```ruby
occ = Gbif::Occurrences
occ.search(taxonKey: 3329049)
occ.search(taxonKey: 3329049, limit: 2)
occ.search(scientificName: 'Ursus americanus')
```

## curl options

You can do verbose curl output by settin `verbiose: true`. See also the parameter `options`, passed on to `Faraday`

```ruby
species = Gbif::Species
species.name_backbone("Helianthus", verbose: true)
```

## Todo

Still need to work on the CLI interface, add occurrence metrics methods, add occurrence downloads methods, and add OAI-PMH interface methods.

## Feedback

Let me know what you think. Bugs. Featur requests. Etc.

[gbifapi]: https://www.gbif.org/developer/summary
[changelog]: https://github.com/sckott/gbifrb/blob/master/CHANGELOG.md
