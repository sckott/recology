---
name: hoardr
layout: post
title: "hoardr: simple file caching"
date: 2017-08-15
author: Scott Chamberlain
sourceslug: _drafts/2017-08-15-hoardr.Rmd
tags:
- R
- cache
- caching
---



`hoardr` is a client for caching files and managing those files.

You can definitely achieve the same tasks without a separate pacakge, and there's 
a number of packages for caching various objects in R already. However, 
I didn't think there was a tool for that did everything I needed.

The use cases I typically need `hoardr` for are when dealing with large files,
either text (e.g., csv) or binary (e.g., shp) files that would be nice to not 
make the user of packages I maintain download again if they already have the 
file. This makes the server's life easier that's serving the files and makes 
work faster for the user of my package.

Given the existence of the awesome [R6][R6], `hoardr` becomes simple to use 
inside of other packages. Namely, `hoardr` can export just a single object 
that another package has to import, then we can call methods on that object, instead
of having to import loads of functions.

## Install

From CRAN


```r
install.packages("hoardr")
```

Dev version


```r
devtools::install_github("ropensci/hoardr")
```


```r
library("hoardr")
```

## Package API

There's only a single exported object: `hoard`. This is a normal function, although
is a lite wrapper around the R6 class `HoardClient`, which contains all the 
smarts.

## Example usage

Initialze an object


```r
(x <- hoard())
#> <hoard> 
#>   path: 
#>   cache path: /var/folders/gs/4khph0xs0436gmd2gdnwsg080000gn/T//RtmpPITEm6/R/foobar
```



After making the object with `hoardr()`, it's good to set a cache path. Here, 
we'll use a temporary directoy, which we can set by doing `type = "tempdir"`


```r
x$cache_path_set(path = "foobar", type = 'tempdir')
#> [1] "/var/folders/gs/4khph0xs0436gmd2gdnwsg080000gn/T//RtmpPITEm6/R/foobar"
```

Now our cache path is set to a temp dir


```r
x
#> <hoard> 
#>   path: foobar
#>   cache path: /var/folders/gs/4khph0xs0436gmd2gdnwsg080000gn/T//RtmpPITEm6/R/foobar
```

And we can request the base cache path as well


```r
x$cache_path_get()
#> [1] "/var/folders/gs/4khph0xs0436gmd2gdnwsg080000gn/T//RtmpPITEm6/R/foobar"
```

The next thing you'll likely want to do is create that base directory since 
setting the path doesn't create the directory:


```r
x$mkdir()
```

What files are in the directory (hint: there shouldn't be any):


```r
x$list()
#> character(0)
```

Let's put a file in the cache


```r
cat(1:10000L, file = file.path(x$cache_path_get(), "foo.txt"))
```

Now see what's in there


```r
x$list()
#> [1] "/var/folders/gs/4khph0xs0436gmd2gdnwsg080000gn/T//RtmpPITEm6/R/foobar/foo.txt"
```

While `list()` method lists full file paths, we can get more details with the `details()` method:


```r
x$details()
#> <cached files>
#>   directory: /var/folders/gs/4khph0xs0436gmd2gdnwsg080000gn/T//RtmpPITEm6/R/foobar
#> 
#>   file: /foo.txt
#>   size: 0.049 mb
```

You can delete files by name:


```r
x$delete("foo.txt")
x$list()
#> character(0)
```

As well as delete all files:


```r
cat("one\ntwo\nthree", file = file.path(x$cache_path_get(), "foo.txt"))
cat("asdfasdf asd fasdf", file = file.path(x$cache_path_get(), "bar.txt"))
x$list()
#> [1] "/var/folders/gs/4khph0xs0436gmd2gdnwsg080000gn/T//RtmpPITEm6/R/foobar/bar.txt"
#> [2] "/var/folders/gs/4khph0xs0436gmd2gdnwsg080000gn/T//RtmpPITEm6/R/foobar/foo.txt"
x$delete_all()
x$list()
#> character(0)
```

There's also methods for compressing and uncompressing all the files in your cache:


```r
cat("one\ntwo\nthree", file = file.path(x$cache_path_get(), "foo.txt"))
cat("asdfasdf asd fasdf", file = file.path(x$cache_path_get(), "bar.txt"))
x$compress()
x$list()
#> [1] "/var/folders/gs/4khph0xs0436gmd2gdnwsg080000gn/T//RtmpPITEm6/R/foobar/compress.zip"
x$uncompress()
x$list()
#> [1] "/var/folders/gs/4khph0xs0436gmd2gdnwsg080000gn/T//RtmpPITEm6/R/foobar/bar.txt"
#> [2] "/var/folders/gs/4khph0xs0436gmd2gdnwsg080000gn/T//RtmpPITEm6/R/foobar/foo.txt"
```

<br><br>

## How to use in a package

I already use `hoardr` in five R packages I maintain: [crminer][crminer], [rdpla][rdpla], [rerddap][rerddap], [rnoaa][rnoaa], and [taxizedb][taxizedb]. I'm planning to use it in 
many more packages, especially as it gets more stable.

This is how I use `hoardr` in packages.

- list `hoardr` in your Imports in your DESCRIPTION file
- make on `.onLoad` method in your package, with the following content (as an example):

```r
cache <- NULL
.onLoad <- function(libname, pkgname){
  x <- hoardr::hoard()
  x$cache_path_set("<your package name>")
  cache <<- x
}
```

Then when the package is loaded, you have a `cache` object that you can then use 
to manage cached files.

- Use `cache$mkdir()` to make the directory
- Probably use `cache$cache_path_get()` in combination with e.g., `file.path()` 
to make file paths for files you need to cache
- Write files as needed
- If you need to delete files you can use `delete()` method to delete by name, or
use `unlink()` on the complete file path, or you can `delet_all()` if you need to 
delete all files. 
- If you need to do compression `compress`/`uncompress` are available - may be a nice
thing to do for users so files are taking up less disk space.
- Add a manual file with a description of the various methods available and
example usage, e.g, <https://github.com/ropensci/crminer/blob/master/R/caching.R>
- The `cache` object created above is also available to the user of your package
so that they can manage files themselves as well - but of course you can 
choose not to export the cache object with methods to the user.



[R6]: https://github.com/r-lib/R6
[crminer]: https://github.com/ropensci/crminer
[rdpla]: https://github.com/ropensci/rdpla
[rerddap]: https://github.com/ropensci/rerddap
[rnoaa]: https://github.com/ropensci/rnoaa
[taxizedb]:  https://github.com/ropensci/taxizedb
