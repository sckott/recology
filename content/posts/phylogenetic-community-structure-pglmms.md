--- 
name: phylogenetic-community-structure-pglmms
layout: post
title: "Phylogenetic community structure: PGLMMs"
author: Scott Chamberlain
date: 2011-10-13 10:18:00.001000 -05:00
sourceslug: _posts/2011-10-13-phylogenetic-community-structure-pglmms.md
tags: 
- Evolution
- Papers
- Ecology
- Statistics
- Picante
- R
---

So, [I've blogged about this topic before](http://r-ecology.blogspot.com/2011/01/new-approach-to-analysis-of.html), way back on 5 Jan this year.  
  
Matt Helmus, a postdoc in the [Wootton lab at the University of Chicago](http://woottonlab.uchicago.edu/), published a paper with Anthony Ives in Ecological Monographs this year ([abstract here](http://www.esajournals.org/doi/abs/10.1890/10-1264.1)). The paper addressed a new statistical approach to phylogenetic community structure.  
  
As I said in the original post, part of the power of the PGLMM (phylogenetic generalized linear mixed models) approach is that you don't have to conduct quite so many separate statistical tests as with the previous null model/randomization approach.  
  
Their original code was written in Matlab. Here I provide the R code that Matt has so graciously shared with me. There are four functions and a fifth file has an example use case. The example and output are shown below.  
  
Look for the inclusion of Matt's PGLMM to the picante R package in the future.  
  
Here are links to the files as GitHub gists:  
PGLMM.data.R: [https://gist.github.com/1278205](https://gist.github.com/1278205)  
PGLMM.fit.R: [https://gist.github.com/1284284](https://gist.github.com/1284284)  
PGLMM.reml.R: [https://gist.github.com/1284287](https://gist.github.com/1284287)  
PGLMM.sim.R: [https://gist.github.com/1284288](https://gist.github.com/1284288)  
PGLMM\_example.R: [https://gist.github.com/1284442](https://gist.github.com/1284442)

Enjoy!

The example

{{< rawhtml >}}
<script src="https://gist.github.com/1284477.js?file=PGLMM_exampleoutput.R"></script>
{{< /rawhtml >}}

![](http://3.bp.blogspot.com/-ODHXaozYSFY/Tpb9qSXbbHI/AAAAAAAAFDg/hLHlGDiYRSw/s640/plot1.png)
![](http://2.bp.blogspot.com/-tQYXCZWIMYs/Tpb9q5zF4EI/AAAAAAAAFDo/_iOxMYf5DsI/s640/plot2.png)
![](http://1.bp.blogspot.com/-fowoTDI0chc/Tpb9rMAlswI/AAAAAAAAFDw/7pvqZ-jpECk/s640/plot3.png)
