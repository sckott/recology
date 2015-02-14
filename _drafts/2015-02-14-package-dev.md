---
name: package-dev
layout: post
title: Package development
date: 2015-02-14
author: Scott Chamberlain
sourceslug: _drafts/2015-02-14-package-dev.Rmd
tags:
- R
- development
---



Someone asked recently about tips for package development workflow to optimize a successful submission to CRAN.

The ultimate guide is probably [Hadley's book on package development](http://r-pkgs.had.co.nz/), but here's more of a bulleted list of some things I do.

## Use RStudio

Choice of text editor/IDE is always contentious, but for R package development, RStudio makes it so easy, including keyboard shortcuts for lots of steps that you need to make development faster. See the [cheatsheet](https://support.rstudio.com/hc/en-us/articles/200711853-Keyboard-Shortcuts).

## Documentation and roxygen2

You can always write your manual files (`.Rd`) files by hand, but to avoid mistakes including missing and duplicate parameter definitions, and other things, simply write documentation alongside your code with [roxygen2](http://cran.r-project.org/web/packages/roxygen2/index.html). The RStudio IDE includes a keyboard shortcut (shift+cmd+D on Mac) to generate manual files from your roxygen documentation. 

When you run either `R CMD CHECK` in your terminal or `devtools::check()` or simply using keyboard shortcuts in RStudio, you may notice problems with documentation, upon which you can make fixes, quickly re-document the whole package, then run check again. Iterating on this process is very easy with RStudio keyboard shortcuts. 

## Examples

CRAN checks now actually run code examples wrapped in `\donttest`. So if you have examples that may throw warnings or errors on purpose or accident, make sure to wrap them in `\dontrun`. Ripley used to complain that at least some examples in the package should run on check, but I haven't heard this complaint in a while.

## First submission of the package?

If it is your first submission of the package:

* Include the sentence in your submission _I have read and agree to the the CRAN policies at http://cran.r-project.org/web/packages/policies.html_

## Code

CRAN maintainers generally don't look at code in my experience, but they may in the case of some examples or tests not passing on submission. 

## Tests

If you have tests in your package, and you should, think about whether your tests are likely to fail in some scenarios. For example, I mostly write packages that work with web APIs, all of which are not under my control, meaning they could fail at any time, causing tests to fail on CRAN (CRAN runs check once per day I think). 

If you do have tests may fail, think about ignoring tests all together on CRAN. If you do this, it's especially important to use continuous integration on your own. For example, use [Travis-CI](), which will run check on your package on each change. If you have a package that works with web APIs, it's important to check your package functionality even when you aren't changing it since the resource your package works with can change. So run tests e.g. once per day - you can [do something like we do using a bit of Ruby code](https://github.com/ropensci/travis-restarts).

## DESCRIPTION file

In addition to following [CRAN's guidelines](http://cran.r-project.org/doc/manuals/R-exts.html#The-DESCRIPTION-file) (and search _description_ in the [CRAN policies](http://cran.r-project.org/web/packages/policies.html)), some tips for some of the parts of the file.

* Title: must be sentence case, no period at end
* Description: Don't use the phrase _This package_
* Watch out for _possibly mis-spelled words_ warnings on check. They will reject your package for very minor mis-spellings.

## Use cran-comments.md file

Hadley supports this in `devtools`. Put a file named `cran-comments.md` in the root of your package. In this file, include the comments you would submit for the package (e.g., I agree to cran policies...this package passed all checks...etc). Rembmer to put `cran-comments.md` in the `.Rbuildignore` file in the root of your package so that `R CMD CHECK` doesn't complain. When you use the `devtools::release()` function, it will look for this file, and automatically throw in your submission comments. Doing this and using `release()` means you don't have to worry about Brian Ripley complaining about rich text emails.

## CRAN policy changes 

If you're on Twitter, watch the `#rstats` hashtag to be more likely to notice any upcoming changes in package submission policies. Also can follow Dirk's [CRAN policy watch repo](https://github.com/eddelbuettel/crp). 

## Other things

* [Hilary Parker's blog post](http://hilaryparker.com/2014/04/29/writing-an-r-package-from-scratch/)
* [Hadley's book on package development](http://r-pkgs.had.co.nz/)
