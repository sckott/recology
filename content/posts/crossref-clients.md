---
name: crossref-clients
layout: post
title: Crossref programmatic clients
date: 2015-11-30
author: Scott Chamberlain
sourceslug: _drafts/2015-11-30-crossref-clients.Rmd
tags:
- python
- ruby
- R
- javascript
- crossref
---

I gave two talks recently at the annual [Crossref meeting][crmeeting], one of which was a somewhat technical overview of programmatic clients for Crossref APIs. Check out the talk [here](https://crossref.wistia.com/medias/8rh0jm5eda). I talked about the motivation for working with Crossref data by writing code/etc. rather than going the GUI route, then went over the various clients, with brief examples.

We (rOpenSci) have been working on the R client [rcrossref][rcrossref] for a while now, but I'm also working on the Python and Ruby clients for Crossref. In addition, the Ruby client has a CLI client inside. The Javascript client is worked on independently by [ScienceAI](https://science.ai/).

The R, Ruby, and Python clients are useable but not feature complete yet, and would benefit from lots of users surfacing bugs and highlighting nice to have features.

The main Crossref API used in all the clients is documented at [api.crossref.org](https://github.com/CrossRef/rest-api-doc/blob/master/rest_api.md).

I've tried to make the APIs similar-ish across clients. Functions in each client match the main Crossref search API (api.crossref.org) routes:

* `/works`
* `/members`
* `/funders`
* `/journals`
* `/types`
* `/licenses`

Other methods in all three clients:

* Get DOI minting agency
  * Uses api.crossref.org API
* Get random DOIs
  * Uses api.crossref.org API
* Content negotiation
  * Documented at [https://www.crosscite.org/cn](https://www.crosscite.org/cn)
* Get full text
  * other clients in each language will focus on this use case
* Get citation count
  * Uses service at [https://www.crossref.org/openurl](https://www.crossref.org/openurl) - though this functionality may be in the api.crossref.org API at some point

The following shows how to install, and then examples from each client for a few use cases.

## Installation

### Python

```sh
pip install habanero
```

### Ruby

```sh
gem install serrano
```

### R

Inside R:

```R
install.packages("rcrossref")
```

### Javascript

```sh
npm install crossref
```

I won't do any examples with the js library, as I don't maintain it.

## Use case: get ORCID IDs for authors

Python

```python3
from habanero import Crossref
cr = Crossref()
res = cr.works(filter = {'has_orcid': True}, limit = 10)
res2 = [ [ z.get('ORCID') for z in x['author'] ] for x in res.result['message']['items'] ]
filter(None, reduce(lambda x, y: x+y, res2))
```

```python3
[u'https://orcid.org/0000-0003-4087-8021',
 u'https://orcid.org/0000-0002-2076-5452',
 u'https://orcid.org/0000-0003-4087-8021',
 u'https://orcid.org/0000-0002-2076-5452',
 u'https://orcid.org/0000-0003-1710-1580',
 u'https://orcid.org/0000-0003-1710-1580',
 u'https://orcid.org/0000-0003-4637-238X',
 u'https://orcid.org/0000-0003-4637-238X',
 u'https://orcid.org/0000-0003-4637-238X',
 u'https://orcid.org/0000-0003-4637-238X',
 u'https://orcid.org/0000-0003-4637-238X',
 u'https://orcid.org/0000-0003-2510-4271']
```

Ruby

```ruby
require 'serrano'
res = Serrano.works(filter: {'has_orcid': true}, limit: 10)
res2 = res['message']['items'].collect { |x| x['author'].collect { |z| z['ORCID'] } }
res2.flatten.compact
```


```ruby
=> ["https://orcid.org/0000-0003-4087-8021",
 "https://orcid.org/0000-0002-2076-5452",
 "https://orcid.org/0000-0003-4087-8021",
 "https://orcid.org/0000-0002-2076-5452",
 "https://orcid.org/0000-0003-1710-1580",
 "https://orcid.org/0000-0003-1710-1580",
 "https://orcid.org/0000-0003-4637-238X",
 "https://orcid.org/0000-0003-4637-238X",
 "https://orcid.org/0000-0003-4637-238X",
 "https://orcid.org/0000-0003-4637-238X",
 "https://orcid.org/0000-0003-4637-238X",
 "https://orcid.org/0000-0003-2510-4271"]
```

R

```R
library("rcrossref")
res <- cr_works(filter=c(has_orcid=TRUE), limit = 10)
orcids <- unlist(lapply(res$data$author, function(z) z$ORCID))
Filter(function(x) !is.na(x), orcids)
```

```R
 [1] "https://orcid.org/0000-0003-4087-8021"
 [2] "https://orcid.org/0000-0002-2076-5452"
 [3] "https://orcid.org/0000-0003-4087-8021"
 [4] "https://orcid.org/0000-0002-2076-5452"
 [5] "https://orcid.org/0000-0003-1710-1580"
 [6] "https://orcid.org/0000-0003-1710-1580"
 [7] "https://orcid.org/0000-0003-4637-238X"
 [8] "https://orcid.org/0000-0003-4637-238X"
 [9] "https://orcid.org/0000-0003-4637-238X"
[10] "https://orcid.org/0000-0003-4637-238X"
[11] "https://orcid.org/0000-0003-4637-238X"
[12] "https://orcid.org/0000-0003-2510-4271"
```

CLI

```sh
serrano works --filter=has_orcid:true --json --limit=12 | jq '.message.items[].author[].ORCID | select(. != null)'
```

```sh
"https://orcid.org/0000-0003-4087-8021"
"https://orcid.org/0000-0002-2076-5452"
"https://orcid.org/0000-0003-4087-8021"
"https://orcid.org/0000-0002-2076-5452"
"https://orcid.org/0000-0003-1710-1580"
"https://orcid.org/0000-0003-1710-1580"
"https://orcid.org/0000-0003-4637-238X"
"https://orcid.org/0000-0003-4637-238X"
"https://orcid.org/0000-0003-4637-238X"
"https://orcid.org/0000-0003-4637-238X"
"https://orcid.org/0000-0003-4637-238X"
"https://orcid.org/0000-0003-2510-4271"
"https://orcid.org/0000-0001-9408-8207"
"https://orcid.org/0000-0002-2076-5452"
```

## Use case: content negotation

Python

```python3
from habanero import cn
cn.content_negotiation(ids = '10.1126/science.169.3946.635', format = "text")
```


```python3
u'Frank, H. S. (1970). The Structure of Ordinary Water: New data and interpretations are yielding new insights into this fascinating substance. Science, 169(3946), 635\xe2\x80\x93641. doi:10.1126/science.169.3946.635\n'
```

Ruby

```ruby
require 'serrano'
Serrano.content_negotiation(ids: '10.1126/science.169.3946.635', format: "text")
```

```ruby
=> ["Frank, H. S. (1970). The Structure of Ordinary Water: New data and interpretations are yielding new insights into this fascinating substance. Science, 169(3946), 635\xE2\x80\x93641. doi:10.1126/science.169.3946.635\n"]
```

R

```r
library("rcrossref")
cr_cn(dois="10.1126/science.169.3946.635", "text")
```

```r
[1] "Frank, H. S. (1970). The Structure of Ordinary Water: New data and interpretations are yielding new insights into this fascinating substance. Science, 169(3946), 635–641. doi:10.1126/science.169.3946.635"
```

CLI

```bash
serrano contneg 10.1890/13-0590.1 --format=text
```

```bash
Murtaugh, P. A. (2014).  In defense of P values . Ecology, 95(3), 611–617. doi:10.1890/13-0590.1
```

## More

There are definitely issues with data in the Crossref search API, some of which I cover in my talks. However, it is still the best place to go for scholarly metadata.

Let us know of other use cases - there are others not covered here for brevity sake.

There are lots of examples in the docs for each client. If you can think of any doc improvements file an issue.

If you find any bugs, please do file an issue.

[rcrossref]: https://github.com/ropensci/rcrossref
[habanero]: https://github.com/sckott/habanero
[serrano]: https://github.com/sckott/serrano
[crmeeting]: https://www.crossref.org/annualmeeting/agenda.html
