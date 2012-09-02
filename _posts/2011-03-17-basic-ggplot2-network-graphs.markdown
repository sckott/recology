--- 
name: basic-ggplot2-network-graphs
layout: post
title: basic ggplot2 network graphs
author: Scott Chamberlain
date: 2011-03-17 08:35:00 -05:00
tags: 
- ggplot2
- bipartite
- Networks
- igraph
- R
---
I have been looking around on the web and have not found anything yet related to using ggplot2 for making graphs/networks. I put together a few functions to make very simple graphs. The bipartite function especially is not ideal, as of course we only want to allow connections between unlike nodes, not all nodes. These functions do not, obviously, take full advantage of the power of ggplot2, but&nbsp;it’s a start.

<br /><br /><br />

<script src="https://gist.github.com/3601320.js?file=gggraph.r"></script>

<img src="/img/gggraph/erdos.jpeg" width="500" height="500">
<img src="/img/gggraph/barabasi.jpeg" width="500" height="500">
<img src="/img/gggraph/grg.jpeg" width="500" height="500">
<img src="/img/gggraph/growing.jpeg" width="500" height="500">
<img src="/img/gggraph/watts.jpeg" width="500" height="500">
<img src="/img/gggraph/grg-bipartite.jpeg" width="500" height="500">