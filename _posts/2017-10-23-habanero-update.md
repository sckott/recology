---
name: habanero-update
layout: post
title: "habanero update: Crossref data from Python"
date: 2017-10-23
author: Scott Chamberlain
sourceslug: _drafts/2017-10-23-working-with-crossref-clients.Rmd
tags:
- python
- ruby
- R
- javascript
- crossref
---

I wrote about Crossref clients back nearly two years ago on this blog: [Crossref programmatic clients](https://recology.info/2015/11/crossref-clients/).

Since it's been a while, it seems worth talking again about the the many ways to work programmatically with Crossref data - and focus in on the Python client `habanero` since it has some recent updates.

The 3 clients work with the main [Crossref API](http://api.crossref.org), which lets you do things like search for works by title, author, etc. (e.g., books, articles), search for publishing members, for funders, for journals, for DOI prefixes, and for licenses. It's a powerful API with basically no rate limits, so you can work through lots of data quickly.

Some deets:

* Crossref API documentation: <http://api.crossref.org>
* Python client `habanero`: <https://github.com/sckott/habanero>
* Ruby client `serrano`: <https://github.com/sckott/serrano>
* R client `rcrossref`: <https://github.com/ropensci/rcrossref>

At rOpenSci we've maintained the R client for quite a few years now, but the Python and Ruby clients were a result of consulting work I did for Crossref.

The R, Ruby, and Python clients are all quite feature complete, although software is never perfect :), and the thing about talking to an API to some other software is they can change stuff on their end - then we have to change suff on our end, on and on ...

Back when the earlier blog post was written about these Crossref clients, we were at the first versions of both [serrano](https://github.com/sckott/serrano/tree/v0.1.1) and [habanero](https://github.com/sckott/habanero/tree/v0.1.0). As you can see in the changelogs of the three clients ([serrano](https://github.com/sckott/serrano/blob/master/CHANGELOG.md), [habanero](https://github.com/sckott/habanero/blob/master/Changelog.rst), [rcrossref](https://github.com/ropensci/rcrossref/blob/master/NEWS.md)) alot has changed in the last two years as we've made improvements and kept up with Crossref API changes.

### Ruby and R

Nothing new to report for the Ruby ([serrano](https://github.com/sckott/serrano)) and R ([rcrossref](https://github.com/ropensci/rcrossref)) clients, though both will soon be getting the previous features just mentioned (`mailto` and `select`).

### Python: habanero

I've just released a new version of `habanero` - [v0.6](https://pypi.python.org/pypi/habanero). Noteable changes include adding ability to add a `mailto` to each request to get into the so called ["polite pool"](https://github.com/CrossRef/rest-api-doc#good-manners--more-reliable-service); [`select` parameter](https://github.com/CrossRef/rest-api-doc#selecting-which-elements-to-return) added to select certain fields to get back; and the docs got a major overhaul (check em out at <http://habanero.readthedocs.io/en/latest/>; hope you like it; get in touch if you think docs can be improved). 

To install:

```sh
pip3 install habanero
# or
pip install habanero
```

To get into the polite pool, add your `mailto` email address when you instantiate a Crossref object

```python
from habanero import Crossref
cr = Crossref(mailto = "foo@bar.com")
```

Then when you call any  methods on `cr` your email address is sent in the request headers and you'll get into the polite pool.

```python
cr.works()
```

To use the select parameter, pass a comma separated string or a list of strings (both work):

```python
cr.works(select = "DOI,title")
```

### habanero use cases

I've seen some cool use cases using `habanero` lately. 

* A bibliographic application at <https://taccimo.info/tbl_sector_list.php> from [Sean Gordon](https://github.com/sngordon).
* An application called [PyKED](https://github.com/pr-omethe-us/PyKED) from [Kyle Niemeyer](https://github.com/kyleniemeyer) - "a Python-based software package for validating and interacting with ChemKED (Chemical Kinetics Experimental Data format) files that describe fundamental experimental measurements of combustion phenomena".
* A Django app called [TailorDev Biblio](https://tailordev-biblio.herokuapp.com/) from [Julien Maupetit](https://github.com/jmaupetit) that manages references.

