--- 
name: phylogeny-resolution
layout: post
title: Function for phylogeny resolution
author: Scott Chamberlain
date: 2012-01-13
sourceslug: _posts/2012-01-12-phylogeny-resolution.md
tags: 
- R
- ape
- phylogenetics
---

UPDATE:  Yeah, so the treeresstats function had a problem in one of the calculations.  I fixed that and added some more calulcations to the function. 

I couldn't find any functions to calculate number of polytomies, and related metrics. 

Here's a simple function that gives four metrics on a phylo tree object:

<script src="https://gist.github.com/1607531.js?file=treeresstats.R"></script>

Here's output from the gist above:

{% highlight r %}
$trsize_tips
[1] 15

$trsize_nodes
[1] 13

$numpolys
[1] 1

$numpolysbytrsize_tips
[1] 0.06666667

$numpolysbytrsize_nodes
[1] 0.07692308

$proptipsdescpoly
[1] 0.2

$propnodesdich
[1] 0.9230769
{% endhighlight %}

And an example with many trees:

<table border="1">
	<tr>
		<th>trsize_tips</th>
		<th>trsize_nodes</th>
		<th>numpolys</th>
		<th>numpolysbytrsize_tips</th>
		<th>numpolysbytrsize_nodes</th>
		<th>proptipsdescpoly</th>
		<th>propnodesdich</th>
	</tr>
	<tr>
		<td>20</td> <td>13</td> <td>4</td> <td>0.20</td> <td>0.31</td> <td>0.7</td> <td>0.69</td>
	</tr>
	<tr>
		<td>20</td> <td>7</td> <td>3</td> <td>0.15</td> <td>0.43</td> <td>0.9</td> <td>0.57</td>
	</tr>
	<tr>
		<td>20</td> <td>11</td> <td>6</td> <td>0.30</td> <td>0.55</td> <td>1.0</td> <td>0.45</td>
	</tr>
	<tr>
		<td>20</td> <td>13</td> <td>4</td> <td>0.20</td> <td>0.31</td> <td>0.7</td> <td>0.69</td>
	</tr>
	<tr>
		<td>20</td> <td>9</td> <td>5</td> <td>0.25</td> <td>0.56</td> <td>1.0</td> <td>0.44</td>
	</tr>
</table>
