--- 
name: R2G2-package
layout: post
title: Displaying Your Data in Google Earth Using R2G2
date: 2012-10-24
author: Pascal Mickelson
sourceslug: _posts/2012-10-24-R2G2-package.md
tags: 
- R
- ecology
- mapping
- visualization
- google earth
- KML
---

Have you ever wanted to easily visualize your ecology data in [Google Earth][googleearth]?  [R2G2][r2g2] is a new package for R, available via [R CRAN][rcran] and formally described in [this Molecular Ecology Resources article][MERarticle], which provides a user-friendly bridge between R and the Google Earth interface.  Here, we will provide a brief introduction to the package, including a short tutorial, and then encourage you to try it out with your own data!

[Nils Arrigo][nils], with some help from [Loren Albert][loren], [Mike Barker][mike], and Pascal Mickelson (one of the contributors to [Recology][recology]), has created a set of R tools to generate KML files to view data with geographic components.  Instead of just telling you what the tools can do, though, we will show you a couple of examples using publically available data.  Note: a number of individual files are linked to throughout the tutorial below, but just in case you would rather download all the tutorial files in one go, have at it ([tutorial zip file][tutorialfile]).

Among the basic tools in [R2G2][r2g2] is the ability to place features—like dots, shapes, or images (including plots you produced in R)— that represent discrete observations at specific geographical locations.  For example, in the figure below, we show the migratory path of a particular turkey vulture in autumn of three successive years (red = 2009; blue = 2010; green = 2011).  

{{< rawhtml >}}
<div align="center">
<img src="/R2G2tutorial/Vulture_Path.jpg" alt="Google Earth image with three successive years of a particular turkey vulture's migration" width="800"><br>
<small>Google Earth imagery showing migratory path of a particular turkey vulture in 2009, 2010, and 2011.</small>
</div>  
{{< /rawhtml >}}

We use the *PolyLines2GE* function that is part of [R2G2][r2g2] to create line segments between the geographical coordinates which have been obtained from a turkey vulture tagged with a transponder (data accessed via the [Movebank Data Repository][movebank] and is from the [Turkey Vulture Acopian Center USA GPS][turkeyvulturestudy]).  The *PolyLines2GE* function looks like the following:  

```r
PolyLines2GE(coords = vulture_path[,2:3],  
			nesting = vulture_path[,1],  
			colors = "auto",  
			goo = "Vulture_Path.kml",  
			maxAlt = 1e4,  
			fill = FALSE,  
			closepoly = FALSE,  
			lwd = 2,  
			extrude = 0)
```

It expects to receive an array ("coords") containing latitude and longitude coordinates in decimal degrees. Additionally, each individual coordinate has a flag associated with it ("nesting") so that each data series can be distinguished.  Illustrating what you need is easier than explaining:

```r
nesting longitude latitude
1	long1A		lat1A
1	long1B		lat1B
1	long1C		lat1C
2	long2A		lat2A
2	long2B		lat2B
3	long3A		lat3A
3	long3B		lat3B
3	long3C		lat3C
```

Feeding the columns of this array to the function results in three differently colored lines:  the first would connect the coordinates 1A-1B-1C, while the second would connect 2A-2B, and the third would connect 3A-3B-3C.  The only other user-defined input that is strictly necessary is the output file name ("Vulture_Path.kml" in this case).  The other options—which allow you control of the appearance of the lines and of the altitude at which your line displays in Google Earth—have reasonable defaults that are well-documented in the function definition itself.  Check out this example in Google Earth [by downloading the KML file][vultureKML].  Alternatively, [download the annotated R script][vultureR] and generate the KML file for yourself.

Now, let's say you wanted to get a sense of the range and abundance of two congeneric species.  In this second example, we use the *Hist2GE* function to create a histogram—overlaid on the surface of the earth—which shows the species distribution of *Mimulus lewisii* (red) and *Mimulus nasutus* (blue) in North America.  

{{< rawhtml >}}
<div align="center">
<img src="/R2G2tutorial/Mimulus_Distribution.jpg" alt="Google Earth image showing the distribution of Mimulus in North America" width="800"><br>
<small>Google Earth imagery showing the species distribution of <em>Mimulus lewisii</em> and <em>Mimulus nasutus</em></small>
</div>
{{< /rawhtml >}}


