---
name: new-food-web-dataset
layout: post
title: New food web dataset
author: Scott Chamberlain
date: 2011-10-14 13:00:00 -05:00
sourceslug: _posts/2011-10-14-new-food-web-dataset.md
tags:
- ggplot2
- Networks
- igraph
- R
---


So, there is a new food web dataset out that was put in Ecological Archives <a href="http://www.esapubs.org/Archive/ecol/E092/173/default.htm">here</a>, and I thought I would play with it.  The food web is from Otago Harbour, an intertidal mudflat ecosystem in New Zealand.  The web contains 180 nodes, with 1,924 links.

Fun stuff...

{{< rawhtml >}}
<div class="separator" style="clear: both; text-align: center;">igraph, default layout plot</div><div class="separator" style="clear: both; text-align: center;"><a href="http://3.bp.blogspot.com/-2lQOoeAqGCM/Tphf9GJI8LI/AAAAAAAAFEA/EPwum7GfwXg/s1600/igraphplot.jpeg" imageanchor="1" style="margin-left: 1em; margin-right: 1em;"><img border="0" height="303" src="http://3.bp.blogspot.com/-2lQOoeAqGCM/Tphf9GJI8LI/AAAAAAAAFEA/EPwum7GfwXg/s400/igraphplot.jpeg" width="400" /></a></div><div class="separator" style="clear: both; text-align: center;"><br /></div><div class="separator" style="clear: both; text-align: center;">igraph, circle layout plot, nice</div><div class="separator" style="clear: both; text-align: center;"><a href="http://1.bp.blogspot.com/--hGl2IwHi4M/TphhJYdBO0I/AAAAAAAAFEI/8GsLuUkbYcM/s1600/igraphcircleplot.jpeg" imageanchor="1" style="margin-left: 1em; margin-right: 1em;"><img border="0" height="303" src="http://1.bp.blogspot.com/--hGl2IwHi4M/TphhJYdBO0I/AAAAAAAAFEI/8GsLuUkbYcM/s400/igraphcircleplot.jpeg" width="400" /></a></div><div class="separator" style="clear: both; text-align: center;"><br /></div><div class="separator" style="clear: both; text-align: center;">My funky little gggraph function plot</div><div class="separator" style="clear: both; text-align: center;">get the gggraph function, and make it better, <a href="https://github.com/sckott/gggraph">here at Github</a></div><div class="separator" style="clear: both; text-align: center;"><a href="http://4.bp.blogspot.com/-MBPHlFaVWos/Tphf82gWUpI/AAAAAAAAFD4/qaxCX4PP-C0/s1600/gggraphplot.jpeg" imageanchor="1" style="margin-left: 1em; margin-right: 1em;"><img border="0" height="303" src="http://4.bp.blogspot.com/-MBPHlFaVWos/Tphf82gWUpI/AAAAAAAAFD4/qaxCX4PP-C0/s400/gggraphplot.jpeg" width="400" /></a></div><div class="separator" style="clear: both; text-align: center;"><br /></div><div class="separator" style="clear: both; text-align: center;"><br /></div><br /><br /><script src="https://gist.github.com/1287545.js?file=newfoodwb.R"></script>
{{< /rawhtml >}}
