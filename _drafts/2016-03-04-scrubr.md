---
name: scrubr
layout: post
title: scrubr - clean species occurrence records
date: 2016-03-04
author: Scott Chamberlain
sourceslug: _drafts/2016-03-04-scrubr.Rmd
tags:
- R
- occurrences
- occurrence records
- species
- ecology
---



`scrubr` is an R library for cleaning species occurrence records. It's general purpose, and has the following approach:

* We think using a piping workflow (`%>%`) makes code easier to build up, and easier to understand. However, you don't have to use pipes in this package.
* All inputs and outputs are data.frame's - which makes the above point easier
* Records trimmed off due to various filters are retained as attributes, so can still be accessed for later inspection, but don't get in the way of the data.frame that gets modified for downstream use
* User interface vs. speed: This is the kind of package that surely can get faster. However, we're focusing on the UI first, then make speed improvements down the road. 
* Since occurrence record datasets should all have columns with lat/long information, we automatically look for those columns for you. If identified, we use them, but you can supply lat/long column names manually as well.

We have many packages that fetch species occurrence records from GBIF, iNaturalist, VertNet, iDigBio, Ecoengine, and more. `scrubr` fills a crucial missing niche as likely all uses of occurrence data requires cleaning of some kind. When using GBIF data via `rgbif`, that package has some utilities for cleaning data based on the issues returned with GBIF data - `scrubr` is a companion to do the rest of the cleaning.

## scrubr use cases

### Those covered

- Impossible lat/long values: e.g., latitude 75
- Incomplete cases: one or the other of lat/long missing
- Unlikely lat/long values: e.g., points at 0,0
- Deduplication: try to identify duplicates, esp. when pulling data from multiple sources, e.g., can try to use occurrence IDs, if provided
- Date based cleaning
- Outside political boundary: User input to check for points in the wrong country, or points outside of a known country
- Taxonomic name based cleaning: via `taxize` (one method so far)

### To be covered

* Political centroids: unlikely that occurrences fall exactly on these points, more likely a
default position (Draft function started, but not exported, and commented out)
* Herbaria/Museums: many specimens may have location of the collection they are housed in
* Habitat type filtering: e.g., fish should not be on land; marine fish should not be in fresh water
* Check for contextually wrong values: That is, if 99 out of 100 lat/long coordinates are within the continental US, but 1 is in China, then perhaps something is wrong with that one point
* and many more...