As you might expect, each polygon represents an occurrence of the species in question, while the height of the polygon represents the abundance of the species at that geographic location.  Species occurring within a particular distance of each other have been grouped together for the histogram.  For this example, we retrieve data from the [GBIF][gbif] database from within R (see the example code for how that is done).  Inputs to the Hist2GE function are:
```r
Hist2GE(coords = MyCompleteData[, 8:7],  
		species = MyCompleteData[, 1],  
		grid = grid10000,  
		goo = "Mimulus",  
		nedges = 6,  
		orient = 45,  
		maxAlt = 1e4)
```
As in the first example, the function expects to receive an array containing the longitude and latitude ("coords"), a vector distinguishing individual observations ("species"), and an output file name ("goo").  In this case, however, we also need to specify the size of the grid we will use to group observations together to construct the histogram.  Several pre-defined grid sizes are included in the package to do this grouping; these all cover large geographic areas and therefore must account for the curvature of the earth.  Here is a list of these pre-defined grids:

{{< rawhtml >}}
<table border="1">
    <tr><th>Grid Name</th><th>Approximate Area of Grid Division </th></tr>
    <tr><td>grid20000</td><td>25,500 sq. km</td></tr>
    <tr><td>grid10000</td><td>51,000 sq. km</td></tr>
    <tr><td>grid5000</td><td>102,000 sq. km</td></tr>
    <tr><td>grid500</td><td>1,020,000 sq. km</td></tr>
    <tr><td>grid50</td><td>10,200,000 sq. km</td></tr>
</table>  
{{< /rawhtml >}}

For smaller geographic areas (less than 25,000 square kilometers, or an area of about 158 km per side), you can customize the grid size by specifying the bounds of your region of interest in decimal degrees, as well as the coarseness of the grid within that region.  While it is possible to use this custom grid definition for larger sizes, beware that not all areas defined thusly will be of equal size due to the earth's curvature (obviously the bigger you go, the worse it gets...).  Finally, you again have control over the display parameters of the histogram.  In particular, the maximum altitude ("maxAlt") controls how high the tallest bar in the histogram will go.  Here is [the resulting KML file][mimulusKML], as well as [the annotated R script][mimulusR] so you can further explore the example.

More complex visual representations are also possible using [R2G2][r2g2].  For instance, you can also create contour plots or phylogenies overlaid directly on the surface of the earth.  We included a couple examples of this type in [our Molecular Ecology Resources article][MERarticle], and if the response seems good, we may post a follow up tutorial showing how we went about creating those examples.

It is our sincere hope that you will use the tools in [R2G2][r2g2] to more effectively visualize the geographical aspects of your data.  In particular, we are excited about the potential for incorporating [R2G2][r2g2] into data analysis pipelines connecting analysis in R with data visualization and exploration in Google Earth.  Ultimately, the inclusion of KML files as supplementary materials to journal articles should also enrich one's understanding of the data being presented!

{{< rawhtml >}}
<big><b>Note:  If you make something cool using <a href="http://cran.r-project.org/web/packages/R2G2/index.html">R2G2</a>, please post a link to your KML file in the comments; we would love to see!</b></big>
{{< /rawhtml >}}

{{< line_break >}}

Citation information for [R2G2][r2g2]:  
*Arrigo, N., Albert, L. P., Mickelson, P. G. and Barker, M. S. (2012), Quantitative visualization of biological data in Google Earth using R2G2, an R CRAN package. Molecular Ecology Resources. doi: 10.1111/1755-0998.12012*

[googleearth]: http://earth.google.com
[rcran]: http://cran.r-project.org/
[MERarticle]: http://onlinelibrary.wiley.com/doi/10.1111/1755-0998.12012/abstract
[nils]: http://barkerlab.net/nils.html
[loren]: http://portal.environment.arizona.edu/students/profiles/loren-albert
[mike]: http://barkerlab.net/mike.html
[recology]: http://sckott.github.io/about.html
[gbif]: http://data.gbif.org/
[r2g2]: http://cran.r-project.org/web/packages/R2G2/index.html
[vultureKML]: /R2G2tutorial/Vulture_Path.kml
[vultureR]: /R2G2tutorial/Vulture_Path.R
[movebank]: http://movebank.org/
[turkeyvulturestudy]: http://movebank.org/movebank/#page%3Dstudies%2Cpath%3Dstudy481458
[mimulusKML]: /R2G2tutorial/Mimulus_Distribution.kml
[mimulusR]: /R2G2tutorial/Mimulus_Distribution.R
[tutorialfile]: /R2G2tutorial/R2G2tutorial.zip
