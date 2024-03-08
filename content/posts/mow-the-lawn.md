---
name: mow-the-lawn
layout: post
title: lawn - a new package to do geospatial analysis
date: 2015-05-18
author: Scott Chamberlain
sourceslug: _drafts/2015-05-18-mow-the-lawn.Rmd
tags:
- R
- geojson
- javascript
- geospatial
---



`lawn` is an R wrapper for the Javascript library [turf.js](http://turfjs.org/) for advanced geospatial analysis. In addition, we have a few functions to interface with the [geojson-random](https://github.com/mapbox/geojson-random) Javascript library.

`lawn` includes traditional spatial operations, helper functions for creating GeoJSON data, and data classification and statistics tools.

There is an additional helper function (see `view()`) in this package to help visualize data with interactive maps via the `leaflet` package ([https://github.com/rstudio/leaflet](https://github.com/rstudio/leaflet)). Note that `leaflet` is not required to install `lawn` - it's in Suggests, not Imports or Depends.

Use cases for this package include (but not limited to, obs.) the following (all below assumes GeoJSON format):

* Create random spatial data.
* Convert among spatial data types (e.g. `Polygon` to `FeatureCollection`)
* Transform objects, including merging many, simplifying, calculating hulls, etc.
* Measuring objects
* Performing interpolation of objects
* Aggregating data (aka properties) associated with objects

## Install

Stable `lawn` version from CRAN - this should fetch `leaflet`, which is not on CRAN, but in a `drat` repo (let me know if it doesn't)


```r
install.packages("lawn")
```

Or, the development version from Github


```r
devtools::install_github("ropensci/lawn")
```


```r
library("lawn")
```

## view

`lawn` includes a tiny helper function for visualizing geojson. For examples below, we'll make liberal use of the `lawn::view()` function to visualize what it is the heck we're doing. mkay, lets roll...

We've tried to make `view()` work with as many inputs as possible, from class `character` containing
json to the class `json` from the `jsonlite` package, to the class `list` to all of the GeoJSON outputs
from functions in `lawn`.


```r
view(lawn_data$points_average)
```

![map1](/2015-05-18-mow-the-lawn/map1.png)

Here, we sample at random two points from the same dataset just viewed.


```r
lawn_sample(lawn_data$points_average, 2) %>% view()
```

![map2](/2015-05-18-mow-the-lawn/map2.png)

## Make some geojson data

Point


```r
lawn_point(c(-74.5, 40))
#> $type
#> [1] "Feature"
#> 
#> $geometry
#> $geometry$type
#> [1] "Point"
#> 
#> $geometry$coordinates
#> [1] -74.5  40.0
#> 
#> 
#> $properties
#> named list()
#> 
#> attr(,"class")
#> [1] "point"
```


```r
lawn_point(c(-74.5, 40)) %>% view
```

![point](/2015-05-18-mow-the-lawn/point.png)

Polygon


```r
rings <- list(list(
  c(-2.275543, 53.464547),
  c(-2.275543, 53.489271),
  c(-2.215118, 53.489271),
  c(-2.215118, 53.464547),
  c(-2.275543, 53.464547)
))
lawn_polygon(rings)
#> $type
#> [1] "Feature"
#> 
#> $geometry
#> $geometry$type
#> [1] "Polygon"
#> 
#> $geometry$coordinates
#> , , 1
#> 
#>           [,1]      [,2]      [,3]      [,4]      [,5]
#> [1,] -2.275543 -2.275543 -2.215118 -2.215118 -2.275543
#> 
#> , , 2
#> 
#>          [,1]     [,2]     [,3]     [,4]     [,5]
#> [1,] 53.46455 53.48927 53.48927 53.46455 53.46455
#> 
#> 
#> 
#> $properties
#> named list()
#> 
#> attr(,"class")
#> [1] "polygon"
```


```r
lawn_polygon(rings) %>% view
```

![polygon](/2015-05-18-mow-the-lawn/polygon.png)

Random set of points


```r
lawn_random(n = 2)
#> $type
#> [1] "FeatureCollection"
#> 
#> $features
#>      type geometry.type  geometry.coordinates
#> 1 Feature         Point -137.46327, -63.46154
#> 2 Feature         Point  -110.68426, 83.10533
#> 
#> attr(,"class")
#> [1] "featurecollection"
```


```r
lawn_random(n = 5) %>% view
```

![rand1](/2015-05-18-mow-the-lawn/lawn_random.png)

Or, use a different Javascript library ([geojson-random](https://github.com/mapbox/geojson-random)) to create random features.

Positions


```r
gr_position()
#> [1] -179.77996   45.99018
```

Points


```r
gr_point(2)
#> $type
#> [1] "FeatureCollection"
#> 
#> $features
#>      type geometry.type geometry.coordinates
#> 1 Feature         Point   5.83895, -27.77218
#> 2 Feature         Point   78.50177, 14.95840
#> 
#> attr(,"class")
#> [1] "featurecollection"
```


```r
gr_point(2) %>% view
```

![rand2](/2015-05-18-mow-the-lawn/geojsonrandom_points.png)

Polygons


```r
gr_polygon(n = 1, vertices = 5, max_radial_length = 5)
#> $type
#> [1] "FeatureCollection"
#> 
#> $features
#>      type geometry.type
#> 1 Feature       Polygon
#>                                                                                                           geometry.coordinates
#> 1 67.58827, 67.68551, 67.00091, 66.70156, 65.72578, 67.58827, -42.11340, -42.69850, -43.54866, -42.42758, -41.76731, -42.11340
#> 
#> attr(,"class")
#> [1] "featurecollection"
```


```r
gr_polygon(n = 1, vertices = 5, max_radial_length = 5) %>% view
```

![rand3](/2015-05-18-mow-the-lawn/geojsonrandom_polygons.png)

## count

Count number of points within polygons, appends a new field to properties (see the `count` field)


```r
lawn_count(polygons = lawn_data$polygons_count, points = lawn_data$points_count)
#> $type
#> [1] "FeatureCollection"
#> 
#> $features
#>      type pt_count geometry.type
#> 1 Feature        2       Polygon
#> 2 Feature        0       Polygon
#>                                                                                           geometry.coordinates
#> 1 -112.07239, -112.07239, -112.02810, -112.02810, -112.07239, 46.58659, 46.61761, 46.61761, 46.58659, 46.58659
#> 2 -112.02398, -112.02398, -111.96613, -111.96613, -112.02398, 46.57043, 46.61502, 46.61502, 46.57043, 46.57043
#> 
#> attr(,"class")
#> [1] "featurecollection"
```

## distance

Define two points


```r
from <- '{
 "type": "Feature",
 "properties": {},
 "geometry": {
   "type": "Point",
   "coordinates": [-75.343, 39.984]
 }
}'
to <- '{
  "type": "Feature",
  "properties": {},
  "geometry": {
    "type": "Point",
    "coordinates": [-75.534, 39.123]
  }
}'
```

Calculate distance, default units is kilometers (default output: `km`)


```r
lawn_distance(from, to)
#> [1] 97.15958
```

## sample from a FeatureCollection


```r
dat <- lawn_data$points_average
cat(dat)
#> {
#>   "type": "FeatureCollection",
#>   "features": [
#>     {
#>       "type": "Feature",
#>       "properties": {
#>         "population": 200
#>       },
#>       "geometry": {
#>         "type": "Point",
...
```

Sample 2 points at random


```r
lawn_sample(dat, 2)
#> $type
#> [1] "FeatureCollection"
#> 
#> $features
#>      type population geometry.type geometry.coordinates
#> 1 Feature        200         Point   10.80643, 59.90891
#> 2 Feature        600         Point   10.71579, 59.90478
#> 
#> attr(,"class")
#> [1] "featurecollection"
```

## extent

Calculates the extent of all input features in a FeatureCollection, and returns a bounding box.


```r
lawn_extent(lawn_data$points_average)
#> [1] 10.71579 59.90478 10.80643 59.93162
```

## buffer

Calculates a buffer for input features for a given radius.


```r
dat <- '{
 "type": "Feature",
 "properties": {},
 "geometry": {
     "type": "Polygon",
     "coordinates": [[
       [-112.072391,46.586591],
       [-112.072391,46.61761],
       [-112.028102,46.61761],
       [-112.028102,46.586591],
       [-112.072391,46.586591]
     ]]
   }
}'
view(dat)
```

![buffer1](/2015-05-18-mow-the-lawn/buffer1.png)


```r
lawn_buffer(dat, 1, "miles") %>% view
```

![buffer2](/2015-05-18-mow-the-lawn/buffer2.png)

## Union polygons together


```r
poly1 <- '{
 "type": "Feature",
 "properties": {
   "fill": "#0f0"
 },
 "geometry": {
   "type": "Polygon",
   "coordinates": [[
     [-122.801742, 45.48565],
     [-122.801742, 45.60491],
     [-122.584762, 45.60491],
     [-122.584762, 45.48565],
     [-122.801742, 45.48565]
    ]]
 }
}'

poly2 <- '{
 "type": "Feature",
 "properties": {
   "fill": "#00f"
 },
 "geometry": {
   "type": "Polygon",
   "coordinates": [[
     [-122.520217, 45.535693],
     [-122.64038, 45.553967],
     [-122.720031, 45.526554],
     [-122.669906, 45.507309],
     [-122.723464, 45.446643],
     [-122.532577, 45.408574],
     [-122.487258, 45.477466],
     [-122.520217, 45.535693]
     ]]
 }
}'
view(poly1)
```

![union1](/2015-05-18-mow-the-lawn/union1.png)


```r
view(poly2)
```

![union2](/2015-05-18-mow-the-lawn/union2.png)

Visualize union-ed polygons


```r
lawn_union(poly1, poly2) %>% view
```

![union3](/2015-05-18-mow-the-lawn/union3.png)

See also `lawn_merge()` and `lawn_intersect()`.

## lint input geojson

For most functions, you can lint your input geojson data to make sure it is proper geojson. We use 
the javascript library [geojsonhint](https://github.com/mapbox/geojsonhint). See the `lint` parameter.

Good GeoJSON


```r
dat <- '{
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "properties": {
        "population": 200
      },
      "geometry": {
        "type": "Point",
        "coordinates": [10.724029, 59.926807]
      }
    }
  ]
}'
lawn_extent(dat)
#> [1] 10.72403 59.92681 10.72403 59.92681
```

Bad GeoJSON


```r
dat <- '{
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "properties": {
        "population": 200
      },
      "geometry": {
        "type": "Point"
      }
    }
  ]
}'
lawn_extent(dat, lint = TRUE)

#> Error: Line 1 - "coordinates" property required
```

## To do

* As Turf.js changes, we'll update `lawn`
* Performance improvements. We realize that this package is slower than the C based `rgdal`/`rgeos` - we are looking into ways to increaes performance to get closer to the performance of those packages. 
