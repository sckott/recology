--- 
name: phylogenetic-signal-simulations
layout: post
title: phylogenetic signal simulations
date: 2011-05-18 08:13:00 -05:00
categories: 
- ggplot2
- ape
- Phylogenetics
---
<span class="Apple-style-span" style="color: #333333; font-family: Arial, Tahoma, Helvetica, FreeSans, sans-serif; font-size: 14px; line-height: 18px;">I did a little simulation to examine how K and lambda vary in response to tree size (and how they compare to each other on the same simulated trees). I use Liam Revell's functions fastBM to generate traits, and phylosig to measure phylogenetic signal.<br /><br />Two observations:&nbsp;</span><br /><span class="Apple-style-span" style="color: #333333; font-family: Arial, Tahoma, Helvetica, FreeSans, sans-serif; font-size: 14px; line-height: 18px;"><br /></span><br /><span class="Apple-style-span" style="color: #333333; font-family: Arial, Tahoma, Helvetica, FreeSans, sans-serif; font-size: 14px; line-height: 18px;">First, it seems that lambda is more sensitive than K to tree size, but then lambda levels out at about 40 species, whereas K continues to vary around a mean of 1.<br /><br />Second, K is more variable than lambda at all levels of tree size (compare standard error bars).<br /><br />Does this make sense to those smart folks out there?<br /><br /><script src="https://gist.github.com/977999.js?file=phylogeneticsignal_sim.R"></script><br /></span><br /><br /><div class="separator" style="clear: both; text-align: center;"><a href="http://4.bp.blogspot.com/-hY0LQNsBzWc/TdNOJFMZzkI/AAAAAAAAEcg/SYeSCgUfyOY/s1600/physig_sim.jpeg" imageanchor="1" style="clear: left; float: left; margin-bottom: 1em; margin-right: 1em;"><img border="0" height="290" src="http://4.bp.blogspot.com/-hY0LQNsBzWc/TdNOJFMZzkI/AAAAAAAAEcg/SYeSCgUfyOY/s400/physig_sim.jpeg" width="400" /></a></div>
