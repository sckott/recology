---
name: rsunlight
layout: post
title: rsunlight - v0.3 released
date: 2014-08-11
author: Scott Chamberlain
tags:
- R
- API
- government
---



My [last blog post on this package](http://recology.info/2014/05/rsunlight/) was so long ago the package wrapped both New York Times APIs and Sunlight Labs APIs and the package was called `govdat`. I split that package up into `rsunlight` for Sunlight Labs APIs and `rtimes` for some New York Times APIs. `rtimes` is [in development at Github](https://github.com/ropengov/rtimes).

We've updated the package to include four sets of functions, one set for each of four Sunlight Labs APIs (with a separate prefix for each API):

* Congress API (`cg_`)
* Open States API (`os_`)
* Capitol Words API (`cw_`)
* Influence Explorer API (`ie_`)

Then there are many methods for each API.

## rsunlight intro

### Installation

First, installation


```r
devtools::install_github("ropengov/rsunlight")
```

Load the library


```r
library("rsunlight")
```

### Congress API

Search for Fed level bills that include the term _health care_ in them.


```r
res <- cg_bills(query='health care')
head(res$results[,1:4])
```

```
##          nicknames congress last_version_on sponsor_id
## 1        obamacare      111      2010-08-25    S000749
## 2 obamacare, ppaca      111      2010-08-25    R000053
## 3             NULL      113      2013-10-09    K000220
## 4             NULL      111      2009-01-06    I000056
## 5             NULL      112      2011-01-05    I000056
## 6             NULL      111      2009-05-05    D000197
```

Search for bills that have the two terms _transparency_ and _accountability_ within 5 words of each other in the bill.


```r
res <- cg_bills(query='transparency accountability'~5)
head(res$results[,1:4])
```

```
##   congress last_version_on sponsor_id
## 1      111      2009-01-15    R000435
## 2      113      2013-07-17    R000595
## 3      112      2011-12-08    R000435
## 4      113      2013-09-19    R000435
## 5      112      2011-11-10    R000595
## 6      113      2013-07-23    C000560
##                                       urls.govtrack
## 1   http://www.govtrack.us/congress/bills/111/hr557
## 2  https://www.govtrack.us/congress/bills/113/s1313
## 3  http://www.govtrack.us/congress/bills/112/hr2829
## 4 https://www.govtrack.us/congress/bills/113/hr3155
## 5   http://www.govtrack.us/congress/bills/112/s1848
## 6  https://www.govtrack.us/congress/bills/113/s1347
##                                 urls.opencongress
## 1  http://www.opencongress.org/bill/111-h557/show
## 2      http://www.opencongress.org/bill/s1313-113
## 3 http://www.opencongress.org/bill/112-h2829/show
## 4     http://www.opencongress.org/bill/hr3155-113
## 5 http://www.opencongress.org/bill/112-s1848/show
## 6      http://www.opencongress.org/bill/s1347-113
##                                          urls.congress
## 1   http://beta.congress.gov/bill/111th/house-bill/557
## 2 http://beta.congress.gov/bill/113th/senate-bill/1313
## 3  http://beta.congress.gov/bill/112th/house-bill/2829
## 4  http://beta.congress.gov/bill/113th/house-bill/3155
## 5 http://beta.congress.gov/bill/112th/senate-bill/1848
## 6 http://beta.congress.gov/bill/113th/senate-bill/1347
```

### Open States API

Search State Bills, in this case search for the term _agriculture_ in Texas.


```r
res <- os_billsearch(terms = 'agriculture', state = 'tx')
head(res)
```

```
##                                                                                                                                                 title
## 1 Relating to authorizing the issuance of revenue bonds to fund capital projects at public institutions of higher education; making an appropriation.
## 2                          Relating to authorizing the issuance of revenue bonds to fund capital projects at public institutions of higher education.
## 3                          Relating to authorizing the issuance of revenue bonds to fund capital projects at public institutions of higher education.
## 4                          Relating to authorizing the issuance of revenue bonds to fund capital projects at public institutions of higher education.
## 5 Relating to authorizing the issuance of revenue bonds to fund capital projects at public institutions of higher education; making an appropriation.
## 6                                Relating to access to certain facilities by search and rescue dogs and their handlers; providing a criminal penalty.
##            created_at          updated_at          id chamber state
## 1 2013-08-01 03:33:40 2013-08-07 03:10:10 TXB00034894   upper    tx
## 2 2013-08-01 03:33:38 2013-08-02 03:20:14 TXB00034893   upper    tx
## 3 2013-07-21 03:03:53 2013-07-28 03:28:30 TXB00034814   upper    tx
## 4 2013-07-03 02:44:03 2013-07-14 03:00:31 TXB00034514   upper    tx
## 5 2013-06-16 03:48:13 2013-06-23 04:02:49 TXB00033988   upper    tx
## 6 2013-03-03 04:47:26 2013-07-01 21:25:36 TXB00027556   upper    tx
##   session type
## 1     833 bill
## 2     833 bill
## 3     832 bill
## 4     832 bill
## 5     831 bill
## 6      83 bill
##                                                                             subjects
## 1                                   Commerce, Education, Budget, Spending, and Taxes
## 2                                   Commerce, Education, Budget, Spending, and Taxes
## 3                                   Commerce, Education, Budget, Spending, and Taxes
## 4                                   Commerce, Education, Budget, Spending, and Taxes
## 5                                   Commerce, Education, Budget, Spending, and Taxes
## 6 Commerce, Business and Consumers, Animal Rights and Wildlife Issues, Health, Crime
##   bill_id
## 1    SB 3
## 2   SB 10
## 3   SB 40
## 4    SB 6
## 5   SB 44
## 6 SB 1010
```

Search for legislators in California (_ca_) and in the democratic party


```r
res <- os_legislatorsearch(state = 'ca', party = 'democratic', fields = c('full_name','+capitol_office.phone'))
head(res)
```

```
##            phone        id       full_name
## 1 (916) 319-2014 CAL000058   Nancy Skinner
## 2 (916) 319-2015 CAL000059   Joan Buchanan
## 3 (916) 319-2022 CAL000084       Paul Fong
## 4 (916) 319-2046 CAL000089      John Pérez
## 5 (916) 319-2080 CAL000098 V. Manuel Pérez
## 6 (916) 319-2001 CAL000101  Wesley Chesbro
```

Now you can call each representative, yay!

### Capitol Words API

Search for phrase _climate change_ used by politicians between September 5th and 16th, 2011:


```r
head(cw_text(phrase='climate change', start_date='2011-09-05', end_date='2011-09-16', party='D')[,c('speaker_last','origin_url')])
```

```
##   speaker_last
## 1      Tsongas
## 2       Inslee
## 3        Costa
## 4        Boxer
## 5       Durbin
## 6        Boxer
##                                                                                   origin_url
## 1 http://origin.www.gpo.gov/fdsys/pkg/CREC-2011-09-14/html/CREC-2011-09-14-pt1-PgH6149-5.htm
## 2   http://origin.www.gpo.gov/fdsys/pkg/CREC-2011-09-15/html/CREC-2011-09-15-pt1-PgH6186.htm
## 3 http://origin.www.gpo.gov/fdsys/pkg/CREC-2011-09-13/html/CREC-2011-09-13-pt1-PgE1609-2.htm
## 4   http://origin.www.gpo.gov/fdsys/pkg/CREC-2011-09-15/html/CREC-2011-09-15-pt1-PgS5650.htm
## 5   http://origin.www.gpo.gov/fdsys/pkg/CREC-2011-09-13/html/CREC-2011-09-13-pt1-PgS5510.htm
## 6 http://origin.www.gpo.gov/fdsys/pkg/CREC-2011-09-13/html/CREC-2011-09-13-pt1-PgS5513-2.htm
```

Plot mentions of the term _climate change_ over time for Democrats vs. Republicans


```r
library('ggplot2')
dat_d <- cw_timeseries(phrase='climate change', party="D")
dat_d$party <- rep("D", nrow(dat_d))
dat_r <- cw_timeseries(phrase='climate change', party="R")
dat_r$party <- rep("R", nrow(dat_r))
dat_both <- rbind(dat_d, dat_r)
ggplot(dat_both, aes(day, count, colour=party)) +
   geom_line() +
   theme_grey(base_size=20) +
   scale_colour_manual(values=c("blue","red"))
```

![plot of chunk unnamed-chunk-9](../public/img/2014-08-11-rsunlight/unnamed-chunk-9.png) 

### Influence Explorer API

Search for contributions of equal to or more than `$20,000,000`.


```r
ie_contr(amount='>|20000000')[,c('amount','recipient_name','contributor_name')]
```

```
##         amount
## 1  25177212.00
## 2  20000000.00
## 3  20000000.00
## 4  20000000.00
## 5  20000000.00
## 6  20000000.00
## 7  50000000.00
## 8  34000000.00
## 9  28000000.00
## 10 20000000.00
##                                                   recipient_name
## 1                                       Republican National Cmte
## 2  CALIFORNIANS TO CLOSE THE OUT-OF-STATE CORPORATE TAX LOOPHOLE
## 3                                                   WHITMAN, MEG
## 4                                                   WHITMAN, MEG
## 5                                                   WHITMAN, MEG
## 6                                                   WHITMAN, MEG
## 7                                         GOLISANO, B THOMAS (G)
## 8                                         GOLISANO, B THOMAS (G)
## 9                                         GOLISANO, B THOMAS (G)
## 10                                        GOLISANO, B THOMAS (G)
##           contributor_name
## 1           Romney Victory
## 2         STEYER, THOMAS F
## 3  WHITMAN, MARGARET (MEG)
## 4  WHITMAN, MARGARET (MEG)
## 5  WHITMAN, MARGARET (MEG)
## 6  WHITMAN, MARGARET (MEG)
## 7       GOLISANO, B THOMAS
## 8       GOLISANO, B THOMAS
## 9       GOLISANO, B THOMAS
## 10      GOLISANO, B THOMAS
```

Top industries, by contributions given. _UNKOWN_ is a very influential industry. Of course _law firms_ are high up there, as well as _real estate_. I'm sure _oil and gas_ is embarrased that they're contributing less than _pulic sector unions_. 


```r
(res <- ie_industries(method='top_ind', limit=10))
```

```
##       count        amount                               id
## 1  14919818 3825359507.21 cdb3f500a3f74179bb4a5eb8b2932fa6
## 2   3600761 2787678962.95 f50cf984a2e3477c8167d32e2b14e052
## 3    329906 1717649914.58 9cac88377c3b400e89c2d6762e3f28f6
## 4   1386613 1707457092.04 7500030dffe24844aa467a75f7aedfd1
## 5    774496 1563637586.57 0af3f418f426497e8bbf916bfc074ebc
## 6    546367 1389220855.35 52e5d4c6c0fa47c3bdb199a28f96d434
## 7   2134350 1384221307.53 a05a0d06f6814b31bece35a81fcb40c7
## 8   1003850  986588892.83 8ada0fc2d6994f2ab06c7e025dff2284
## 9    567082  775241387.17 52766c4910a846f2813a1dda212b7027
## 10   151006  706747646.35 13718be68388456d9b6e8db753f06e72
##    should_show_entity                    name
## 1                TRUE                 UNKNOWN
## 2                TRUE       LAWYERS/LAW FIRMS
## 3                TRUE  CANDIDATE SELF-FINANCE
## 4                TRUE             REAL ESTATE
## 5                TRUE SECURITIES & INVESTMENT
## 6                TRUE    PUBLIC SECTOR UNIONS
## 7                TRUE    HEALTH PROFESSIONALS
## 8                TRUE               INSURANCE
## 9                TRUE               OIL & GAS
## 10               TRUE        CASINOS/GAMBLING
```

```r
res$amount <- as.numeric(res$amount)
ggplot(res, aes(reorder(name, amount), amount)) + 
  geom_bar(stat = "identity") +
  coord_flip() +
  scale_y_continuous(labels=dollar) +
  theme_grey(base_size = 14) +
  labs(x='Industry', y='Amount')
```

![plot of chunk unnamed-chunk-11](../public/img/2014-08-11-rsunlight/unnamed-chunk-11.png) 

-------

## Feedback

Please do use `rsunlight`, and let us know what you want fixed, new features, etc.

## Still to come:

* Functions to visualize data from each API. You can do this yourself, but a few functions will be created to help those that are new to R.
* Vectorize functions so that you can give many inputs to a function instead of a single input.
* test suite: embarrasingly, there is no test suite yet, boo me.
* I plan to push `rsunlight` to CRAN soon as `v0.3`
