---
name: gistr-github-gists
layout: post
title: gistr - R client for GitHub gists
date: 2015-01-05
author: Scott Chamberlain
sourceslug: _drafts/2015-01-05-gistr-github-gists.Rmd
tags:
- R
- github
---

GitHub has this site <https://gist.github.com/> in which we can share code, text, images, maps, plots, etc super easily, without having to open up a repo, etc. GitHub gists are a great way to throw up an example use case to show someone, or show code that's throwing errors to a support person, etc. In addition, there's API access, which means we can interact with Gists not just from their web interface, but from the command line, or any programming language. There are clients for [Node.js](https://github.com/mbostock/gistup), [Ruby](https://rubygems.org/gems/gist), [Python](https://pypi.python.org/pypi/gists/0.4.6), and on and on. But AFAIK there wasn't one for R. Along with [Ramnath](https://github.com/ramnathv) and others, we've been working on an R client for gists. `v0.1` is [now on CRAN](https://cran.r-project.org/web/packages/gistr/index.html). Below is an overview. 

One useful thing about this package in terms of other R packages is that you can now depend on `gistr` to easily share results as Gists. For example, you can share maps as gists (via geojson, rendered as interactive map), or code, or plots, etc. That is, you don't have to re-write an interface to Github Gists yourself. We plan on using `gistr` in a few rOpenSci packages. 

## Installation

## Installation

Install from CRAN


```r
install.packages("gistr")
```

Or the development version from GitHub


```r
install.packages("devtools")
devtools::install_github("ropensci/gistr")
```


```r
library("gistr")
```

## Authentication

There are two ways to authorise `gistr` to work with your GitHub account:

