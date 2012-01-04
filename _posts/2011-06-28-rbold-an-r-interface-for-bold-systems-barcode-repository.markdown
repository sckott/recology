--- 
name: rbold-an-r-interface-for-bold-systems-barcode-repository
layout: post
title: "rbold: An R Interface for Bold Systems barcode repository"
date: 2011-06-28 09:27:00.001000 -05:00
categories: 
- openaccess
- API
- R
- Datasets
---
Have you ever wanted to <a href="http://services.boldsystems.org/index.php?page=1_esearch&amp;status=">search</a> and <a href="http://services.boldsystems.org/index.php?page=2_efetch&amp;status=">fetch</a> barcode data from <a href="http://www.boldsystems.org/views/login.php">Bold Systems</a>?<br /><br />I am developing functions to interface with Bold from R. I just started, but hopefully folks will find it useful.<br /><br />The code is at Github <a href="https://github.com/ropensci/rbold">here</a>. The two functions are still very buggy, so please bring up issues below, or in the Issues area on Github. For example, some searches work and other similar searches don't. Apologies in advance for the bugs.<br /><br />Below is a screenshot of an example query using function getsampleids to get barcode identifiers for specimens. You can then use getseqs function to grab barcode data for specific specimens or many specimens.<br /><img alt="Screen shot 2011-06-28 at 9.24.00 AM.png" height="267" src="http://cl.ly/1V1y1Q1A0t062F2y2308/Screen_shot_2011-06-28_at_9.24.00_AM.png" width="400" />
