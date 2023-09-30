---
name: cran-checks-badges
layout: post
title: "CRAN Checks API and Badges"
date: 2022-06-02
author: Scott Chamberlain
sourceslug: _posts/2022-06-02-cran-checks-badges.md
tags:
- R
- cran
---

## TL;DR

1. In 6 months (end of November 2022) the CRAN Checks API <https://cranchecks.info/> will be gone
2. You can still get badges at <https://badges.cranchecks.info>
3. You can use the new badges like:

```markdown
[![cran checks](https://badges.cranchecks.info/worst/dplyr.svg)](https://cran.r-project.org/web/checks/check_results_dplyr.html)
```

Find more details at <https://github.com/sckott/cchecksbadges>


## Sunsetting the CRAN Checks API

If you contribute an R package to [CRAN][], you may use badges from the CRAN checks API at <https://cranchecks.info/>. The CRAN Checks API has been operating [since about September 2017](https://recology.info/2017/09/cranchecks-api/) (I think). 

The API has a number of routes, but really people only use the badges. 

Given this usage pattern, and not wanting to pay for a server anymore, I've decided to make the badges available on a static endpoint that doesn't cost me anything. There are costs of course - but they're on Github and Netlify (thanks y'all!). 


## The new static site version

The static site is created using GitHub Actions. 

For a static site you need to create files for any route you want to support - so the code for the static site creates 19 routes x No. of CRAN packages = approx. 360,000 svg files.

The badges will be updated once a day - the same schedule as the API. 

I had to use Netlify because Github pages (as far as I know) doesn't provide ssl certs for custom domains and my domain host doesn't provide free Lets Encrypt certs - whereas Netlify does. 

Some example routes you can look at

<https://badges.cranchecks.info/summary/taxize.svg>
<https://badges.cranchecks.info/worst/dplyr.svg>
<https://badges.cranchecks.info/flavor/r-devel-linux-x86_64-fedora-clang/DT.svg>

If you find any issues with the badges at <https://badges.cranchecks.info> [open an issue](https://github.com/sckott/cchecksbadges/issues).


[CRAN]: https://cloud.r-project.org/