What else do you want included? [Open an issue in the repo](https://github.com/ropenscilabs/scrubr/issues) to chat about use cases.


## Install

From CRAN (binaries may not be up yet, but source is)


```r
install.packages("scrubr")
```

Or from GitHub


```r
devtools::install_github("ropenscilabs/scrubr")
```


```r
library("scrubr")
```

## dframe

`dframe()` is a tool to convert your data.frame to a compact `dplyr` like data.frame so that you can get a quick peek at your data each time you call a function - BUT, you don't have to use it.

Compare `mtcars`


```r
mtcars
#>                      mpg cyl  disp  hp drat    wt  qsec vs am gear carb
#> Mazda RX4           21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4
#> Mazda RX4 Wag       21.0   6 160.0 110 3.90 2.875 17.02  0  1    4    4
#> Datsun 710          22.8   4 108.0  93 3.85 2.320 18.61  1  1    4    1
#> Hornet 4 Drive      21.4   6 258.0 110 3.08 3.215 19.44  1  0    3    1
#> Hornet Sportabout   18.7   8 360.0 175 3.15 3.440 17.02  0  0    3    2
#> Valiant             18.1   6 225.0 105 2.76 3.460 20.22  1  0    3    1
#> Duster 360          14.3   8 360.0 245 3.21 3.570 15.84  0  0    3    4
#> Merc 240D           24.4   4 146.7  62 3.69 3.190 20.00  1  0    4    2
#> Merc 230            22.8   4 140.8  95 3.92 3.150 22.90  1  0    4    2
#> Merc 280            19.2   6 167.6 123 3.92 3.440 18.30  1  0    4    4
#> Merc 280C           17.8   6 167.6 123 3.92 3.440 18.90  1  0    4    4
#> Merc 450SE          16.4   8 275.8 180 3.07 4.070 17.40  0  0    3    3
#> Merc 450SL          17.3   8 275.8 180 3.07 3.730 17.60  0  0    3    3
#> Merc 450SLC         15.2   8 275.8 180 3.07 3.780 18.00  0  0    3    3
#> Cadillac Fleetwood  10.4   8 472.0 205 2.93 5.250 17.98  0  0    3    4
#> Lincoln Continental 10.4   8 460.0 215 3.00 5.424 17.82  0  0    3    4
#> Chrysler Imperial   14.7   8 440.0 230 3.23 5.345 17.42  0  0    3    4
#> Fiat 128            32.4   4  78.7  66 4.08 2.200 19.47  1  1    4    1
#> Honda Civic         30.4   4  75.7  52 4.93 1.615 18.52  1  1    4    2
#> Toyota Corolla      33.9   4  71.1  65 4.22 1.835 19.90  1  1    4    1
#> Toyota Corona       21.5   4 120.1  97 3.70 2.465 20.01  1  0    3    1
#> Dodge Challenger    15.5   8 318.0 150 2.76 3.520 16.87  0  0    3    2
#> AMC Javelin         15.2   8 304.0 150 3.15 3.435 17.30  0  0    3    2
#> Camaro Z28          13.3   8 350.0 245 3.73 3.840 15.41  0  0    3    4
#> Pontiac Firebird    19.2   8 400.0 175 3.08 3.845 17.05  0  0    3    2
#> Fiat X1-9           27.3   4  79.0  66 4.08 1.935 18.90  1  1    4    1
#> Porsche 914-2       26.0   4 120.3  91 4.43 2.140 16.70  0  1    5    2
#> Lotus Europa        30.4   4  95.1 113 3.77 1.513 16.90  1  1    5    2
#> Ford Pantera L      15.8   8 351.0 264 4.22 3.170 14.50  0  1    5    4
#> Ferrari Dino        19.7   6 145.0 175 3.62 2.770 15.50  0  1    5    6
#> Maserati Bora       15.0   8 301.0 335 3.54 3.570 14.60  0  1    5    8
#> Volvo 142E          21.4   4 121.0 109 4.11 2.780 18.60  1  1    4    2
```

To


```r
dframe(mtcars)
#> <scrubr dframe>
#> Size: 32 X 11
#> 
#> 
#>      mpg   cyl  disp    hp  drat    wt  qsec    vs    am  gear  carb
#>    (dbl) (dbl) (dbl) (dbl) (dbl) (dbl) (dbl) (dbl) (dbl) (dbl) (dbl)
#> 1   21.0     6 160.0   110  3.90 2.620 16.46     0     1     4     4
#> 2   21.0     6 160.0   110  3.90 2.875 17.02     0     1     4     4
#> 3   22.8     4 108.0    93  3.85 2.320 18.61     1     1     4     1
#> 4   21.4     6 258.0   110  3.08 3.215 19.44     1     0     3     1
#> 5   18.7     8 360.0   175  3.15 3.440 17.02     0     0     3     2
#> 6   18.1     6 225.0   105  2.76 3.460 20.22     1     0     3     1
#> 7   14.3     8 360.0   245  3.21 3.570 15.84     0     0     3     4
#> 8   24.4     4 146.7    62  3.69 3.190 20.00     1     0     4     2
#> 9   22.8     4 140.8    95  3.92 3.150 22.90     1     0     4     2
#> 10  19.2     6 167.6   123  3.92 3.440 18.30     1     0     4     4
#> ..   ...   ...   ...   ...   ...   ...   ...   ...   ...   ...   ...
```

## Coordinate based cleaning

Load some sample data that comes with the package


```r
data("sampledata1")
```

Remove impossible coordinates (using sample data included in the pkg)


```r
dframe(sample_data_1) %>% coord_impossible()
#> <scrubr dframe>
#> Size: 1500 X 5
#> Lat/Lon vars: latitude/longitude
#> 
#>                name  longitude latitude                date        key
#>               (chr)      (dbl)    (dbl)              (time)      (int)
#> 1  Ursus americanus  -79.68283 38.36662 2015-01-14 16:36:45 1065590124
#> 2  Ursus americanus  -82.42028 35.73304 2015-01-13 00:25:39 1065588899
#> 3  Ursus americanus  -99.09625 23.66893 2015-02-20 23:00:00 1098894889
#> 4  Ursus americanus  -72.77432 43.94883 2015-02-13 16:16:41 1065611122
#> 5  Ursus americanus  -72.34617 43.86464 2015-03-01 20:20:45 1088908315
#> 6  Ursus americanus -108.53674 32.65219 2015-03-29 17:06:54 1088932238
#> 7  Ursus americanus -108.53691 32.65237 2015-03-29 17:12:50 1088932273
#> 8  Ursus americanus -123.82900 40.13240 2015-03-28 23:00:00 1132403409
#> 9  Ursus americanus  -78.25027 36.93018 2015-03-20 21:11:24 1088923534
#> 10 Ursus americanus  -76.78671 35.53079 2015-04-05 23:00:00 1088954559
#> ..              ...        ...      ...                 ...        ...
```

Remove incomplete coordinates


```r
dframe(sample_data_1) %>% coord_incomplete()
#> <scrubr dframe>
#> Size: 1306 X 5
#> Lat/Lon vars: latitude/longitude
#> 
#>                name  longitude latitude                date        key
#>               (chr)      (dbl)    (dbl)              (time)      (int)
#> 1  Ursus americanus  -79.68283 38.36662 2015-01-14 16:36:45 1065590124
#> 2  Ursus americanus  -82.42028 35.73304 2015-01-13 00:25:39 1065588899
#> 3  Ursus americanus  -99.09625 23.66893 2015-02-20 23:00:00 1098894889
#> 4  Ursus americanus  -72.77432 43.94883 2015-02-13 16:16:41 1065611122
#> 5  Ursus americanus  -72.34617 43.86464 2015-03-01 20:20:45 1088908315
#> 6  Ursus americanus -108.53674 32.65219 2015-03-29 17:06:54 1088932238
#> 7  Ursus americanus -108.53691 32.65237 2015-03-29 17:12:50 1088932273
#> 8  Ursus americanus -123.82900 40.13240 2015-03-28 23:00:00 1132403409
#> 9  Ursus americanus  -78.25027 36.93018 2015-03-20 21:11:24 1088923534
#> 10 Ursus americanus  -76.78671 35.53079 2015-04-05 23:00:00 1088954559
#> ..              ...        ...      ...                 ...        ...
```

Remove unlikely coordinates (e.g., those at 0,0)


```r
dframe(sample_data_1) %>% coord_unlikely()
#> <scrubr dframe>
#> Size: 1488 X 5
#> Lat/Lon vars: latitude/longitude
#> 
#>                name  longitude latitude                date        key
#>               (chr)      (dbl)    (dbl)              (time)      (int)
#> 1  Ursus americanus  -79.68283 38.36662 2015-01-14 16:36:45 1065590124
#> 2  Ursus americanus  -82.42028 35.73304 2015-01-13 00:25:39 1065588899
#> 3  Ursus americanus  -99.09625 23.66893 2015-02-20 23:00:00 1098894889
#> 4  Ursus americanus  -72.77432 43.94883 2015-02-13 16:16:41 1065611122
#> 5  Ursus americanus  -72.34617 43.86464 2015-03-01 20:20:45 1088908315
#> 6  Ursus americanus -108.53674 32.65219 2015-03-29 17:06:54 1088932238
#> 7  Ursus americanus -108.53691 32.65237 2015-03-29 17:12:50 1088932273
#> 8  Ursus americanus -123.82900 40.13240 2015-03-28 23:00:00 1132403409
#> 9  Ursus americanus  -78.25027 36.93018 2015-03-20 21:11:24 1088923534
#> 10 Ursus americanus  -76.78671 35.53079 2015-04-05 23:00:00 1088954559
#> ..              ...        ...      ...                 ...        ...
```

Do all three


```r
dframe(sample_data_1) %>%
  coord_impossible() %>%
  coord_incomplete() %>%
  coord_unlikely()
#> <scrubr dframe>
#> Size: 1294 X 5
#> Lat/Lon vars: latitude/longitude
#> 
#>                name  longitude latitude                date        key
#>               (chr)      (dbl)    (dbl)              (time)      (int)
#> 1  Ursus americanus  -79.68283 38.36662 2015-01-14 16:36:45 1065590124
#> 2  Ursus americanus  -82.42028 35.73304 2015-01-13 00:25:39 1065588899
#> 3  Ursus americanus  -99.09625 23.66893 2015-02-20 23:00:00 1098894889
#> 4  Ursus americanus  -72.77432 43.94883 2015-02-13 16:16:41 1065611122
#> 5  Ursus americanus  -72.34617 43.86464 2015-03-01 20:20:45 1088908315
#> 6  Ursus americanus -108.53674 32.65219 2015-03-29 17:06:54 1088932238
#> 7  Ursus americanus -108.53691 32.65237 2015-03-29 17:12:50 1088932273
#> 8  Ursus americanus -123.82900 40.13240 2015-03-28 23:00:00 1132403409
#> 9  Ursus americanus  -78.25027 36.93018 2015-03-20 21:11:24 1088923534
#> 10 Ursus americanus  -76.78671 35.53079 2015-04-05 23:00:00 1088954559
#> ..              ...        ...      ...                 ...        ...
```

Do vs. don't drop bad data


```r
# do
dframe(sample_data_1) %>% coord_incomplete(drop = TRUE) %>% NROW
#> [1] 1306
# don't
dframe(sample_data_1) %>% coord_incomplete(drop = FALSE) %>% NROW
#> [1] 1500
```


## Deduplicate

Get a smaller subset of a data.frame


```r
smalldf <- sample_data_1[1:20, ]
```

create a duplicate record


```r
smalldf <- rbind(smalldf, smalldf[10,])
row.names(smalldf) <- NULL
```

make it slightly different


```r
smalldf[21, "key"] <- 1088954555
NROW(smalldf)
#> [1] 21
```

It's 21 rows, including 1 duplicate. Do the deduplication


```r
(dp <- dframe(smalldf) %>% dedup())
#> <scrubr dframe>
#> Size: 20 X 5
#> 
#> 
#>                name  longitude latitude                date        key
#>               (chr)      (dbl)    (dbl)              (time)      (dbl)
#> 1  Ursus americanus  -79.68283 38.36662 2015-01-14 16:36:45 1065590124
#> 2  Ursus americanus  -82.42028 35.73304 2015-01-13 00:25:39 1065588899
#> 3  Ursus americanus  -99.09625 23.66893 2015-02-20 23:00:00 1098894889
#> 4  Ursus americanus  -72.77432 43.94883 2015-02-13 16:16:41 1065611122
#> 5  Ursus americanus  -72.34617 43.86464 2015-03-01 20:20:45 1088908315
#> 6  Ursus americanus -108.53674 32.65219 2015-03-29 17:06:54 1088932238
#> 7  Ursus americanus -108.53691 32.65237 2015-03-29 17:12:50 1088932273
#> 8  Ursus americanus -123.82900 40.13240 2015-03-28 23:00:00 1132403409
#> 9  Ursus americanus  -78.25027 36.93018 2015-03-20 21:11:24 1088923534
#> 10 Ursus americanus -103.30058 29.27042 2015-04-29 22:00:00 1088964797
#> ..              ...        ...      ...                 ...        ...
```

Now its 20 rows, duplicate removed

Here's the duplicates


```r
attr(dp, "dups")
#> <scrubr dframe>
#> Size: 1 X 5
#> 
#> 
#>               name longitude latitude                date        key
#>              (chr)     (dbl)    (dbl)              (time)      (dbl)
#> 1 Ursus americanus -76.78671 35.53079 2015-04-05 23:00:00 1088954555
```

## Dates

Standardize/convert dates


```r
df <- sample_data_1
dframe(df) %>% 
  date_standardize("%d%b%Y")
#> <scrubr dframe>
#> Size: 1500 X 5
#> 
#> 
#>                name  longitude latitude      date        key
#>               (chr)      (dbl)    (dbl)     (chr)      (int)
#> 1  Ursus americanus  -79.68283 38.36662 14Jan2015 1065590124
#> 2  Ursus americanus  -82.42028 35.73304 13Jan2015 1065588899
#> 3  Ursus americanus  -99.09625 23.66893 20Feb2015 1098894889
#> 4  Ursus americanus  -72.77432 43.94883 13Feb2015 1065611122
#> 5  Ursus americanus  -72.34617 43.86464 01Mar2015 1088908315
#> 6  Ursus americanus -108.53674 32.65219 29Mar2015 1088932238
#> 7  Ursus americanus -108.53691 32.65237 29Mar2015 1088932273
#> 8  Ursus americanus -123.82900 40.13240 28Mar2015 1132403409
#> 9  Ursus americanus  -78.25027 36.93018 20Mar2015 1088923534
#> 10 Ursus americanus  -76.78671 35.53079 05Apr2015 1088954559
#> ..              ...        ...      ...       ...        ...
```

Drop records without dates


```r
NROW(df)
#> [1] 1500
NROW(dframe(df) %>% date_missing())
#> [1] 1498
```

Create date field from other fields


```r
dframe(sample_data_2) %>% 
  date_create(year, month, day)
#> <scrubr dframe>
#> Size: 1500 X 8
#> 
#> 
#>                name  longitude latitude        key  year month   day
#>               (chr)      (dbl)    (dbl)      (int) (chr) (chr) (chr)
#> 1  Ursus americanus  -79.68283 38.36662 1065590124  2015    01    14
#> 2  Ursus americanus  -82.42028 35.73304 1065588899  2015    01    13
#> 3  Ursus americanus  -99.09625 23.66893 1098894889  2015    02    20
#> 4  Ursus americanus  -72.77432 43.94883 1065611122  2015    02    13
#> 5  Ursus americanus  -72.34617 43.86464 1088908315  2015    03    01
#> 6  Ursus americanus -108.53674 32.65219 1088932238  2015    03    29
#> 7  Ursus americanus -108.53691 32.65237 1088932273  2015    03    29
#> 8  Ursus americanus -123.82900 40.13240 1132403409  2015    03    28
#> 9  Ursus americanus  -78.25027 36.93018 1088923534  2015    03    20
#> 10 Ursus americanus  -76.78671 35.53079 1088954559  2015    04    05
#> ..              ...        ...      ...        ...   ...   ...   ...
#> Variables not shown: date (chr).
```

## bugs and such

Report them in the [scrubr issue tracker](https://github.com/ropenscilabs/scrubr/issues)
