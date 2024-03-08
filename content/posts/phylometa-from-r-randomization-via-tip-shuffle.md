---
name: phylometa-from-r-randomization-via-tip-shuffle
layout: post
title: "Phylometa from R: Randomization via Tip Shuffle"
author: Scott Chamberlain
date: 2011-04-16 13:44:00.004000 -05:00
sourceslug: _posts/2011-04-16-phylometa-from-r-randomization-via-tip-shuffle.md
tags:
- meta-analysis
- Methods
- Evolution
- Phylogenetics
- R
---

---UPDATE: I am now using code formatting from gist.github, so I replaced the old prettyR code (sorry guys). The github way is much easier and prettier. I hope readers like the change.

[I wrote earlier](/posts/2011-04-01-phylometa-from-r-udpate/) about some code I wrote for running Phylometa (software to do phylogenetic meta-analysis) from R.

I have been concerned about what exactly is the right penalty for including phylogeny in a meta-analysis. E.g.: AIC is calculated from Q in Phylometa, and Q increases with tree size.

So, I wrote some code to shuffle the tips of your tree N number of times, run Phylometa, and extract just the "Phylogenetic MA" part of the output. So, we compare the observed output (without tip shuffling) to the distribution of the tip shuffled output, and we can calculate a P-value from that. The code I wrote simply extracts the pooled effect size for fixed and also random-effects models. But you could change the code to extract whatever you like for the randomization.

I think the point of this code is not to estimate your pooled effects, etc., but may be an alternative way to compare traditional to phylogenetic MA where hopefully simply incorporating a tree is not penalizing the meta-analysis so much that you will always accept the traditional MA as better.

Get the code [here](https://gist.github.com/925343#file_phylometa_rand_fxn_one.r), and also below. Get the example [tree file](http://wp.me/PRT1F-2R) and [data file](http://wp.me/PRT1F-2S), named "phylogeny.txt" and "metadata\_2g.txt", respectively below (or use your own data!). You need the file "phylometa\_fxn.r" from my website, get [here](https://gist.github.com/939970), but just call it using source as seen below.

{{< rawhtml >}}
<script src="https://gist.github.com/925343.js?file=phylometa_rand_fxn_one.R"></script>
{{< /rawhtml >}}`

As you can see, the observed values fall well within the distribution of values obtained from shuffling tips.  P-values were 0.64 and 0.68 for fixed- and random-effects MA's, respectively. This suggests, to me at least, that the traditional (distribution of tip shuffled analyses, the histograms below) and phylogenetic (red lines) MA's are not different. The way I would use this is as an additional analysis to the actual Phylometa output.

![](https://4.bp.blogspot.com/-fpEjXUBvAw8/TanftVw49QI/AAAAAAAAEbY/z9rJKThxRMo/s400/metadata_2g.txt.jpeg)
