---
name: analogsea-cran
layout: post
title: analogsea - an R client for the Digital Ocean API
date: 2015-10-02
author: Scott Chamberlain
sourceslug: _drafts/2015-10-02-analogsea-cran.Rmd
tags:
- R
- API
- cloud
- servers
---



`analogsea` is now on CRAN. We started developing the pkg back in [May 2014][firstcomm], but just 
now getting the first version on CRAN. It's a collaboration with [Hadley][hadley] and [Winston Chang][chang].

Most of `analogsea` package is for interacting with the [Digital Ocean API](https://developers.digitalocean.com/documentation/v2/), including:

* Manage domains
* Manage ssh keys
* Get actions
* Manage images
* Manage droplets (servers)

A number of convenience functions are included for doing tasks (e.g., resizing 
a droplet) that aren't supported by Digital Ocean's API out of the box (i.e., 
there's no API route for it). 

In addition to wrapping their API routes, we provide other functionality, e.g.: 

* execute shell commands on a droplet (server)
* execute R commands on a droplet
* install R
* install RStudio server
* install Shiny server

Other functionality we're working on, not yet available:

* install OpenCPU
* use `packrat` to move projects from local to server, and vice versa

See also: two previous blog posts on this package [http://recology.info/2014/05/analogsea/](http://recology.info/2014/05/analogsea/) and [http://recology.info/2014/06/analogsea-v01/](http://recology.info/2014/06/analogsea-v01/)

## Install

Binaries are not yet on CRAN, but you can install from source.


```r
# install.packages("analogsea") # when binaries available
install.packages("analogsea", repos = "https://cran.r-project.org", type = "source")
```

Or install development version from GitHub


```r
devtools::install_github("sckott/analogsea")
```

Load `analogsea`


```r
library("analogsea")
```

## Etc.

As this post is mostly to announce that this pkg is on CRAN now, I won't go through examples, but instead point you to the package [README][readme] and [vignette][vign] in which we cover 
creating a Digital Ocean account, authenticating, and have many examples.

## Feedback

Let us know what you think. We'd love to hear about any problems, use cases, feature requests. 

[firstcomm]: https://github.com/sckott/analogsea/commit/b129164dd87969d2fc6bcf3b51576fe1da932fdb
[hadley]: http://had.co.nz/
[chang]: https://github.com/wch/
[readme]: https://github.com/sckott/analogsea/blob/master/README.md
[vign]: https://github.com/sckott/analogsea/blob/master/vignettes/doapi.Rmd
