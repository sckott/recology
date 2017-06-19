---
name: package-dev
layout: post
title: Package dev
date: 2017-06-18
sourceslug: _posts/2017-06-18-package-dev.md
---

There are a lot of ways to make R packages. Many blog posts have covered making
R packages, but for the most part they've coverd only how they make
packages. What are the all the different ways to make R packages? I'm not going to talk about the code, etc. - but rather the different ways to approach it.

The blog posts/etc. on making R packages:

* [Writing an R package from scratch](https://hilaryparker.com/2014/04/29/writing-an-r-package-from-scratch/) - Hilary Parker
* [Developing R packages](https://github.com/jtleek/rpackages) - Jeff Leek
* [stat545 - Write your own R package](http://stat545.com/packages00_index.html) - Jenny Bryan's statistics 545 class at UBC
* [R package primer](http://kbroman.org/pkg_primer/) - Karl Boman
* [Making Your First R Package](http://tinyheero.github.io/jekyll/update/2015/07/26/making-your-first-R-package.html) - Fong Chun Chan
* [R Package Development Pictorial](http://www.mjdenny.com/R_Package_Pictorial.html) - Matthew Denny
* [Coursera course on building R packages](https://www.coursera.org/learn/r-packages)
* [R Packages](http://r-pkgs.had.co.nz/) by Hadley for a full treatment of the subject.
* From time to time you may need to reference CRAN's [Writing R Extensions](https://cran.r-project.org/doc/manuals/r-release/R-exts.html). 

## the ways

### mason

github: <https://github.com/metacran/mason> (by Gábor Csárdi)

> Note that `mason` is on CRAN, but it's a completely different package. 

Most will probably use `mason` inside of R, but you could e.g., use `mason` via `Rscript` on the cli.

```r
devtools::install_github("metacran/mason")
library(mason)
mason::mason()
```

Then you'll go through a series of prompts asking you for inormation (package name, license, your name, etc.)

Out of 16 people I talked to, 2 mentioned using `mason`.

<br>

### devtools

github: <https://github.com/hadley/devtools> (by Hadley Wickham)

Within R:

```r
install.packages("devtools")
library(devtools)
devtools::create("foobar")
```

On the cli, we can do:

```r
Rscript -e 'devtools::create("foobar")'
```

`devtools::create()` adds basic set of files needed for an R package - and also adds files assuming you use the RStudio IDE. Though you can not add RStudio files by choosing `rstudio = FALSE`.

Be aware of the default entry in the `NAMESPACE` file: `exportPattern("^[^\\.]")`. The first time you generate documentation, e.g., via `devtools::document()` your `NAMESPACE` file will be changed to only export those things you want exported, which is ideal.

Out of 16 people I talked to, 7 mentioned using `devtools`.

<br>

### IDE: RStudio

web: <https://www.rstudio.com/products/rstudio/#Desktop>

The following is a guide provided by RStudio for creating packages in RStudio IDE: [Using RStudio for package development](https://support.rstudio.com/hc/en-us/articles/200486488-Developing-Packages-with-RStudio)

When in RStudio - New Project in upper left hand corner - choose new or existing directory - choose R package - name the package, and you probably want to initialize git by checking the appropriate box.

Out of 16 people I talked to, 14 used RStudio all the time or most of the time.
It's popular, to say the least.

A noteable quote from one person I talked to:

> all rstudio all day

<br>

### web

For example, we could just create files from the Github website. e.g,. 

- New Repository
- then add files you'd need for an R package and edit those in the browser

Out of 16 people I talked to, 2 mentioned starting with creating a GitHub repository, then pulling that down, R development, etc. etc., then push back up. But no one mentioned all in browser - although see **phone dev** below.

<br>

### text editor

If you primarily work in a text editor perhaps this (using [Atom editor](https://atom.io/)):

`Rscript -e 'devtools::create("foobar")' && cd foobar && git init && atom .`

![atom](/public/img/2017-06-07-package-dev/atom.png)

Or the same for [Sublime Text](https://www.sublimetext.com/) with `subl .` instead of `atom .`

Two of 16 people I talked to mentioned using [Emacs](https://www.gnu.org/software/emacs/) exclusively or mostly. One of the 16 people mentione Sublime Text by name - that's also the editor I use (I often have RStudio and Sublime Text open for the same R package - switching between them for the features I like).

<br>

### copy/paste

Sometimes when creating a new package I know of a previous package I've created that may have similar code I want in the new one or so. So I just copy/paste essentially the old package into a new folder. Be careful when doing this: make sure to delete git history, then re-initialize git (`rm -rf .git && git init` in the new repository). Ideally you use roxygen/devtools for docs - in which case just delete all files in `man/` then when you generate docs, you get all new man files. 

<br>

### phone dev

DO NOT TRY THIS AT HOME

<blockquote class="twitter-tweet" data-cards="hidden" data-lang="en"><p lang="en" dir="ltr">tracestack: search Stack Overflow for your most recent error msg. First <a href="https://twitter.com/hashtag/rstats?src=hash">#rstats</a> package written entirely on a phone? <a href="https://t.co/IRX2luiR0N">https://t.co/IRX2luiR0N</a></p>&mdash; David Robinson (@drob) <a href="https://twitter.com/drob/status/592074817735630850">April 25, 2015</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">.<a href="https://twitter.com/drob">@drob</a> just wrote an <a href="https://twitter.com/hashtag/rstats?src=hash">#rstats</a> package from his phone, in case you wanted to feel even less productive checking twitter</p>&mdash; Hilary Parker (@hspter) <a href="https://twitter.com/hspter/status/592071435314683904">April 25, 2015</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">So that idea for throwing traceback to stackoverflow? <a href="https://twitter.com/drob">@drob</a> is actually writing it. As a package. Live on github. ON HIS PHONE. <a href="https://twitter.com/hashtag/rstats?src=hash">#rstats</a></p>&mdash; Oliver Keyes (@kopshtik) <a href="https://twitter.com/kopshtik/status/592056492397846528">April 25, 2015</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

<br>

------

<br>

### putting stuff on the web

There's many code hosting places - for brevity, we'll just cover github. 

It's a good idea to learn command line git, and related command line tools that make using git easier - if you can get work done faster you have more time to look at cat pictures!  

[hub](https://github.com/github/hub) is one git tool that I use a lot. For example, create a folder, initialize a git repo, push to github, then open the just created repo on Github:

`mkdir helloworld && cd helloworld && hub init && hub create sckott/helloworld && hub browse`

where `hub create` uses the `owner/repo` pattern

![hub](/public/img/2017-06-07-package-dev/hub.png)
