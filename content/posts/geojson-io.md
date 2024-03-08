---
name: geojson-io
layout: post
title: geojsonio - a new package to do geojson things
date: 2015-04-30
author: Scott Chamberlain
sourceslug: _drafts/2015-04-30-geojson-io.Rmd
tags:
- R
- geojson
- topojson
- geospatial
---



`geojsonio` converts geographic data to GeoJSON and TopoJSON formats - though the focus is mostly on GeoJSON 

For those not familiar GeoJSON it is a format for encoding a variety of geographic data structures. GeoJSON supports the following geometry types: Point, LineString, Polygon, MultiPoint, MultiLineString, MultiPolygon, and GeometryCollection. These geometry types are also found in [well known text (WKT)](https://en.wikipedia.org/wiki/Well-known_text), and have equivalents in R's spatial classes. Read the [spec](https://geojson.org/geojson-spec.html) for more detailed information. 

Other great geojson resources:

* GeoJSON lint - lint your geojson - <https://geojsonlint.com/>
* GeoJSON.io - make maps with geojson input or draw maps and get geojson - <https://geojson.io/>

Functions in this package are organized first around what you're working with or want to get, geojson or topojson, then convert to or read from various formats:

* `geojson_list()` - convert to GeoJSON as R list format
* `geojson_json()` - convert to GeoJSON as json
* `geojson_read()`/`topojson_read()` - read a GeoJSON/TopoJSON file from file path or URL
* `geojson_write()` - write a GeoJSON file locally (no write TopoJSON yet)

Each of the above functions have methods for various objects/classes, including `numeric`, `data.frame`, `list`, `SpatialPolygons`, `SpatialLines`, `SpatialPoints`, etc. (including the classes in `rgeos`)

Use cases for this package include (but not limited to, obs.) the following:

* Get data in GeoJSON json format, and you want to get it into a list in R.
* Get data into GeoJSON format to use downstream to make a interactive map
  * in R (e.g., with [leaflet](https://github.com/rstudio/leaflet))
  * or in another context (e.g., using javascript with mapbox/leaflet)
* Data is in a data.frame/matrix/list and you want to make GeoJSON format data.
* Data is in one of the many spatial classes (e.g., `SpatialPoints`) and you want GeoJSON
* You need to add styling to your data - can do with this package for certain data types.
* You want to check that your GeoJSON data is valid - two ways to do it in geojsonio.
* Combine objects together (e.g., a point and a line), either from two `geo_list` objects, or two `json` objects. See `?geojson-add`

## Install

See the github repo for notes about dependencies <https://github.com/ropensci/geojsonio#install> 

CRAN version or the dev version from GitHub


```r
install.packages("geojsonio")
devtools::install_github("sckott/geojsonio")
```


```r
library("geojsonio")
```

## GeoJSON

### Convert various formats to geojson

From a `numeric` vector of length 2

as _json_


```r
geojson_json(c(32.45, -99.74))
#> {"type":"FeatureCollection","features":[{"type":"Feature","geometry":{"type":"Point","coordinates":[32.45,-99.74]},"properties":{}}]}
```

as a __list__


```r
geojson_list(c(32.45, -99.74))
#> $type
#> [1] "FeatureCollection"
#> 
#> $features
#> $features[[1]]
#> $features[[1]]$type
#> [1] "Feature"
#> 
#> $features[[1]]$geometry
#> $features[[1]]$geometry$type
...
```

From a `data.frame`

as __json__


```r
geojson_json(us_cities[1:2, ], lat = 'lat', lon = 'long')
#> {"type":"FeatureCollection","features":[{"type":"Feature","geometry":{"type":"Point","coordinates":[-99.74,32.45]},"properties":{"name":"Abilene TX","country.etc":"TX","pop":"113888","capital":"0"}},{"type":"Feature","geometry":{"type":"Point","coordinates":[-81.52,41.08]},"properties":{"name":"Akron OH","country.etc":"OH","pop":"206634","capital":"0"}}]}
```

as a __list__


```r
geojson_list(us_cities[1:2, ], lat = 'lat', lon = 'long')
#> $type
#> [1] "FeatureCollection"
#> 
#> $features
#> $features[[1]]
#> $features[[1]]$type
#> [1] "Feature"
#> 
#> $features[[1]]$geometry
#> $features[[1]]$geometry$type
...
```

From `SpatialPolygons` class


```r
library('sp')
poly1 <- Polygons(list(Polygon(cbind(c(-100, -90, -85, -100),
  c(40, 50, 45, 40)))), "1")
poly2 <- Polygons(list(Polygon(cbind(c(-90, -80, -75, -90),
  c(30, 40, 35, 30)))), "2")
(sp_poly <- SpatialPolygons(list(poly1, poly2), 1:2))
#> An object of class "SpatialPolygons"
#> Slot "polygons":
#> [[1]]
#> An object of class "Polygons"
#> Slot "Polygons":
#> [[1]]
#> An object of class "Polygon"
#> Slot "labpt":
#> [1] -91.66667  45.00000
#> 
...
```

to __json__


```r
geojson_json(sp_poly)
#> {"type":"FeatureCollection","features":[{"type":"Feature","id":1,"properties":{"dummy":0},"geometry":{"type":"Polygon","coordinates":[[[-100,40],[-90,50],[-85,45],[-100,40]]]}},{"type":"Feature","id":2,"properties":{"dummy":0},"geometry":{"type":"Polygon","coordinates":[[[-90,30],[-80,40],[-75,35],[-90,30]]]}}]}
```

to a __list__


```r
geojson_list(sp_poly)
#> $type
#> [1] "FeatureCollection"
#> 
#> $features
#> $features[[1]]
#> $features[[1]]$type
#> [1] "Feature"
#> 
#> $features[[1]]$id
#> [1] 1
...
```

From `SpatialPoints` class


```r
x <- c(1, 2, 3, 4, 5)
y <- c(3, 2, 5, 1, 4)
(s <- SpatialPoints(cbind(x, y)))
#> SpatialPoints:
#>      x y
#> [1,] 1 3
#> [2,] 2 2
#> [3,] 3 5
#> [4,] 4 1
#> [5,] 5 4
#> Coordinate Reference System (CRS) arguments: NA
```

to __json__


```r
geojson_json(s)
#> {"type":"FeatureCollection","features":[{"type":"Feature","id":1,"properties":{"dat":1},"geometry":{"type":"Point","coordinates":[1,3]}},{"type":"Feature","id":2,"properties":{"dat":2},"geometry":{"type":"Point","coordinates":[2,2]}},{"type":"Feature","id":3,"properties":{"dat":3},"geometry":{"type":"Point","coordinates":[3,5]}},{"type":"Feature","id":4,"properties":{"dat":4},"geometry":{"type":"Point","coordinates":[4,1]}},{"type":"Feature","id":5,"properties":{"dat":5},"geometry":{"type":"Point","coordinates":[5,4]}}]}
```

to a __list__


```r
geojson_list(s)
#> $type
#> [1] "FeatureCollection"
#> 
#> $features
#> $features[[1]]
#> $features[[1]]$type
#> [1] "Feature"
#> 
#> $features[[1]]$id
#> [1] 1
...
```

### Combine objects

`geo_list` + `geo_list`

> Note: `geo_list` is the output type from `geojson_list()`, it's just a list with a class attached so we know it's geojson :)


```r
vec <- c(-99.74, 32.45)
a <- geojson_list(vec)
vecs <- list(c(100.0, 0.0), c(101.0, 0.0), c(100.0, 0.0))
b <- geojson_list(vecs, geometry = "polygon")
a + b
#> $type
#> [1] "FeatureCollection"
#> 
#> $features
#> $features[[1]]
#> $features[[1]]$type
#> [1] "Feature"
#> 
#> $features[[1]]$geometry
#> $features[[1]]$geometry$type
...
```

`json` + `json`


```r
c <- geojson_json(c(-99.74, 32.45))
vecs <- list(c(100.0, 0.0), c(101.0, 0.0), c(101.0, 1.0), c(100.0, 1.0), c(100.0, 0.0))
d <- geojson_json(vecs, geometry = "polygon")
c + d
#> {"type":"FeatureCollection","features":[{"type":"Feature","geometry":{"type":"Point","coordinates":[-99.74,32.45]},"properties":{}},{"type":"Feature","geometry":{"type":"Polygon","coordinates":[[[100,0],[101,0],[101,1],[100,1],[100,0]]]},"properties":[]}]}
```

### Write geojson


```r
geojson_write(us_cities[1:2, ], lat = 'lat', lon = 'long')
#> <geojson>
#>   Path:       myfile.geojson
#>   From class: data.frame
```

## Topojson

In the current version of this package you can read topojson. Writing topojson was in this package, but is gone for now - will come back later as in interface to [topojson](https://github.com/mbostock/topojson) via [V8](https://github.com/jeroenooms/V8).

Read from a file


```r
file <- system.file("examples", "us_states.topojson", package = "geojsonio")
out <- topojson_read(file)
```

Read from a URL


```r
url <- "https://raw.githubusercontent.com/shawnbot/d3-cartogram/master/data/us-states.topojson"
out <- topojson_read(url)
```

## Lint geojson

There are two ways to do this in this package. 

### lint, locally

Uses the javascript library [geojsonhint](https://github.com/mapbox/geojsonhint) from Mapbox. We're running this locally via the [V8](https://cran.rstudio.com/web/packages/V8/) package.

Good


```r
lint('{"type": "Point", "coordinates": [-100, 80]}')
#> [1] "valid"
```

Bad


```r
lint('{"type": "Rhombus", "coordinates": [[1, 2], [3, 4], [5, 6]]}')
#> $message
#> [1] "The type Rhombus is unknown"
#> 
#> $line
#> [1] 1
```

### validate, with a web service

Uses the web service at [https://geojsonlint.com/](https://geojsonlint.com/)

Good


```r
validate('{"type": "Point", "coordinates": [-100, 80]}')
#> $status
#> [1] "ok"
```

Bad


```r
validate('{"type": "Rhombus", "coordinates": [[1, 2], [3, 4], [5, 6]]}')
#> $message
#> [1] "\"Rhombus\" is not a valid GeoJSON type."
#> 
#> $status
#> [1] "error"
```

## To do

* I'd like to replace `rgdal` with javascript libraries to read from various file types (kml, shp, etc.) and convert to geojson. This is [in development](https://github.com/ropensci/geojsonio/tree/js), and will come in the next version of this package most likely. This should make installation a bit easier as we won't have to depend on `rgdal` and `GDAL`
* Performance improvements. Some operations already use the gdal or geos C libraries, so are quite fast, though the round trip to disk and back does take significant time. I'd like to speed this up. 
* More input types. We already have operations (json, list, etc.) for lots of input types (data.frame, list, sp classes), but likely there will be more added. 
* Most likely add functions `topojson_list()`, `topojson_json()`
