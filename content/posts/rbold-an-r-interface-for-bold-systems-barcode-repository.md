--- 
name: rbold-an-r-interface-for-bold-systems-barcode-repository
layout: post
title: "rbold: An R Interface for Bold Systems barcode repository"
author: Scott Chamberlain
date: 2011-06-28 09:27:00.001000 -05:00
sourceslug: _posts/2011-06-28-rbold-an-r-interface-for-bold-systems-barcode-repository.md
tags: 
- openaccess
- API
- R
- Datasets
---

Have you ever wanted to [search](http://services.boldsystems.org/index.php?page=1_esearch&status=) and [fetch](http://services.boldsystems.org/index.php?page=2_efetch&status=) barcode data from [Bold Systems](http://www.boldsystems.org/views/login.php)?  
  
I am developing functions to interface with Bold from R. I just started, but hopefully folks will find it useful.  
  
The code is at Github [here](https://github.com/ropensci/rbold). The two functions are still very buggy, so please bring up issues below, or in the Issues area on Github. For example, some searches work and other similar searches don't. Apologies in advance for the bugs.  
  
Below is a screenshot of an example query using function getsampleids to get barcode identifiers for specimens. You can then use getseqs function to grab barcode data for specific specimens or many specimens.  
![Screen shot 2011-06-28 at 9.24.00 AM.png](http://cl.ly/1V1y1Q1A0t062F2y2308/Screen_shot_2011-06-28_at_9.24.00_AM.png)
