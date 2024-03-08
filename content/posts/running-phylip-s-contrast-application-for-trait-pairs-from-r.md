---
name: running-phylip-s-contrast-application-for-trait-pairs-from-r
layout: post
title: Running Phylip's contrast application for trait pairs from R
author: Scott Chamberlain
date: 2011-04-26 07:40:00.004000 -05:00
sourceslug: _posts/2011-04-26-running-phylip-s-contrast-application-for-trait-pairs-from-r.md
tags:
- Phylogenetics
- R
---

Here is some code to run Phylip's contrast application from R and get the output within R to easily manipulate yourself. Importantly, the code is written specifically for trait pairs only as the regular expression work in the code specifically grabs data from contast results when only two traits are input. You could easily change the code to do N traits. Note that the p-value calculated for the chi-square statistic is not output from contrast, but is calculated within the function 'PhylipWithinSpContr'. In the code below there are two functions that make a lot of busy work easier: 'WritePhylip' and 'PhylipWithinSpContr'. The first function is nice because the formatting required for data input to Phylip programs is so, well, awkward  - and this function does it for you. The second function runs contrast and retrieves the output data. The example data set I produce in the code below has multiple individuals per species, so that contrasts are calculated taking into account within species variation. Get Phylip's contrast documentation [here](http://evolution.genetics.washington.edu/phylip/doc/contrast.html).

Note that the data input format allows only 10 characters for the species name, so I suggest if your species names are longer than 10 characters use the function abbreviate, for example, to shorten all names to no longer than 10 characters. Also, within the function WritePhylip I concatenate species names and their number of individuals per species leaving plenty of space.

Also, mess around with the options in the "system" call to get what you want. For example, I used "R", "W" and "Y", meaning replace old outfile (R), then turn on within species analyses (W), then accept all options (Y). E..g, if you don't have an old outfile, then you obviously don't need to replace the old file with the "R" command.

(p.s. I have not tried this on a windows machine).

{{< rawhtml >}}
<script src="https://gist.github.com/942176.js?file=phylip_fromR.R"></script>
{{< /rawhtml >}}

Here is example output:


{{< rawhtml >}}
<pre class="G1dpdwhmFL" style="border-bottom-style: none; border-color: initial; border-left-style: none; border-right-style: none; border-top-style: none; border-width: initial; font-family: Monaco; font-size: 9pt !important; line-height: 1.45; margin-bottom: 0px; margin-left: 0px; margin-right: 0px; margin-top: 0px; outline-color: initial; outline-style: none; outline-width: initial; white-space: pre-wrap !important;" tabindex="0"><span class="G1dpdwhmIL  ace_keyword" style="white-space: pre;">&gt; </span><span class="G1dpdwhmMK  ace_keyword">datout<br /></span>               names2   dat...1.    dat...2.<br />1      VarAIn_VarAest   0.000110   -0.000017<br />2      VarAIn_VarAest  -0.000017    0.000155<br />3      VarAIn_VarEest   0.790783   -0.063097<br />4      VarAIn_VarEest  -0.063097    0.981216<br />5      VarAIn_VarAreg   1.000000   -0.107200<br />6      VarAIn_VarAreg  -0.151800    1.000000<br />7     VarAIn_VarAcorr   1.000000   -0.127600<br />8     VarAIn_VarAcorr  -0.127600    1.000000<br />9      VarAIn_VarEreg   1.000000   -0.064300<br />10     VarAIn_VarEreg  -0.079800    1.000000<br />11    VarAIn_VarEcorr   1.000000   -0.071600<br />12    VarAIn_VarEcorr  -0.071600    1.000000<br />13    VarAOut_VarEest   0.790734   -0.063104<br />14    VarAOut_VarEest  -0.063104    0.981169<br />15    VarAOut_VarEreg   1.000000   -0.064300<br />16    VarAOut_VarEreg  -0.079800    1.000000<br />17   VarAOut_VarEcorr   1.000000   -0.071600<br />18   VarAOut_VarEcorr  -0.071600    1.000000<br />19    logL_withvar_df -68.779770    6.000000<br />20 logL_withoutvar_df -68.771450    3.000000<br />21           chisq_df  -0.016640    3.000000<br />22            chisq_p   1.000000 -999.000000</pre>
{{< /rawhtml >}}
