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

...Alas, I had no luck making new insights. However, I am providing the code used for this failed attempt in hopes that someone may find it useful. This is very basic code. It was roughly based off of the paper by Bluthgen et al. 2008 Ecology ([here](http://www.esajournals.org/doi/abs/10.1890/07-2121.1?journalCode=ecol)). In my code the number of interactions is set to 600, and there are 30 plant species, and 10 animal species. This assumes they share the same abundance distributions and sigma values. 

UPDATE: I changed the below code a bit to just output the metrics links per species, interaction evenness and H2. 

UPDATE on 27-Aug-12: Now using a github gist, which should actually work:

```r
# Community-Network Structure Simulation
library(bipartite)

# Set of mean and sd combinations of log-normal distribution
mu<-c(0.5,2.9,5.3)
sig<-c(0.75,1.6,2.45)

make.matrices<-function(a,b,nmats){
	plants<-round(rlnorm(n=30, meanlog=mu[a], sdlog=sig[b]))
	animals<-round(rlnorm(n=10, meanlog=mu[a], sdlog=sig[b]))
	plants<-plants*(600/sum(plants))
	animals<-animals*(600/sum(animals))
	r2dtable(nmats,animals,plants)
}

# Make matrices
matrices <- make.matrices(1,1,100)

# Calculate some network metrics-e.g., for one combination of mu and sigma
linkspersp <- numeric(100)
h2 <- numeric(100)
inteven <- numeric(100)

for(i in 1:length(matrices)){
	m<-matrix(unlist(matrices[i]),ncol=30,byrow=F)
	metrics<-t(networklevel(m,index=c("links per species","H2","interaction evenness")))
	linkspersp[i]<-metrics[1]
	h2[i]<-metrics[2]
	inteven[i]<-metrics[3]
}

linkspersp
h2
inteven
```
