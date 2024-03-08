---
name: geojson
layout: post
title: R to GeoJSON
date: 2013-06-30
author: Scott Chamberlain
sourceslug: _drafts/2013-06-30-geojson.Rmd
tags:
- R
- API
- geojson
- json
- openstreetmaps
- maps
---

**UPDATE** As you can see in Patrick's comment below you can convert to GeoJSON format files with rgdal as an alternative to calling the Ogre web API described below. See [here](https://github.com/patperu/write2geojson/blob/master/write-geojson.R) for example code for converting to GeoJSON with rgdal.

---

GitHub recently introduced the ability to render [GeoJSON][geojson] files on their site as maps [here][post1], and recently introduced [here][post2] support for [TopoJSON][topojson], an extension of GeoJSON can be up to 80% smaller than GeoJSON, support for other file extensions (`.topojson` and `.json`), and you can embed the maps on other sites (so awesome). The underlying maps used on GitHub are [Openstreet Maps][openstreet]. 

A recent blog post showed how to convert .shp or .kml files to GeoJSON to then upload to GitHub [here][ruby]. The approach used Ruby on the command line locally to convert the geospatial files to GeoJSON. 

Can we do this in R? Perhaps others have already done this, but there's more than one way to do anything, no? 

I'm not aware of a converter to GeoJSON within R, but there is a web service that can do this, called [Ogre][ogre]. The service lets you `POST` a file, which then converts to GeoJSON and gives it back to you. Ogre accepts many different file formats: BNA, CSV, DGN, DXF, zipped shapefiles, GeoConcept, GeoJSON, GeoRSS, GML, GMT, KML, MapInfo, and VRT. 

We can use the Ogre API to upload a local geospatial file of various formats and get the GeoJSON back, then put it up on GitHub, and they render the map for you. Sweetness. 

So here's the protocol. 

### 1. Load httr. What is httr? For those not in the know it is a simpler wrapper around RCurl, a curl interface for R.


```r
# install.packages('httr')
library(httr)
```

### 2. Here is a function to convert your geospatial files to GeoJSON (with roxygen docs).


```r
togeojson <- function(file, writepath = "~") {
    url <- "http://ogre.adc4gis.com/convert"
    tt <- POST(url, body = list(upload = upload_file(file)))
    out <- content(tt, as = "text")
    fileConn <- file(writepath)
    writeLines(out, fileConn)
    close(fileConn)
}
```

### 3. Convert a file to GeoJSON

**KML**

In the first line I specify the location of the file on my machine. In the second line the function `togeojson` reads in the file, sends the file to the API endpoint *http://ogre.adc4gis.com/convert*, collects the returned GeoJSON object, and saves the GeoJSON to a file that you specify. Here we are converting a KML file with point occurrences (data collected from [USGS's BISON service](http://bison.usgs.ornl.gov/)). 


```r
file <- "~/github/sac/rgeojson/acer_spicatum.kml"
togeojson(file, "~/github/sac/rgeojson/acer_spicatum.geojson")
```


**Shapefiles**

Here, we are converting a zip file containing shape files for *Pinus contorta* (data collected from the USGS [here](http://esp.cr.usgs.gov/data/little/). 


```r
file <- "~/github/sac/rgeojson/pinucont.zip"
togeojson(file, "~/github/sac/rgeojson/pinus.geojson")
```


### 4. Then commit and push to GitHub. And this is what they look like on GitHub

*Acer spicatum* distribution (points)

{{< rawhtml >}}
<script src="https://embed.github.com/view/geojson/sckott/rgeojson/output/acer_spicatum.geojson"></script>
{{< /rawhtml >}}

*Pinus contorta* distribution (polygons)

{{< rawhtml >}}
<script src="https://embed.github.com/view/geojson/sckott/rgeojson/output/pinus.geojson"></script>
{{< /rawhtml >}}

If you want, you can clone a repo from my account. Then do the below. (of course, you must have git installed, and have a GitHub account...)

First, fork my `rgeojson` repo [here](https://github.com/sckott/rgeojson) to your GitHub account.

Second, in your terminal/command line...

```bash
git clone https://github.com/<yourgithubusername>/rgeojson.git
cd rgeojson
```

Third, in R specify the location of either the KML file or the zipped shape files, then call `togeojson` function to convert the KML file to a GeoJSON file (which should output a file *acer_spicatum.geojson*)


```r
file <- "/path/to/acer_spicatum.kml"
togeojson(file, "~/path/to/write/to/acer_spicatum.geojson")
```


Fourth, back in the terminal...

```bash
git add acer_spicatum.geojson
git commit -a -m 'some cool commit message'
git push
```

Fifth, go to your *rgeojson* repo on GitHub and click on the *acer_spicatum.geojson* file, and the map should render.

Look for this functionality to come to the [rbison][rbison] and [rgbif][rgbif] R packages soon. Why is that cool?  Think of the workflow: Query for species occurrence data in the BISON or GBIF databases, convert the results to a GeoJSON file, push to GitHub, and you have an awesome interactive map on the web. Not too bad eh. 

[post1]: https://github.com/blog/1528-there-s-a-map-for-that
[post2]: https://github.com/blog/1541-geojson-rendering-improvements
[openstreet]: http://www.openstreetmap.org/
[ruby]: http://ben.balter.com/2013/06/26/how-to-convert-shapefiles-to-geojson-for-use-on-github/
[geojson]: http://en.wikipedia.org/wiki/GeoJSON
[topojson]: https://github.com/mbostock/topojson
[ogre]: http://ogre.adc4gis.com/
[rbison]: https://github.com/ropensci/rbison
[rgbif]: https://github.com/ropensci/rgbif
