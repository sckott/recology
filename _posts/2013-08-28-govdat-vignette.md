---
name: govdat-vignette
layout: post
title: govdat - SunlightLabs and New York Times Congress data via R
date: 2013-08-28
author: Scott Chamberlain
tags:
- r
- API
- government
- transparency
---

I started an R package a while back, and a few people have shown interest, so I thought it was time to revist the code. govdat is an interface to various APIs for government data: currently the Sunlight Labs APIs, and the New York Times congress API. Returned objects from functions are simple lists. In future versions of govdat, I may change how data is returned. The following are examples (which is also the package vignette) of using the Sunlight Labs API. I will add examples of using the New York Times Congress API once their site is up again; I'm doing this on 2013-08-28, just after the takedown of their site.

I show just a bit of each data object returned for brevity. And yes, I realize this is not related at all to ecology. 

You will need an API key to use both Sunlight Labs APIs and the New York Times APIs. Get your API key at Sunlight Labs [here](http://sunlightfoundation.com/api/) and NYT [here](http://developer.nytimes.com/docs/congress_api). You can pass in your key within each function or you can put the key in your .Rprofile file on your machine (which is read from the default R working directory) and the key will be read in automatically inside the function. I recommend the latter option. 

Do let me know of bugs or feature requests over at the Github issues page [here](https://github.com/sckott/govdat/issues).

********************

#### Install govdat


{% highlight r %}
install.packages("devtools")
library(devtools)
install_github("govdat", "sckott")
{% endhighlight %}


********************

#### Load govdat


{% highlight r %}
library(govdat)
{% endhighlight %}


********************

#### Gets details (subcommittees + membership) for a committee by id.


{% highlight r %}
key <- getOption("SunlightLabsKey")
out <- sll_cg_getcommittees(id = "JSPR")
out$response$committee$members[[1]]$legislator[1:5]
{% endhighlight %}



{% highlight text %}
$website
[1] "http://www.alexander.senate.gov"

$fax
[1] "202-228-3398"

$govtrack_id
[1] "300002"

$firstname
[1] "Lamar"

$chamber
[1] "senate"
{% endhighlight %}


********************

#### Gets a list of all committees that a member serves on, including subcommittes.


{% highlight r %}
out <- sll_cg_getcommitteesallleg(bioguide_id = "S000148")
out$response$committees[[1]]
{% endhighlight %}



{% highlight text %}
$committee
$committee$chamber
[1] "Senate"

$committee$id
[1] "SSRA"

$committee$name
[1] "Senate Committee on Rules and Administration"
{% endhighlight %}


********************

#### Get districts for a latitude/longitude.


{% highlight r %}
out <- sll_cg_getdistrictlatlong(latitude = 35.778788, longitude = -78.787805)
out$response$districts
{% endhighlight %}



{% highlight text %}
[[1]]
[[1]]$district
[[1]]$district$state
[1] "NC"

[[1]]$district$number
[1] "2"
{% endhighlight %}


********************

#### Get districts that overlap for a certain zip code.


{% highlight r %}
out <- sll_cg_getdistrictzip(zip = 27511)
out$response$districts
{% endhighlight %}



{% highlight text %}
[[1]]
[[1]]$district
[[1]]$district$state
[1] "NC"

[[1]]$district$number
[1] "2"



[[2]]
[[2]]$district
[[2]]$district$state
[1] "NC"

[[2]]$district$number
[1] "4"



[[3]]
[[3]]$district
[[3]]$district$state
[1] "NC"

[[3]]$district$number
[1] "13"
{% endhighlight %}


********************

#### Search congress people and senate members.


{% highlight r %}
out <- sll_cg_getlegislatorsearch(name = "Reed")
out$response$results[[1]]$result$legislator[1:5]
{% endhighlight %}



{% highlight text %}
$website
[1] "http://www.reed.senate.gov"

$fax
[1] "202-224-4680"

$govtrack_id
[1] "300081"

$firstname
[1] "John"

$chamber
[1] "senate"
{% endhighlight %}


********************

#### Search congress people and senate members for a zip code.


{% highlight r %}
out <- sll_cg_legislatorsallforzip(zip = 77006)
library(plyr)
ldply(out$response$legislators, function(x) data.frame(x$legislator[c("firstname", 
    "lastname")]))
{% endhighlight %}



{% highlight text %}
  firstname    lastname
1    Sheila Jackson Lee
2       Ted        Cruz
3      John      Cornyn
4       Ted         Poe
{% endhighlight %}


********************

#### Find the popularity of a phrase over a period of time.

##### Get a list of how many times the phrase "united states" appears in the Congressional Record in each month between January and June, 2010:


{% highlight r %}
sll_cw_timeseries(phrase = "united states", start_date = "2009-01-01", end_date = "2009-04-30", 
    granularity = "month")
{% endhighlight %}



{% highlight text %}
4 records returned
{% endhighlight %}



{% highlight text %}
  count      month
1  3805 2009-01-01
2  3512 2009-02-01
3  6018 2009-03-01
4  2967 2009-04-01
{% endhighlight %}


##### Plot data


{% highlight r %}
library(ggplot2)
dat <- sll_cw_timeseries(phrase = "climate change")
{% endhighlight %}



{% highlight text %}
1354 records returned
{% endhighlight %}



{% highlight r %}
ggplot(dat, aes(day, count)) + geom_line() + theme_grey(base_size = 20)
{% endhighlight %}

![center](/public/img/2013-08-28-govdat-vignette/sll_cw_timeseries2.png) 


##### Plot more data


{% highlight r %}
dat_d <- sll_cw_timeseries(phrase = "climate change", party = "D")
{% endhighlight %}



{% highlight text %}
908 records returned
{% endhighlight %}



{% highlight r %}
dat_d$party <- rep("D", nrow(dat_d))
dat_r <- sll_cw_timeseries(phrase = "climate change", party = "R")
{% endhighlight %}



{% highlight text %}
623 records returned
{% endhighlight %}



{% highlight r %}
dat_r$party <- rep("R", nrow(dat_r))
dat_both <- rbind(dat_d, dat_r)
ggplot(dat_both, aes(day, count, colour = party)) + geom_line() + theme_grey(base_size = 20) + 
    scale_colour_manual(values = c("blue", "red"))
{% endhighlight %}

![center](/public/img/2013-08-28-govdat-vignette/sll_cw_timeseries3.png) 


********************

#### Search OpenStates bills.


{% highlight r %}
out <- sll_os_billsearch(terms = "agriculture", state = "tx", chamber = "upper")
lapply(out, "[[", "title")[100:110]
{% endhighlight %}



{% highlight text %}
[[1]]
[1] "Relating to the sale by the Brazos River Authority of certain property at Possum Kingdom Lake."

[[2]]
[1] "Proposing a constitutional amendment providing immediate additional revenue for the state budget by creating the Texas Gaming Commission, and authorizing and regulating the operation of casino games and slot machines by a limited number of licensed operators and certain Indian tribes."

[[3]]
[1] "Relating to production requirements for holders of winery permits."

[[4]]
[1] "Relating to the use of human remains in the training of search and rescue animals."

[[5]]
[1] "Relating to end-of-course assessment instruments administered to public high school students and other measures of secondary-level performance."

[[6]]
[1] "Relating to public high school graduation, including curriculum and assessment requirements for graduation and funding in support of certain curriculum authorized for graduation."

[[7]]
[1] "Relating to certain residential and other structures and mitigation of loss to those structures resulting from natural catastrophes; providing a criminal penalty."

[[8]]
[1] "Recognizing March 28, 2013, as Texas Water Conservation Day at the State Capitol."

[[9]]
[1] "Recognizing March 26, 2013, as Lubbock Day at the State Capitol."

[[10]]
[1] "In memory of Steve Jones."

[[11]]
[1] "Relating to the regulation of dangerous wild animals."
{% endhighlight %}


********************

#### Search Legislators on OpenStates. 


{% highlight r %}
out <- sll_os_legislatorsearch(state = "tx", party = "democratic", active = TRUE)
out[[1]][1:5]
{% endhighlight %}



{% highlight text %}
$last_name
[1] "Naishtat"

$updated_at
[1] "2013-08-29 03:03:22"

$nimsp_candidate_id
[1] "112047"

$full_name
[1] "Elliott Naishtat"

$`+district_address`
[1] " P.O. Box 2910\nAustin, TX 78768\n(512) 463-0668"
{% endhighlight %}


********************

#### Search for entities - that is, politicians, individuals, or organizations with the given name


{% highlight r %}
out <- sll_ts_aggregatesearch("Nancy Pelosi")
out <- lapply(out, function(x) {
    x[sapply(x, is.null)] <- "none"
    x
})
ldply(out, data.frame)
{% endhighlight %}



{% highlight text %}
                       name count_given firm_income count_lobbied          seat
1          Nancy Pelosi (D)           0           0             0 federal:house
2 Nancy Pelosi for Congress           7           0             0          none
  total_received state lobbying_firm count_received party total_given         type
1       14173534    CA          none          10054     D           0   politician
2              0  none          <NA>              0  none        7250 organization
                                id non_firm_spending is_superpac
1 85ab2e74589a414495d18cc7a9233981                 0        none
2 afb432ec90454c8a83a3113061e7be27                 0        <NA>
{% endhighlight %}


********************

#### Return the top contributoring organizations, ranked by total dollars given. An organization's giving is broken down into money given directly (by the organization's PAC) versus money given by individuals employed by or associated with the organization.


{% highlight r %}
out <- sll_ts_aggregatetopcontribs(id = "85ab2e74589a414495d18cc7a9233981")
ldply(out, data.frame)
{% endhighlight %}



{% highlight text %}
   employee_amount total_amount total_count                                     name
1         64000.00    101300.00          79                         Akin, Gump et al
2          3500.00     90000.00          29 American Fedn of St/Cnty/Munic Employees
3                0     86600.00          48                National Assn of Realtors
4                0     85000.00          32                      United Auto Workers
5                0     82500.00          37                  National Education Assn
6                0     77000.00          19                          Teamsters Union
7                0     76000.00          36         National Assn of Letter Carriers
8                0     72500.00          18   Intl Brotherhood of Electrical Workers
9                0     72500.00          21                Sheet Metal Workers Union
10         8000.00     72000.00          31                              Wells Fargo
   direct_count employee_count                               id direct_amount
1            16             63 105dcfc8c9384875a099af230dad9917      37300.00
2            25              4 fb702029157e4c7c887172eba71c66c5      86500.00
3            48              0 bb98402bd4d3471cad392a671ecd733a      86600.00
4            32              0 4d3167b97c9f48deb433aad57bb0ee44      85000.00
5            37              0 1b8fea7e453d4e75841eac48ff9df550      82500.00
6            19              0 f89c8e3ab2b44f72971f91b764868231      77000.00
7            36              0 390767dc6b4b491ca775b1bdf8a36eea      76000.00
8            18              0 b53b4ad137d743a996f4d7467700fc88      72500.00
9            21              0 425be85642b24cc2bc3d8a0bb3c7bc92      72500.00
10           20             11 793070ae7f5e42c2a76a58663a588f3d      64000.00
{% endhighlight %}