* Generate a personal access token (PAT) at [https://help.github.com/articles/creating-an-access-token-for-command-line-use](https://help.github.com/articles/creating-an-access-token-for-command-line-use) and record it in the `GITHUB_PAT` envar.
* Interactively login into your GitHub account and authorise with OAuth.

Using the PAT is recommended.

Using the `gist_auth()` function you can authenticate seperately first, or if you're not authenticated, this function will run internally with each functionn call. If you have a PAT, that will be used, if not, OAuth will be used.


```r
gist_auth()
```

## Workflow

In `gistr` you can use pipes to pass outputs from one function to another. If you have used `dplyr` with pipes you can see the difference, and perhaps the utility, of this workflow over the traditional workflow in R. You can use a non-piping or a piping workflow with `gistr`. Examples below use a mix of both workflows. Here is an example of a piping wofklow (with some explanation):


```r
gists(what = "minepublic")[[6]] %>% # List my public gists, and index 1st
  add_files("~/alm_othersources.md") %>% # Add new file to that gist
  update() # update sends a PATCH command to Gists API to add file to your gist
```

And a non-piping workflow that does the same exact thing:


```r
g <- gists(what = "minepublic")[[1]]
g <- add_files(g, "~/alm_othersources.md")
update(g)
```

Or you could string them all together in one line (but it's rather difficult to follow what's going on because you have to read from the inside out)


```r
update(add_files(gists(what = "minepublic")[[1]], "~/alm_othersources.md"))
```

## Rate limit information


```r
rate_limit()
#> Rate limit: 5000
#> Remaining:  4948
#> Resets in:  46 minutes
```

## List gists

Limiting to a few results here to keep it brief


```r
gists(per_page = 2)
#> [[1]]
#> <gist>575fd0342ae15f89645f
#>   URL: https://gist.github.com/575fd0342ae15f89645f
#>   Description: Script to disable the mouse acceleration on Ubuntu (and probably also other distributions). Read the 'usage' section.
#>   Public: TRUE
#>   Created/Edited: 2015-01-04T17:41:49Z / 2015-01-04T17:41:50Z
#>   Files: disable-mouse-accel.sh
#> 
#> [[2]]
#> <gist>1ebff1af906f214f98cd
#>   URL: https://gist.github.com/1ebff1af906f214f98cd
#>   Description: Ladda
#>   Public: TRUE
#>   Created/Edited: 2015-01-04T17:41:45Z / 2015-01-04T17:41:45Z
#>   Files: Ladda.markdown, index.html, script.js, style.css
```

Since a certain date/time


```r
gists(since='2014-05-26T00:00:00Z', per_page = 2)
#> [[1]]
#> <gist>575fd0342ae15f89645f
#>   URL: https://gist.github.com/575fd0342ae15f89645f
#>   Description: Script to disable the mouse acceleration on Ubuntu (and probably also other distributions). Read the 'usage' section.
#>   Public: TRUE
#>   Created/Edited: 2015-01-04T17:41:49Z / 2015-01-04T17:41:50Z
#>   Files: disable-mouse-accel.sh
#> 
#> [[2]]
#> <gist>1ebff1af906f214f98cd
#>   URL: https://gist.github.com/1ebff1af906f214f98cd
#>   Description: Ladda
#>   Public: TRUE
#>   Created/Edited: 2015-01-04T17:41:45Z / 2015-01-04T17:41:45Z
#>   Files: Ladda.markdown, index.html, script.js, style.css
```

Request different types of gists, one of public, minepublic, mineall, or starred.


```r
gists('minepublic', per_page = 2)
#> [[1]]
#> <gist>588921d4111e00551bcf
#>   URL: https://gist.github.com/588921d4111e00551bcf
#>   Description: 
#>   Public: TRUE
#>   Created/Edited: 2015-01-04T17:33:47Z / 2015-01-04T17:33:56Z
#>   Files: code.R
#> 
#> [[2]]
#> <gist>54c0195ee8753c7aaf9f
#>   URL: https://gist.github.com/54c0195ee8753c7aaf9f
#>   Description: a new cool gist
#>   Public: TRUE
#>   Created/Edited: 2015-01-04T17:33:47Z / 2015-01-04T17:33:47Z
#>   Files: stuff.md
```


## List a single gist


```r
gist(id = 'f1403260eb92f5dfa7e1')
#> <gist>f1403260eb92f5dfa7e1
#>   URL: https://gist.github.com/f1403260eb92f5dfa7e1
#>   Description: Querying bitly from R 
#>   Public: TRUE
#>   Created/Edited: 2014-10-15T20:40:12Z / 2014-10-15T21:54:29Z
#>   Files: bitly_r.md
```

## Create gist

You can pass in files

First, get a file to work with


```r
stuffpath <- system.file("examples", "stuff.md", package = "gistr")
```


```r
gist_create(files=stuffpath, description='a new cool gist')
```


```r
gist_create(files=stuffpath, description='a new cool gist', browse = FALSE)
#> <gist>aa391404638f2f368b99
#>   URL: https://gist.github.com/aa391404638f2f368b99
#>   Description: a new cool gist
#>   Public: TRUE
#>   Created/Edited: 2015-01-04T17:42:37Z / 2015-01-04T17:42:37Z
#>   Files: stuff.md
```

Or, wrap `gist_create()` around some code in your R session/IDE, like so, with just the function name, and a `{'` at the start and a `}'` at the end.


```r
gist_create(code={'
x <- letters
numbers <- runif(8)
numbers

[1] 0.3229318 0.5933054 0.7778408 0.3898947 0.1309717 0.7501378 0.3206379 0.3379005
'}, browse=FALSE)
#> <gist>85158117880f197df422
#>   URL: https://gist.github.com/85158117880f197df422
#>   Description: 
#>   Public: TRUE
#>   Created/Edited: 2015-01-04T17:42:37Z / 2015-01-04T17:42:37Z
#>   Files: code.R
```

You can also knit an input file before posting as a gist:


```r
file <- system.file("examples", "stuff.Rmd", package = "gistr")
gist_create(file, description='a new cool gist', knit=TRUE)
#> <gist>4162b9c53479fbc298db
#>   URL: https://gist.github.com/4162b9c53479fbc298db
#>   Description: a new cool gist
#>   Public: TRUE
#>   Created/Edited: 2014-10-27T16:07:31Z / 2014-10-27T16:07:31Z
#>   Files: stuff.md
```

Or code blocks before (note that code blocks without knitr block demarcations will result in unexecuted code):


```r
gist_create(code={'
x <- letters
(numbers <- runif(8))
'}, knit=TRUE)
#> <gist>ec45c396dee4aa492139
#>   URL: https://gist.github.com/ec45c396dee4aa492139
#>   Description:
#>   Public: TRUE
#>   Created/Edited: 2014-10-27T16:09:09Z / 2014-10-27T16:09:09Z
#>   Files: file81720d1ceff.md
```

## knit code from file path, code block, or gist file

knit a local file


```r
file <- system.file("examples", "stuff.Rmd", package = "gistr")
run(file, knitopts = list(quiet=TRUE)) %>% gist_create(browse = FALSE)
#> <gist>d5d86e11964c36cb4f1e
#>   URL: https://gist.github.com/d5d86e11964c36cb4f1e
#>   Description: 
#>   Public: TRUE
#>   Created/Edited: 2015-01-04T17:42:38Z / 2015-01-04T17:42:38Z
#>   Files: stuff.md
```



knit a code block (`knitr` code block notation missing, do add that in) (result not shown)


```r
run({'
x <- letters
(numbers <- runif(8))
'}) %>% gist_create
```

knit a file from a gist, has to get file first (result not shown)


```r
gists('minepublic')[[1]] %>% run() %>% update()
```

## List commits on a gist


```r
gists()[[1]] %>% commits()
#> [[1]]
#> <commit>
#>   Version: faa7a40f4b55aa7914be7685c75d5c80731971bb
#>   User: sckott
#>   Commited: 2015-01-04T17:42:37Z
#>   Commits [total, additions, deletions]: [5,5,0]
```

## Star a gist

Star


```r
gist('7ddb9810fc99c84c65ec') %>% star()
#> <gist>7ddb9810fc99c84c65ec
#>   URL: https://gist.github.com/7ddb9810fc99c84c65ec
#>   Description: 
#>   Public: TRUE
#>   Created/Edited: 2014-06-27T17:50:37Z / 2014-06-27T17:50:37Z
#>   Files: code.R, manifest.yml, rrt_manifest.yml
```

Unstar


```r
gist('7ddb9810fc99c84c65ec') %>% unstar()
#> <gist>7ddb9810fc99c84c65ec
#>   URL: https://gist.github.com/7ddb9810fc99c84c65ec
#>   Description: 
#>   Public: TRUE
#>   Created/Edited: 2014-06-27T17:50:37Z / 2014-06-27T17:50:37Z
#>   Files: code.R, manifest.yml, rrt_manifest.yml
```

## Update a gist

Add files

First, path to file


```r
file <- system.file("examples", "alm_othersources.md", package = "gistr")
```


```r
gists(what = "minepublic")[[1]] %>%
  add_files(file) %>%
  update()
#> <gist>85158117880f197df422
#>   URL: https://gist.github.com/85158117880f197df422
#>   Description: 
#>   Public: TRUE
#>   Created/Edited: 2015-01-04T17:42:37Z / 2015-01-04T17:42:42Z
#>   Files: alm_othersources.md, code.R
```

Delete files


```r
gists(what = "minepublic")[[1]] %>%
  delete_files(file) %>%
  update()
#> <gist>85158117880f197df422
#>   URL: https://gist.github.com/85158117880f197df422
#>   Description: 
#>   Public: TRUE
#>   Created/Edited: 2015-01-04T17:42:37Z / 2015-01-04T17:42:42Z
#>   Files: code.R
```

## Open a gist in your default browser


```r
gists()[[1]] %>% browse()
```

> Opens the gist in your default browser

## Get embed script


```r
gists()[[1]] %>% embed()
#> [1] "<script src=\"https://gist.github.com/sckott/85158117880f197df422.js\"></script>"
```

### List forks

Returns a list of `gist` objects, just like `gists()`


```r
gist(id='1642874') %>% forks(per_page=2)
#> [[1]]
#> <gist>1642989
#>   URL: https://gist.github.com/1642989
#>   Description: Spline Transition
#>   Public: TRUE
#>   Created/Edited: 2012-01-19T21:45:20Z / 2014-12-10T03:25:19Z
#>   Files: 
#> 
#> [[2]]
#> <gist>1643051
#>   URL: https://gist.github.com/1643051
#>   Description: Line Transition (Broken)
#>   Public: TRUE
#>   Created/Edited: 2012-01-19T21:51:30Z / 2014-04-09T03:11:36Z
#>   Files:
```

## Fork a gist

Returns a `gist` object


```r
g <- gists()
(forked <- g[[ sample(seq_along(g), 1) ]] %>% fork())
#> <gist>62b05dd4ebc2d29add15
#>   URL: https://gist.github.com/62b05dd4ebc2d29add15
#>   Description: Solution to level 1 in Untrusted: https://alex.nisnevich.com/untrusted/
#>   Public: TRUE
#>   Created/Edited: 2015-01-04T17:42:43Z / 2015-01-04T17:42:43Z
#>   Files: untrusted-lvl1-solution.js
```



## Example use case

_Working with the Mapzen Pelias geocoding API_

The API is described at [https://github.com/pelias/pelias](https://github.com/pelias/pelias), and is still in alpha they say. The steps: get data, make a gist. The data is returned from Mapzen as geojson, so all we have to do is literally push it up to GitHub gists and we're done b/c GitHub renders the map.


```r
library('httr')
base <- "https://pelias.mapzen.com/search"
res <- GET(base, query = list(input = 'coffee shop', lat = 45.5, lon = -122.6))
json <- content(res, as = "text")
gist_create(code = json, filename = "pelias_test.geojson")
#> <gist>017214637bcfeb198070
#>   URL: https://gist.github.com/017214637bcfeb198070
#>   Description:
#>   Public: TRUE
#>   Created/Edited: 2014-10-28T14:42:36Z / 2014-10-28T14:42:36Z
#>   Files: pelias_test.geojson
```

And here's that gist: [https://gist.github.com/sckott/017214637bcfeb198070](https://gist.github.com/sckott/017214637bcfeb198070)

![image](/2015-01-05-gistr-github-gists/gistr_ss.png)
