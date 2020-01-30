---
name: test-truffles
layout: post
title: "finding truffles"
date: 2020-01-30
author: Scott Chamberlain
sourceslug: _drafts/2020-01-30-test-truffles.Rmd
tags:
- R
- testing
- truffles
---



The bad thing about making software is that you can sometimes make it easier
for someone to shoot themselves in the foot. The good thing about software
is that you can make more software to help them not shoot a foot off.

The R package [vcr][], an R port of the [Ruby library][vcrrb] of the same name,
records and plays back HTTP requests. Some HTTP requests can have secrets (e.g.,
passwords, API keys, etc.) in their requests and/or responses. These secrets
can then accidentally end up on the Internet, where bad people may find them.
These secrets are sometimes called "truffles".

There's a suite of tools out there for finding these truffles (e.g.,
[truffleHog][], [gitsecrets][]) that use tools like regex and entropy.

Despite there being existing tools, users tend to use things that are
built in the language(s) they know; that are easy to incorporate into 
their existing workflows. Towards this end, I've been working on a new
R package [trufflesniffer][tf].

trufflesniffer doesn't do any fancy entropy stuff, and doesn't try to
find secrets without any informed knowledge. Rather, the user supplies
the secrets that they want to look for and trufflesniffer looks for
them. In the future I'd look to see if it can be used without
any user inputs.

terminology:

- sniff: search for a secret

links:
- src: <https://github.com/ropenscilabs/trufflesniffer>
- docs: <https://docs.ropensci.org/trufflesniffer>

## Install


```r
remotes::install_github("ropenscilabs/trufflesniffer")
```


```r
library(trufflesniffer)
```

## directory

You can "sniff" a file directory or a package: `sniff_one()`


```r
# crete a directory
Sys.setenv(A_KEY = "a8d#d%d7g7g4012a4s2")
path <- file.path(tempdir(), "foobar")
dir.create(path)

# no matches
sniff_one(path, Sys.getenv("A_KEY"))
#> named list()

# add files with the secret
cat(paste0("foo\nbar\nhello\nworld\n", 
    Sys.getenv("A_KEY"), "\n"), file = file.path(path, "stuff.R"))

# matches! prints the line number where the key was found
sniff_one(path, Sys.getenv("A_KEY"))
#> $stuff.R
#> [1] 5
```

## package

sniff through a whole package


```r
foo <- function(key = NULL) {
  if (is.null(key)) key <- "mysecretkey"
}
package.skeleton(name = "mypkg", list = "foo", path = tempdir())
pkgpath <- file.path(tempdir(), "mypkg")
list.files(pkgpath, recursive=TRUE)
#> [1] "DESCRIPTION"          "man/foo.Rd"           "man/mypkg-package.Rd"
#> [4] "NAMESPACE"            "R/foo.R"              "Read-and-delete-me"

# check the package
sniff_secrets_pkg(dir = pkgpath, secrets = c("mysecretkey"))
#> $mysecretkey
#> $mysecretkey$foo.R
#> [1] 3
```

## fixtures

sniff specifically in a package's test fixtures. 

Create a package


```r
foo <- function(key = NULL) {
  if (is.null(key)) key <- "a2s323223asd423adsf4"
}
package.skeleton("herpkg", list = "foo", path = tempdir())
pkgpath <- file.path(tempdir(), "herpkg")
dir.create(file.path(pkgpath, "tests/testthat"), recursive = TRUE)
dir.create(file.path(pkgpath, "tests/fixtures"), recursive = TRUE)
cat("library(vcr)
vcr::vcr_configure('../fixtures', 
  filter_sensitive_data = list('<<mytoken>>' = Sys.getenv('MY_KEY'))
)\n", file = file.path(pkgpath, "tests/testthat/helper-herpkg.R"))
cat("a2s323223asd423adsf4\n", 
  file = file.path(pkgpath, "tests/fixtures/foo.yml"))
# check that you have a pkg at herpkg
list.files(pkgpath)
#> [1] "DESCRIPTION"        "man"                "NAMESPACE"         
#> [4] "R"                  "Read-and-delete-me" "tests"
list.files(file.path(pkgpath, "tests/testthat"))
#> [1] "helper-herpkg.R"
cat(readLines(file.path(pkgpath, "tests/testthat/helper-herpkg.R")),
  sep = "\n")
#> library(vcr)
#> vcr::vcr_configure('../fixtures', 
#>   filter_sensitive_data = list('<<mytoken>>' = Sys.getenv('MY_KEY'))
#> )
list.files(file.path(pkgpath, "tests/fixtures"))
#> [1] "foo.yml"
readLines(file.path(pkgpath, "tests/fixtures/foo.yml"))
#> [1] "a2s323223asd423adsf4"
```

Check the package


```r
Sys.setenv('MY_KEY' = 'a2s323223asd423adsf4')
sniff_secrets_fixtures(pkgpath)
#> $MY_KEY
#> $MY_KEY$foo.yml
#> [1] 1
```

## sniffer

The function `sniffer()` wraps the function `sniff_secrets_fixtures()` and
pretty prints to optimize non-interactive use. Run from within R or from the 
command line non-interactively.

Example where a secret is found:


```r
sniffer(pkgpath)
```

![found](/public/img/2020-01-30-test-truffles/found.png)

Example where a secret is not found:


```r
Sys.unsetenv('MY_KEY')
sniffer(pkgpath)
```

![found](/public/img/2020-01-30-test-truffles/notfound.png)

## To do

There's more to do. trufflesniffer hasn't been tested thoroughly yet; I'll do
more testing to make the experience better. In addition, it'd probably be 
best to integrate this into the R vcr package so that the user doesn't have to
take an extra step to make sure they aren't going to put any secrets on
the web.

-----

<br>

ack: trufflesniffer uses R packages [cli][] and [crayon][]


[tf]: https://github.com/ropenscilabs/trufflesniffer
[vcr]: https://github.com/ropensci/vcr
[vcrrb]: https://github.com/vcr/vcr
[webmockr]: https://github.com/ropensci/webmockr
[truffleHog]: https://github.com/dxa4481/truffleHog
[gitsecrets]: https://github.com/awslabs/git-secrets
[cli]: https://github.com/r-lib/cli
[crayon]: https://github.com/r-lib/crayon
