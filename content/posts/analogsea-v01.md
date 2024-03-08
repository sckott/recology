---
name: analogsea-v01
layout: post
title: analogsea - v0.1 notes
date: 2014-06-18
author: Scott Chamberlain
sourceslug: _drafts/2014-06-18-analogsea-v01.Rmd
tags:
- R
- API
- cloud
---


My [last blog ](http://recology.info/2014/05/analogsea/) post introduced the R package I'm working on `analogsea`, an R client for the Digital Ocean API.

Things have changed a bit, including fillig out more functions for all API endpoints, and incorparting feedback from Hadley and Karthik. The package is as `v0.1` now, so I thought I'd say a few things about how it works.

Note that Digital Ocean's v2 API is in beta stage now, so the current version of `analogsea` at `v0.1` works with their v1 API. The [v2 branch of analogsea](https://github.com/sckott/analogsea/tree/v2) is being developed for their v2 API.

If you sign up for an account with Digital Ocean use this referral link: [https://www.digitalocean.com/?refcode=0740f5169634](https://www.digitalocean.com/?refcode=0740f5169634) so I can earn some credits. thx :)

First, installation

Note: I did try to submit to CRAN, but Ripley complained about the package name so I'd rather not waste my time esp since people using this likely will already know about `install_github()`.


```r
devtools::install_github("sckott/analogsea")
```

Load the library


```r
library("analogsea")
```

```
## Loading required package: magrittr
```

Authenticate has changed a bit. Whereas auth details were stored as environment variables before, I'm just using R's options. `do_auth()` will ask for your Digital Ocean details. You can enter them each R session, or store them in your `.Rprofile` file. After successful authentication, each function simply looks for your auth details with `getOption()`.  You don't have to use this function first, though if you don't your first call to another function will ask for auth details.


```r
do_auth()
```

`sizes`, `images`, and `keys` functions have changed a bit, by default outputting a `data.frame` now.

List available regions


```r
regions()
```

```
##   id            name slug
## 1  3 San Francisco 1 sfo1
## 2  4      New York 2 nyc2
## 3  5     Amsterdam 2 ams2
## 4  6     Singapore 1 sgp1
```

List available sizes


```r
sizes()
```

```
##   id  name  slug memory cpu disk cost_per_hour cost_per_month
## 1 66 512MB 512mb    512   1   20       0.00744            5.0
## 2 63   1GB   1gb   1024   1   30       0.01488           10.0
## 3 62   2GB   2gb   2048   2   40       0.02976           20.0
## 4 64   4GB   4gb   4096   2   60       0.05952           40.0
## 5 65   8GB   8gb   8192   4   80       0.11905           80.0
## 6 61  16GB  16gb  16384   8  160       0.23810          160.0
## 7 60  32GB  32gb  32768  12  320       0.47619          320.0
## 8 70  48GB  48gb  49152  16  480       0.71429          480.0
## 9 69  64GB  64gb  65536  20  640       0.95238          640.0
```

List available images


```r
head(images())
```

```
##        id                  name             slug distribution public sfo1
## 1 3209452 rstudioserverssh_snap             <NA>       Ubuntu  FALSE    1
## 2    1601        CentOS 5.8 x64   centos-5-8-x64       CentOS   TRUE    1
## 3    1602        CentOS 5.8 x32   centos-5-8-x32       CentOS   TRUE    1
## 4   12573        Debian 6.0 x64   debian-6-0-x64       Debian   TRUE    1
## 5   12575        Debian 6.0 x32   debian-6-0-x32       Debian   TRUE    1
## 6   14097      Ubuntu 10.04 x64 ubuntu-10-04-x64       Ubuntu   TRUE    1
##   nyc1 ams1 nyc2 ams2 sgp1
## 1   NA   NA   NA   NA   NA
## 2    1    1    1    1    1
## 3    1    1    1    1    1
## 4    1    1    1    1    1
## 5    1    1    1    1    1
## 6    1    1    1    1    1
```

List ssh keys


```r
keys()
```

```
## $ssh_keys
## $ssh_keys[[1]]
## $ssh_keys[[1]]$id
## [1] 89103
##
## $ssh_keys[[1]]$name
## [1] "Scott Chamberlain"
```

One change that's of interest is that most of the various `droplets_*()` functions take in the outputs of other `droplets_*()` functions. This means that we can pipe outputs of one `droplets_*()` function to another, including non-`droplet_*` functions (see examples).

Let's create a droplet:


```r
(res <- droplets_new(name="foo", size_slug = '512mb', image_slug = 'ubuntu-14-04-x64', region_slug = 'sfo1', ssh_key_ids = 89103))
```

```r
$droplet
$droplet$id
[1] 1880805

$droplet$name
[1] "foo"

$droplet$image_id
[1] 3240036

$droplet$size_id
[1] 66

$droplet$event_id
[1] 26711810
```

List my droplets

This function used to be `do_droplets_get()`


```r
droplets()
```

```
## $droplet_ids
## [1] 1880805
##
## $droplets
## $droplets[[1]]
## $droplets[[1]]$id
## [1] 1880805
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
## [1] "162.243.152.56"
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
## [1] "2014-06-18T14:15:35Z"
##
##
##
## $event_id
## NULL
```

As mentioned above we can now pipe output of `droplet*()` functions to other `droplet*()` functions.

Here, pipe output of lising droplets `droplets()` to the `events()` function


```r
droplets() %>% events()
```

```
## Error: No event id found
```

In this case there were no event ids to get event data on.

Here, we'll get details for the droplet we just created, then pipe that to `droplets_power_off()`


```r
droplets(1880805) %>% droplets_power_off
```

```
## $droplet_ids
## [1] 1880805
##
## $droplets
## $droplets$droplet_ids
## [1] 1880805
##
## $droplets$droplets
## $droplets$droplets$id
## [1] 1880805
##
## $droplets$droplets$name
## [1] "foo"
##
## $droplets$droplets$image_id
## [1] 3240036
##
## $droplets$droplets$size_id
## [1] 66
##
## $droplets$droplets$region_id
## [1] 3
##
## $droplets$droplets$backups_active
## [1] FALSE
##
## $droplets$droplets$ip_address
## [1] "162.243.152.56"
##
## $droplets$droplets$private_ip_address
## NULL
##
## $droplets$droplets$locked
## [1] FALSE
##
## $droplets$droplets$status
## [1] "active"
##
## $droplets$droplets$created_at
## [1] "2014-06-18T14:15:35Z"
##
## $droplets$droplets$backups
## list()
##
## $droplets$droplets$snapshots
## list()
##
##
## $droplets$event_id
## NULL
##
##
## $event_id
## [1] 26714109
```

Then pipe it again to `droplets_power_on()`




```r
droplets(1880805) %>%
  droplets_power_on
```

```
## $droplet_ids
## [1] 1880805
##
## $droplets
## $droplets$droplet_ids
## [1] 1880805
##
## $droplets$droplets
## $droplets$droplets$id
## [1] 1880805
##
## $droplets$droplets$name
## [1] "foo"
##
## $droplets$droplets$image_id
## [1] 3240036
##
## $droplets$droplets$size_id
## [1] 66
##
## $droplets$droplets$region_id
## [1] 3
##
## $droplets$droplets$backups_active
## [1] FALSE
##
## $droplets$droplets$ip_address
## [1] "162.243.152.56"
##
## $droplets$droplets$private_ip_address
## NULL
##
## $droplets$droplets$locked
## [1] FALSE
##
## $droplets$droplets$status
## [1] "off"
##
## $droplets$droplets$created_at
## [1] "2014-06-18T14:15:35Z"
##
## $droplets$droplets$backups
## list()
##
## $droplets$droplets$snapshots
## list()
##
##
## $droplets$event_id
## NULL
##
##
## $event_id
## [1] 26714152
```

```r
Sys.sleep(6)
droplets(1880805)$droplets$status
```

```
## [1] "off"
```

Why not use more pipes?


```r
droplets(1880805) %>%
  droplets_power_off %>%
  droplets_power_on %>%
  events
```

-------

Last time I talked about installing R, RStudio, etc. on a droplet. I'm still working out bugs in that stuff, but do test out so it can get better faster. See `do_install()`.
