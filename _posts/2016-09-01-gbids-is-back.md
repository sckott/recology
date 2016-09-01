---
name: gbids-is-back
layout: post
title: gbids - GenBank IDs API is back up!
date: 2016-09-01
author: Scott Chamberlain
sourceslug: _posts/2016-09-01-gbids-is-back.md
tags:
- API
- ruby
- sinatra
- science
---

## GBIDS API is back

Back in March this year I wrote [a post about a new API for working with GenBank IDs](http://recology.info/2016/03/genbank-ids/).

I had to take the API down because it was too expensive to keep up. Expensive because the dump of data is very large (3.8 GB compressed), and I need disk space on the server to uncompress that to I think about 18 GB, then load into MySQL, which is another maybe 30 GB or so. Anyway, it's not expensive because of high traffic - although I wish that was the case - but because of needing lots of disk space.

I was fortuntate to recently receive some [Amazon Cloud Credits for Research](https://aws.amazon.com/research-credits/). The credits expire in 1 year. With these credits, I've put the GBIDS API back up. In the next year I'm hoping to gain user traction suggesting that's is useful to enough people to keep maintaining - in which case I'll seek ways to fund it.

But that means I need people to use it!  So please to give it a try. Let me know what could be better; what could be faster; what API routes/features/etc. you'd like to see.

## Plans

Plans for the future of the GBIDS API:

* Auto-update the Genbank data. This is quite complicated since the dump is so large. I can either keep an EC2 attached disc large enough to do the dump download/expansion/load/etc, or spin up a new instance each Sunday when they do their data release, do the SQL load, make a dump, then shuttle the SQL dump to the instance running, then load in the new data from the dump. I haven't got this bit running yet, so data is from Aug 7. 2016.
* Add taxonomic IDs. Genbank also dumps their taxonomic IDs. I think it should be possible to get taxonomic IDs into the API, so that users can do accession number to taxon IDs and vice versa. 
* Performance: as anyone would want, I want to continually improve performance. I'll watch out for things I can do, but also let me know what seems too slow. 

## Links

* API base url: <https://gbids.xyz>
* API docs: <http://recology.info/gbidsdocs> - Let me know if these could be improved
* API status page: <http://recology.info/gbidsstatus> - I update this page whenever there's some down time, then when it's back up, etc.
* API source code: <https://github.com/sckott/gbids> - You can file issues here about the API

## Try it

Get 5 accession numbers

```
curl 'https://gbids.xyz/acc?limit=5' | jq .
#> {
#>   "matched": 692006925,
#>   "returned": 5,
#>   "data": [
#>     "A00002",
#>     "A00003",
#>     "X17276",
#>     "X60065",
#>     "CAA42669"
#>   ],
#>   "error": null
#> }
```

Request to match accession identifiers, some exist, while some do not

```
curl 'https://gbids.xyz/acc/AACY024124486,AACY024124483,asdfd,asdf,AACY024124476' | jq .
#> {
#>   "matched": 3,
#>   "returned": 5,
#>   "data": {
#>     "AACY024124486": true,
#>     "AACY024124483": true,
#>     "asdfd": false,
#>     "asdf": false,
#>     "AACY024124476": true
#>   },
#>   "error": null
#> }
```

There's many more examples in the [API docs](http://recology.info/gbidsdocs)
