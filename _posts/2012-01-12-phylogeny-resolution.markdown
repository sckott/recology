--- 
name: phylogeny-resolution
layout: post
title: Function for phylogeny resolution
author: Scott Chamberlain
date: 2012-01-13
categories: 
- R
- ape
- phylogenetics
---

I couldn't find any functions to calculate number of polytomies, and related metrics. 

Here's a simple function that gives four metrics on a phylo tree object:

<script src="https://gist.github.com/1607531.js?file=treeresstats.R"></script>

Here's output from the gist above:

`
> dat
$trsize
[1] 15

$numpolys
[1] 1

$numpolysbytrsize
[1] 0.06666667

$proptipsdescpoly
[1] 0.2

$propnodesdich
[1] 12
`
