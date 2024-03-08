#If you're not familiar with the GBIF database, you can find out more here: http://www.gbif.org/
#Of course, if have a dataset that already includes species occurrences, you can skip this step.  Ultimately, what you need is

require(R2G2)
require(dismo)
require(XML)

## Fill your gift list (can also be retrieved from an excel spreadsheet, saved as tab-delimited file, using read.delim)
MySpeciesList = data.frame(genus = rep("Mimulus", 2), species = c("lewisii", "nasutus"))

## Loop over your species of interest
MyCompleteData = NULL # initiate an empty matrix (leave the number of lines / columns unspecified, it will adapt itself at the time it gets filled)

for(i in 1:nrow(MySpeciesList)){ #iterate over your species of interest
  # get the genus / species
  MyGenus = as.character(MySpeciesList[i, 1]) #as.character... used to make sure that the genus and species names are inputted as characters (and not as factors..., gbif would crah otherwise...)
  MySpecies = as.character(MySpeciesList[i, 2])
  
  # retrieve them from GBIF
  occ = gbif(genus = MyGenus, species = MySpecies)
  
  # append the obtained accessions to MyCompleteData
  MyCompleteData = rbind(MyCompleteData, occ)
  }

dim(MyCompleteData) # quick check at the number of accessions we retrieved

## Make the Histograms  
# get rid of accessions without geographical coordinates
MyCompleteData = MyCompleteData[ MyCompleteData[, 7] != 0 & MyCompleteData[, 8] != 0,]

# retrieve the needed data from MyCompleteData
both = MyCompleteData[, 8:7]
species = MyCompleteData[, 1]

# make the graph
data(grid10000)
grid = grid10000
Hist2GE(coords = both, 
	species = species,
	grid = grid, 
	goo = "Mimulus", 
	nedges = 6,
	orient = 45,
	maxAlt = 1e4)
