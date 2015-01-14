--- 
name: ecological-networks-from-abundance
layout: post
title: Ecological networks from abundance distributions
author: Scott Chamberlain
date: 2011-01-06 08:58:00.001000 -06:00
sourceslug: _posts/2011-01-06-ecological-networks-from-abundance.md
tags: 
- Ecology
- Networks
- R
---

Another grad student and I tried recently to make a contribution to our understanding of the relationship between ecological network structure (e.g., nestedness) and community structure (e.g., evenness)...

...Alas, I had no luck making new insights. However, I am providing the code used for this failed attempt in hopes that someone may find it useful. This is very basic code. It was roughly based off of the paper by Bluthgen et al. 2008 Ecology (<a href="http://www.esajournals.org/doi/abs/10.1890/07-2121.1?journalCode=ecol">here</a>). In my code the number of interactions is set to 600, and there are 30 plant species, and 10 animal species. This assumes they share the same abundance distributions and sigma values. 

UPDATE: I changed the below code a bit to just output the metrics links per species, interaction evenness and H2. 

UPDATE on 27-Aug-12: Now using a github gist, which should actually work:


<script src="https://gist.github.com/3493789.js?file=matricesfromabddist.r"></script>
