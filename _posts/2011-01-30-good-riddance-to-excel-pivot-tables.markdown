---
name: good-riddance-to-excel-pivot-tables
layout: post
title: "Good riddance to Excel pivot tables"
date: 2011-01-30 22:36:00.0000 -06:00
categories: 
- plyr
- reshape2
- R
---

Excel pivot tables have been how I have reorganized data...up until now. These are just a couple of examples why R is superior to Excel for reorganizing data:

UPDATE: I fixed the code to use 'dcast' instead of 'cast'. And library(ggplot2) instead of library(plyr) [plyr is called along with ggplot2]. Thanks Bob!

Also, see another post on this topic [here][].


<script src="https://gist.github.com/1578361.js?file=goodriddance.R"></script>


![Figure](/pivottable1.png)

[here]: http://news.mrdwab.com/2010/08/08/using-the-reshape-packagein-r/