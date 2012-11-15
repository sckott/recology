##Load required packages
require(R2G2)
require(dismo)
require(XML)
require(gtools)

#Set working directory (change to directory where you have placed "Vulture_Path.R" and associated tutorial files)
setwd("add/your/path/here")
#Import vulture flight path; Data accessed via Movebank Data Repository ( http://movebank.org/ )
#From the Turkey Vulture Acopian Center USA GPS http://movebank.org/movebank/#page%3Dstudies%2Cpath%3Dstudy481458
vulture_path_data = read.csv('Turkey_Vulture.csv') #import turkey vulture flight path data (time, gps coordinates, etc...)

#Pick a subset of the data
#Steamhouse 1 is a particular vulture
steamhouse1 <- subset(vulture_path_data, vulture_path_data$individual.local.identifier=="Steamhouse 1")
#There are different phases of the vulture's movement (breeding grounds, spring migration, fall migration, etc...).
#Choose fall migrations
fallmigration <- subset(steamhouse1, steamhouse1$http...vocabulary.movebank.org.extended.raptor.workshop.attributes.migration.state=="FallMigration")
#Extract longitude and latitude coordinates from the fall migration data
longtemp <- fallmigration$location.long
lattemp <- fallmigration$location.lat
#Manually select a particular migration (from fall of 2009); did not do this programmatically, though it could be done
startpoints=1;stoppoints=249;
long09 = longtemp[startpoints:stoppoints]
lat09 = lattemp[startpoints:stoppoints]
nest09 = rep(1,stoppoints)
#Combine latitude and longitude into a single array of coordinates
vulture_path09 <- cbind(nest09,long09,lat09) 

#Manually select a particular migration (from fall of 2010); did not do this programmatically, though it could be done
startpoints=250;stoppoints=667;
long10 = longtemp[startpoints:stoppoints]
lat10 = lattemp[startpoints:stoppoints]
nest10 = rep(2,stoppoints-startpoints+1)
vulture_path10 <- cbind(nest10,long10,lat10)
vulture_path10 = vulture_path10[-121,]

#Manually select a particular migration (from fall of 2011); did not do this programmatically, though it could be done
startpoints=668;stoppoints=724;
long11 = longtemp[startpoints:stoppoints]
lat11 = lattemp[startpoints:stoppoints]
nest11 = rep(3,stoppoints-startpoints+1)
vulture_path11 <- cbind(nest11,long11,lat11)
#vulture_path11 = vulture_path11[-41,] #Coordinates don't make sense. Omitted this point for example because I'm unfamiliar with dataset
#vulture_path11 = vulture_path11[-35,] #Coordinates don't make sense. Omitted this point for example because I'm unfamiliar with dataset

#Combine all three fall migrations. 
#The nesting vector (column one of vulture_path) insures that each migration is represented by a different color
vulture_path <- rbind(vulture_path09,vulture_path10,vulture_path11)

#Use PolyLines2GE to create a line between each of the geographical coordinates
#Three tracks will be created, one for each year's migration
#Output file shows up in current working directory and will be named "Vulture_Path.kml"
PolyLines2GE(coords = vulture_path[,2:3], 
             nesting = vulture_path[,1],
             colors = "auto",
             goo = "Vulture_Path.kml", 
             maxAlt = 1e4, 
             fill = FALSE,
             closepoly = FALSE,
             lwd = 2,
             extrude = 0)