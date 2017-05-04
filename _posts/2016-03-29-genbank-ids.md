---
name: genbank-ids
layout: post
title: GenBank IDs API - get, match, swap id types
date: 2016-03-29
sourceslug: _drafts/2016-03-29-genbank-ids.md
tags:
- API
- ruby
- sinatra
- science
---

GenBank IDs, accession numbers and GI identifiers, are the two types of identifiers for entries in GenBank. (see [this page](http://www.ncbi.nlm.nih.gov/Sitemap/sequenceIDs.html) for why there are two types of identifiers). Actually, [recent news](http://www.ncbi.nlm.nih.gov/news/03-02-2016-phase-out-of-GI-numbers/) from NCBI is that GI identifiers will be phased out by September this year, which affects what I'll talk about below.

There are a lot of sequences in GenBank. Sometimes you have identifiers and you want to check if they exist in GenBank, or want to get one type from another (accession from GI, or vice versa; although GI phase out will make this use case no longer needed), or just get a bunch of identifiers for software testing purposes perhaps.

Currently, the ENTREZ web services aren't super performant or easy to use for the above use cases. Thus, I've built out a RESTful API for these use cases, called [gbids][gbids].

`gbids` on GitHub: [sckott/gbids][gbids]

Here's the tech stack:

* API: Ruby/Sinatra
* Storage: MySQL
* Caching: Redis
  * each key cached for 3 hours
* Server: Caddy
  * https
* Authentication: none

Will soon have a cron job update when new dump is available every Sunday, but for now we're about a month behind the current dump of identifiers. If usage of the API picks up, I'll know it's worth maintaining and make sure data is up to date.

The base url is [https://gbids.xyz](https://gbids.xyz).

Here's a rundown of the API routes:

* `/` re-routes to `/heartbeat`
* `/heartbeat` - list routes
* `/acc` - `GET` - list accession ids
* `/acc/:id,:id,...` - `GET` - submit many accession numbers, get back boolean (match or no match)
* `/acc` - `POST`
* `/gi` - `GET` - list gi numbers
* `/gi/:id,:id,...` - `GET` - submit many gi numbers, get back boolean (match or no match)
* `/gi` - `POST`
* `/acc2gi/:id,:id,...` - `GET` - get gi numbers from accession numbers
* `/acc2gi` - `POST`
* `/gi2acc/:id,:id,...` - `GET` - get accession numbers from gi numbers
* `/gi2acc` - `POST`

Of course after GI identifiers are phased out, all `gi` routes will be removed.

The API docs are at [recology.info/gbidsdocs](http://recology.info/gbidsdocs) - let me know if you have any feedback on those.

I also have a status page up at [recology.info/gbidsstatus](http://recology.info/gbidsstatus/) - it's not automated, I have to update the status manually, but I do update that page whenever I'm doing maintenance and the API will be down, or if it goes down due to any other reason.

## examples

Request to list accession identifiers, limit to 5

```
curl 'https://gbids.xyz/acc?limit=5' | jq .
{
  "matched": 692006925,
  "returned": 5,
  "data": [
    "A00002",
    "A00003",
    "X17276",
    "X60065",
    "CAA42669"
  ],
  "error": null
}
```

Request to match accession identifiers, some exist, while some do not

```
curl 'https://gbids.xyz/acc/AACY024124486,AACY024124483,asdfd,asdf,AACY024124476' | jq .
{
  "matched": 3,
  "returned": 5,
  "data": {
    "AACY024124486": true,
    "AACY024124483": true,
    "asdfd": false,
    "asdf": false,
    "AACY024124476": true
  },
  "error": null
}
```

## to do

I think it'd probably be worth adding routes for getting accession from taxonomy id and vice versa since that's something that is currently not very easy. We could use the dumped accession2taxid data from ftp://ftp.ncbi.nih.gov/pub/taxonomy/accession2taxid/

## feedback!

If you think this could be potentially useful, do try it out and send any feedback. I watch logs from the API, so I'm hoping for an increase in usage so I know people find it useful.

Since servers aren't free, costs add up, and if I don't see usage pick up I'll discontinue the service at some point. So do use it!

And if anyone can offer free servers, I'd gladly take advantage of that. I've applied for AWS research grant, but won't hear back for a few months.

[gbids]: https://github.com/sckott/gbids
