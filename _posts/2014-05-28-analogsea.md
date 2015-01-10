---
name: analogsea
layout: post
title: analogsea - an R client for the Digital Ocean API
date: 2014-05-28
author: Scott Chamberlain
sourceslug: _drafts/2014-05-28-analogsea.Rmd
tags:
- R
- API
- cloud
---


I think this package name is my best yet. Maybe it doesn't make sense though? At least it did at the time...

Anyway, the main motivation for this package was to be able to automate spinning up Linux boxes to do cloud R/RStudio work. Of course if you are a command line native this is all easy for you, but if you are afraid of the command line and/or just don't want to deal with it, this tool will hopefully help. 

Most of the functions in this package wrap the Digital Ocean API. So you can do things like create a new _droplet_, get information on your droplets, _destroy_ droplets, get information on available images, make snapshots, etc. Basically everything you can do from their website you can do here. Note that all functions are prefixed with `do_` (for Digital Ocean). 

The droplet creation part is what we can leverage to spin up a cloud machine to then install R on, and optionally RStudio server, and even RStudio Shiny server. This allows you to stay within R entirely, not having to go to `ssh` into the Linux machine itself or go to the Digital Ocean website (after initial setup of course). 

If you try this, I recommend using this on R on the command line as you can more easily kill the R session if something goes wrong, and quickly open a new tab/window to `ssh` into the Linux machine if you want.

First, installation


```r
devtools::install_github("sckott/analogsea")
```

Load the library


```r
library("analogsea")
```

Firt, authenticate. This will ask for your Digital Ocean details. You can enter them each R session, or store them in your `.Renviron` file. After successful authentication, each function simply looks for your auth details with `Sys.getenv()`.


```r
do_auth()
```

List available regions


```r
sapply(do_regions()$regions, "[[", "name")
```

```
## [1] "San Francisco 1" "New York 2"      "Amsterdam 2"     "Singapore 1"
```

List available images


```r
sapply(do_images()$images, "[[", "name")
```

```
##  [1] "rstudioserverssh_snap"                          
##  [2] "CentOS 5.8 x64"                                 
##  [3] "CentOS 5.8 x32"                                 
##  [4] "Debian 6.0 x64"                                 
##  [5] "Debian 6.0 x32"                                 
##  [6] "Ubuntu 10.04 x64"                               
##  [7] "Ubuntu 10.04 x32"                               
##  [8] "Arch Linux 2013.05 x64"                         
##  [9] "Arch Linux 2013.05 x32"                         
## [10] "CentOS 6.4 x32"                                 
## [11] "CentOS 6.4 x64"                                 
## [12] "Ubuntu 12.04.4 x32"                             
## [13] "Ubuntu 12.04.4 x64"                             
## [14] "Ubuntu 13.10 x32"                               
## [15] "Ubuntu 13.10 x64"                               
## [16] "Fedora 19 x32"                                  
## [17] "Fedora 19 x64"                                  
## [18] "MEAN on Ubuntu 12.04.4"                         
## [19] "Ghost 0.4.2 on Ubuntu 12.04"                    
## [20] "Wordpress on Ubuntu 13.10"                      
## [21] "Ruby on Rails on Ubuntu 12.10 (Nginx + Unicorn)"
## [22] "Redmine on Ubuntu 12.04"                        
## [23] "Ubuntu 14.04 x32"                               
## [24] "Ubuntu 14.04 x64"                               
## [25] "Fedora 20 x32"                                  
## [26] "Fedora 20 x64"                                  
## [27] "Dokku v0.2.3 on Ubuntu 14.04"                   
## [28] "Debian 7.0 x64"                                 
## [29] "Debian 7.0 x32"                                 
## [30] "CentOS 6.5 x64"                                 
## [31] "CentOS 6.5 x32"                                 
## [32] "Docker 0.11.1 on Ubuntu 13.10 x64"              
## [33] "Django on Ubuntu 14.04"                         
## [34] "LAMP on Ubuntu 14.04"                           
## [35] "node-v0.10.28 on Ubuntu 14.04"                  
## [36] "GitLab 6.9.0 CE"
```

List available sizes


```r
do.call(rbind, do_sizes()$sizes)
```

```
##       id name    slug    memory cpu disk cost_per_hour cost_per_month
##  [1,] 66 "512MB" "512mb" 512    1   20   0.00744       "5.0"         
##  [2,] 63 "1GB"   "1gb"   1024   1   30   0.01488       "10.0"        
##  [3,] 62 "2GB"   "2gb"   2048   2   40   0.02976       "20.0"        
##  [4,] 64 "4GB"   "4gb"   4096   2   60   0.05952       "40.0"        
##  [5,] 65 "8GB"   "8gb"   8192   4   80   0.1191        "80.0"        
##  [6,] 61 "16GB"  "16gb"  16384  8   160  0.2381        "160.0"       
##  [7,] 60 "32GB"  "32gb"  32768  12  320  0.4762        "320.0"       
##  [8,] 70 "48GB"  "48gb"  49152  16  480  0.7143        "480.0"       
##  [9,] 69 "64GB"  "64gb"  65536  20  640  0.9524        "640.0"
```

Let's create a droplet:


```r
(res <- do_droplets_new(name="foo", size_slug = '512mb', image_slug = 'ubuntu-14-04-x64', region_slug = 'sfo1', ssh_key_ids = 89103))
```

```r
$status
[1] "OK"

$droplet
$droplet$id
[1] 1733336

$droplet$name
[1] "foo"

$droplet$image_id
[1] 3240036

$droplet$size_id
[1] 66

$droplet$event_id
[1] 25278892


attr(,"class")
[1] "dodroplet"
```



List my droplets


```r
do_droplets_get()
```

```
## $status
## [1] "OK"
## 
## $droplets
## $droplets[[1]]
## $droplets[[1]]$id
## [1] 1733336
## 
## $droplets[[1]]$name
## [1] "foo"
## 
## $droplets[[1]]$image_id
## [1] 3240036
## 
## $droplets[[1]]$size_id
## [1] 66
## 
## $droplets[[1]]$region_id
## [1] 3
## 
## $droplets[[1]]$backups_active
## [1] FALSE
## 
## $droplets[[1]]$ip_address
## [1] "107.170.211.252"
## 
## $droplets[[1]]$private_ip_address
## NULL
## 
## $droplets[[1]]$locked
## [1] FALSE
## 
## $droplets[[1]]$status
## [1] "active"
## 
## $droplets[[1]]$created_at
## [1] "2014-05-28T05:59:22Z"
```

Cool, we have a new Linux box with 512 mb RAM, running Ubuntu 14.04 in the SF region. Notice that I'm using my SSH key here. If you don't use your SSH key, Digital Ocean will email you a password, which you then use. We just have to wait a bit (sometimes 20 seconds, sometimes a few minutes) for it to spin up.

Now we can install stuff. Here, I'll install R, and RStudio Server. This step prints out the progress as you would see if you did `ssh` into the box itself outside of R. The RStudio Server instance will pop up in your default browser when this operation is done. 


```r
do_install(res$droplet$id, what='rstudio', usr='hey', pwd='there')
```

<img src="/public/img/2014-05-28-analogsea/rstudioinstance.png" width="100%">

You can install some things like the `libcurl` and `libxml` libraries too with the `deps` parameter.

When you're done, you can destroy your droplet from R too


```r
do_droplets_destroy(res$droplet$id)
```

```
## $status
## [1] "OK"
## 
## $event_id
## [1] 25279124
```

Let me know if you have any thoughts :)
