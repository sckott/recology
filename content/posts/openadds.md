---
name: openadds
layout: post
title: openadds - open addresses client
date: 2015-05-18
author: Scott Chamberlain
sourceslug: _drafts/2015-05-18-openadds.Rmd
tags:
- R
- opendata
---



`openadds` talks to [Openaddresses.io](https://openaddresses.io/). a run down of its things:

## Install


```r
devtools::install_github("sckott/openadds")
```


```r
library("openadds")
```

## List datasets

Scrapes links to datasets from the openaddresses site


```r
dat <- oa_list()
dat[2:6]
#> [1] "https://data.openaddresses.io.s3.amazonaws.com/20150511/au-tas-launceston.csv"   
#> [2] "https://s3.amazonaws.com/data.openaddresses.io/20141127/au-victoria.zip"         
#> [3] "https://data.openaddresses.io.s3.amazonaws.com/20150511/be-flanders.zip"         
#> [4] "https://data.openaddresses.io.s3.amazonaws.com/20150417/ca-ab-calgary.zip"       
#> [5] "https://data.openaddresses.io.s3.amazonaws.com/20150511/ca-ab-grande_prairie.zip"
```

## Search for datasets

Uses `oa_list()` internally, then searches through columns requested.


```r
oa_search(country = "us", state = "ca")
#> Source: local data frame [68 x 5]
#> 
#>    country state             city  ext
#> 1       us    ca san_mateo_county .zip
#> 2       us    ca   alameda_county .zip
#> 3       us    ca   alameda_county .zip
#> 4       us    ca           amador .zip
#> 5       us    ca           amador .zip
#> 6       us    ca      bakersfield .zip
#> 7       us    ca      bakersfield .zip
#> 8       us    ca         berkeley .zip
#> 9       us    ca         berkeley .zip
#> 10      us    ca     butte_county .zip
#> ..     ...   ...              ...  ...
#> Variables not shown: url (chr)
```

## Get data

Passing in a URL


```r
(out1 <- oa_get(dat[5]))
#> <Openaddresses data> ~/.openadds/ca-ab-calgary.zip
#> Dimensions [350962, 13]
#> 
#>    OBJECTID ADDRESS_TY                 ADDRESS    STREET_NAM STREET_TYP
#> 0    757023     Parcel  249 SAGE MEADOWS CI NW  SAGE MEADOWS         CI
#> 1    757022     Parcel           2506 17 ST SE            17         ST
#> 2    757021     Parcel     305 EVANSPARK GD NW     EVANSPARK         GD
#> 3    757020     Parcel     321 EVANSPARK GD NW     EVANSPARK         GD
#> 4    757019     Parcel   204 EVANSBROOKE LD NW   EVANSBROOKE         LD
#> 5    757018     Parcel   200 EVANSBROOKE LD NW   EVANSBROOKE         LD
#> 6    757017     Parcel 219 HIDDEN VALLEY LD NW HIDDEN VALLEY         LD
#> 7    757016     Parcel 211 HIDDEN VALLEY LD NW HIDDEN VALLEY         LD
#> 8    757015     Parcel 364 HIDDEN VALLEY LD NW HIDDEN VALLEY         LD
#> 9    757014     Parcel 348 HIDDEN VALLEY LD NW HIDDEN VALLEY         LD
#> ..      ...        ...                     ...           ...        ...
#> Variables not shown: STREET_QUA (fctr), HOUSE_NUMB (int), HOUSE_ALPH
#>      (fctr), SUITE_NUMB (int), SUITE_ALPH (fctr), LONGITUDE (dbl),
#>      LATITUDE (dbl), COMM_NAME (fctr)
```

First getting URL for dataset through `as_openadd()`, then passing to `oa_get()`


```r
(x <- as_openadd("us", "nm", "hidalgo"))
#> <<OpenAddreses>> 
#>   <<country>> us
#>   <<state>> nm
#>   <<city>> hidalgo
#>   <<extension>> .csv
```


```r
oa_get(x)
#> <Openaddresses data> ~/.openadds/us-nm-hidalgo.csv
#> Dimensions [170659, 37]
#> 
#>    OBJECTID Shape ADD_NUM ADD_SUF PRE_MOD PRE_DIR PRE_TYPE         ST_NAME
#> 1         1    NA     422                       S                      2ND
#> 2         2    NA    1413                       S                      4TH
#> 3         3    NA     412                       E                 CHAMPION
#> 4         4    NA     110                       E                   SAMANO
#> 5         5    NA    2608                       W          FREDDY GONZALEZ
#> 6         6    NA    2604                       W          FREDDY GONZALEZ
#> 7         7    NA    1123                       W                      FAY
#> 8         8    NA     417                       S                      2ND
#> 9         9    NA    4551                       E                    TEXAS
#> 10       10    NA     810                                        DRIFTWOOD
#> ..      ...   ...     ...     ...     ...     ...      ...             ...
#> Variables not shown: ST_TYPE (chr), POS_DIR (chr), POS_MOD (chr), ESN
#>      (int), MSAG_COMM (chr), PARCEL_ID (chr), PLACE_TYPE (chr), LANDMARK
#>      (chr), BUILDING (chr), UNIT (chr), ROOM (chr), FLOOR (int), LOC_NOTES
#>      (chr), ST_ALIAS (chr), FULL_ADDR (chr), ZIP (chr), POSTAL_COM (chr),
#>      MUNICIPAL (chr), COUNTY (chr), STATE (chr), SOURCE (chr), REGION
#>      (chr), EXCH (chr), LAT (dbl), LONG (dbl), PICTURE (chr), OA:x (dbl),
#>      OA:y (dbl), OA:geom (chr)
```

## Combine multiple datasets

`combine` attemps to guess lat/long and address columns, but definitely more work to do to make 
this work for most cases. Lat/long and address columns vary among every dataset - some datasets
have no lat/long data, some have no address data.
 

```r
out2 <- oa_get(dat[32])
(alldat <- oa_combine(out1, out2))
#> Source: local data frame [418,623 x 4]
#> 
#>          lon      lat                 address           dataset
#> 1  -114.1303 51.17188  249 SAGE MEADOWS CI NW ca-ab-calgary.zip
#> 2  -114.0190 51.03168           2506 17 ST SE ca-ab-calgary.zip
#> 3  -114.1175 51.17497     305 EVANSPARK GD NW ca-ab-calgary.zip
#> 4  -114.1175 51.17461     321 EVANSPARK GD NW ca-ab-calgary.zip
#> 5  -114.1212 51.16268   204 EVANSBROOKE LD NW ca-ab-calgary.zip
#> 6  -114.1213 51.16264   200 EVANSBROOKE LD NW ca-ab-calgary.zip
#> 7  -114.1107 51.14784 219 HIDDEN VALLEY LD NW ca-ab-calgary.zip
#> 8  -114.1108 51.14768 211 HIDDEN VALLEY LD NW ca-ab-calgary.zip
#> 9  -114.1121 51.14780 364 HIDDEN VALLEY LD NW ca-ab-calgary.zip
#> 10 -114.1117 51.14800 348 HIDDEN VALLEY LD NW ca-ab-calgary.zip
#> ..       ...      ...                     ...               ...
```

## Map data

Get some data


```r
(out <- oa_get(dat[400]))
#> <Openaddresses data> ~/.openadds/us-ca-sonoma_county.zip
#> Dimensions [217243, 5]
#> 
#>          LON      LAT  NUMBER          STREET POSTCODE
#> 1  -122.5327 38.29779 3771  A       Cory Lane       NA
#> 2  -122.5422 38.30354   18752 White Oak Drive       NA
#> 3  -122.5412 38.30327   18749 White Oak Drive       NA
#> 4  -122.3997 38.26122    3552       Napa Road       NA
#> 5  -122.5425 38.30404    3998 White Oak Court       NA
#> 6  -122.5429 38.30434    4026 White Oak Court       NA
#> 7  -122.5430 38.30505    4039 White Oak Court       NA
#> 8  -122.5417 38.30504    4017 White Oak Court       NA
#> 9  -122.5409 38.30436   18702 White Oak Drive       NA
#> 10 -122.5403 38.30392   18684 White Oak Drive       NA
#> ..       ...      ...     ...             ...      ...
```

Make an interactive map (not all data)


```r
library("leaflet")

x <- oa_get(oa_search(country = "us", city = "boulder")[1,]$url)
y <- oa_get(oa_search(country = "us", city = "gunnison")[1,]$url)
oa_combine(x, y) %>% 
  leaflet() %>%
  addTiles() %>%
  addCircles(lat = ~lat, lng = ~lon, popup = ~address)
```

![image](/2015-05-18-openadds/map.png)

## To do

* Surely there are many datasets that won't work in `oa_combine()` - gotta go through many more.
* An easy viz function wrapping `leaflet`
* Since you can get a lot of spatial data quickly, easy way to visualize big data, maybe marker clusters?
