

*********

So I want to mine some #altmetrics data for some research I'm thinking about doing.  The steps would be: 

+ Get journal titles for ecology and evolution journals. 
+ Get DOI's for all papers in all the above journal titles. 
+ Get altmetrics data on each DOI. 
+ Do some fancy analyses. 
+ Make som pretty figs. 
+ Write up results. 

It's early days, so jus working on the first step.  However, getting a list of journals in ecology and evolution is frustratingly hard.  This turns out to not be that easy if you are (1) trying to avoid [Thomson Reuters](http://thomsonreuters.com/), and (2) want a machine interface way to do it (read: API). 

Unfortunately, Mendeley's API does not have methods for getting a list of journals by field, or at least I don't know how to do it using [their API](http://apidocs.mendeley.com/).  No worries though - [Crossref](http://crossref.org/) comes to save the day.   Here's my attempt at this using the [Crossref OAI-PMH](http://help.crossref.org/#using_oai_pmh).

*********

### I wrote a little while loop to get journal titles from the Crossref OAI-PMH. This takes a while to run, but at least it works on my machine - hopefully yours too!

```r
library(XML)
library(RCurl)

token <- "characters"  # define a iterator, also used for gettingn the resumptionToken
nameslist <- list()  # define empty list to put joural titles in to
while (is.character(token) == TRUE) {
    baseurl <- "http://oai.crossref.org/OAIHandler?verb=ListSets"
    if (token == "characters") {
        tok2 <- NULL
    } else {
        tok2 <- paste("&resumptionToken=", token, sep = "")
    }
    query <- paste(baseurl, tok2, sep = "")
    crsets <- xmlToList(xmlParse(getURL(query)))
    names <- as.character(sapply(crsets[[4]], function(x) x[["setName"]]))
    nameslist[[token]] <- names
    if (class(try(crsets[[2]]$.attrs[["resumptionToken"]])) == "try-error") {
        stop("no more data")
    } else token <- crsets[[2]]$.attrs[["resumptionToken"]]
}
```

```
Error: no more data
```


*********

### Yay!  Hopefully it worked if you tried it.  Let's see how long the list of journal titles is. 

```r
sapply(nameslist, length)  # length of each list
```

```
                          characters b4f012b9-16ea-4d4c-8922-8e5f7430678d 
                               10001                                10001 
c10e9a72-46db-4e9c-950e-09bd9aeb09a1 
                                6864 
```

```r
allnames <- do.call(c, nameslist)  # combine to list
length(allnames)
```

```
[1] 26866
```


*********


### Now, let's use some `regex` to pull out the journal titles that are likely ecology and evolutionary biology journals.  The `^` symbol says "the string must start here". The `\\s` means whitespace.  The `[]` lets you specify a set of letters you are looking for, e.g., `[Ee]` means capital `E` *OR* lowercase `e`.  I threw in titles that had the words systematic and natrualist too.  Tried to trim any whitespace as well using the `stringr` package. 

```r
library(stringr)

ecotitles <- as.character(allnames[str_detect(allnames, "^[Ee]cology|\\s[Ee]cology")])
evotitles <- as.character(allnames[str_detect(allnames, "^[Ee]volution|\\s[Ee]volution")])
systtitles <- as.character(allnames[str_detect(allnames, "^[Ss]ystematic|\\s[Ss]systematic")])
naturalist <- as.character(allnames[str_detect(allnames, "[Nn]aturalist")])

ecoevotitles <- unique(c(ecotitles, evotitles, systtitles, naturalist))  # combine to list
ecoevotitles <- str_trim(ecoevotitles, side = "both")  # trim whitespace, if any
sort(ecoevotitles)
```

```
  [1] "African Journal of Ecology"                                                                            
  [2] "Animal Systematics Evolution and Diversity"                                                            
  [3] "Annual Review of Ecology Evolution and Systematics"                                                    
  [4] "Annual Review of Ecology and Systematics"                                                              
  [5] "Applied Soil Ecology"                                                                                  
  [6] "Aquatic Ecology"                                                                                       
  [7] "Aquatic Microbial Ecology"                                                                             
  [8] "Austral Ecology"                                                                                       
  [9] "Australian Journal of Ecology"                                                                         
 [10] "Avian Conservation and Ecology"                                                                        
 [11] "BMC Ecology"                                                                                           
 [12] "BMC Evolutionary Biology"                                                                              
 [13] "Basic and Applied Ecology"                                                                             
 [14] "Behavioral Ecology"                                                                                    
 [15] "Behavioral Ecology and Sociobiology"                                                                   
 [16] "Biochemical Systematics and Ecology"                                                                   
 [17] "Blumea - Biodiversity Evolution and Biogeography of Plants"                                            
 [18] "Brain Behavior and Evolution"                                                                          
 [19] "Bulletin of Japanese Society of Microbial Ecology"                                                     
 [20] "Bulletion of the International Association for Landscape Ecology-Japan"                                
 [21] "Chemistry and Ecology"                                                                                 
 [22] "Chinese Journal of Plant Ecology"                                                                      
 [23] "Community Ecology"                                                                                     
 [24] "Contemporary Problems of Ecology"                                                                      
 [25] "Development Genes and Evolution"                                                                       
 [26] "Ecology"                                                                                               
 [27] "Ecology Letters"                                                                                       
 [28] "Ecology Of Freshwater Fish"                                                                            
 [29] "Ecology and Civil Engineering"                                                                         
 [30] "Ecology and Evolution"                                                                                 
 [31] "Ecology and Society"                                                                                   
 [32] "Ecology of Food and Nutrition"                                                                         
 [33] "Ecoprint An International Journal of Ecology"                                                          
 [34] "Estonian Journal of Ecology"                                                                           
 [35] "Ethology Ecology & Evolution"                                                                          
 [36] "Evolution"                                                                                             
 [37] "Evolution & Development"                                                                               
 [38] "Evolution Education and Outreach"                                                                      
 [39] "Evolution Equations and Control Theory"                                                                
 [40] "Evolution and Human Behavior"                                                                          
 [41] "Evolution of Communication"                                                                            
 [42] "Evolutionary Anthropology Issues News and Reviews"                                                     
 [43] "Evolutionary Applications"                                                                             
 [44] "Evolutionary Bioinformatics"                                                                           
 [45] "Evolutionary Biology"                                                                                  
 [46] "Evolutionary Computation"                                                                              
 [47] "Evolutionary Ecology"                                                                                  
 [48] "Evolutionary Intelligence"                                                                             
 [49] "Explorations in Media Ecology"                                                                         
 [50] "FEMS Microbiology Ecology"                                                                             
 [51] "Fire Ecology"                                                                                          
 [52] "Fisheries Management and Ecology"                                                                      
 [53] "Flora - Morphology Distribution Functional Ecology of Plants"                                          
 [54] "Forest Ecology and Management"                                                                         
 [55] "Frontiers in Ecology and the Environment"                                                              
 [56] "Frontiers in Evolutionary Neuroscience"                                                                
 [57] "Functional Ecology"                                                                                    
 [58] "Fungal Ecology"                                                                                        
 [59] "Genetic Resources and Crop Evolution"                                                                  
 [60] "Genetics Selection Evolution"                                                                          
 [61] "Genome Biology and Evolution"                                                                          
 [62] "Global Ecology and Biogeography"                                                                       
 [63] "Human Ecology"                                                                                         
 [64] "Human Evolution"                                                                                       
 [65] "IEEE Transactions on Evolutionary Computation"                                                         
 [66] "ISRN Ecology"                                                                                          
 [67] "ISRN Evolutionary Biology"                                                                             
 [68] "Ideas in Ecology and Evolution"                                                                        
 [69] "Immediate Science Ecology"                                                                             
 [70] "Infection Ecology & Epidemiology"                                                                      
 [71] "Infection Genetics and Evolution"                                                                      
 [72] "Insect Systematics & Evolution"                                                                        
 [73] "International Journal of Agricultural Resources Governance and Ecology"                                
 [74] "International Journal of Applied Evolutionary Computation"                                             
 [75] "International Journal of Ecology"                                                                      
 [76] "International Journal of Molecular Ecology and Conservation"                                           
 [77] "International Journal of Molecular Evolution and Biodiversity"                                         
 [78] "International Journal of Nuclear Governance Economy and Ecology"                                       
 [79] "International Journal of Social Ecology and Sustainable Development"                                   
 [80] "International Journal of Swarm Intelligence and Evolutionary Computation"                              
 [81] "International journal of human ecology"                                                                
 [82] "Israel Journal of Ecology and Evolution"                                                               
 [83] "Japanese Journal of Health and Human Ecology"                                                          
 [84] "Journal of Animal Ecology"                                                                             
 [85] "Journal of Applied Ecology"                                                                            
 [86] "Journal of Artificial Evolution and Applications"                                                      
 [87] "Journal of Chemical Ecology"                                                                           
 [88] "Journal of Cultural and Evolutionary Psychology"                                                       
 [89] "Journal of Ecology"                                                                                    
 [90] "Journal of Ecology and Field Biology"                                                                  
 [91] "Journal of Ecology and the Natural Environment"                                                        
 [92] "Journal of Environment and Ecology"                                                                    
 [93] "Journal of Evolution Equations"                                                                        
 [94] "Journal of Evolutionary Biochemistry and Physiology"                                                   
 [95] "Journal of Evolutionary Biology"                                                                       
 [96] "Journal of Evolutionary Biology Research"                                                              
 [97] "Journal of Evolutionary Economics"                                                                     
 [98] "Journal of Evolutionary Medicine"                                                                      
 [99] "Journal of Evolutionary Psychology"                                                                    
[100] "Journal of Experimental Marine Biology and Ecology"                                                    
[101] "Journal of Experimental Zoology Part B Molecular and Developmental Evolution"                          
[102] "Journal of Family Ecology and Consumer Sciences /Tydskrif vir Gesinsekologie en Verbruikerswetenskappe"
[103] "Journal of Freshwater Ecology"                                                                         
[104] "Journal of Human Evolution"                                                                            
[105] "Journal of Industrial Ecology"                                                                         
[106] "Journal of Landscape Ecology"                                                                          
[107] "Journal of Mammalian Evolution"                                                                        
[108] "Journal of Molecular Evolution"                                                                        
[109] "Journal of Plant Ecology"                                                                              
[110] "Journal of Social and Evolutionary Systems"                                                            
[111] "Journal of Software Evolution and Process"                                                             
[112] "Journal of Software Maintenance and Evolution Research and Practice"                                   
[113] "Journal of Systematics and Evolution"                                                                  
[114] "Journal of Tropical Ecology"                                                                           
[115] "Journal of Vector Ecology"                                                                             
[116] "Journal of Wetlands Ecology"                                                                           
[117] "Journal of Zoological Systematics & Evolutionary Research"                                             
[118] "Korean Journal of Human Ecology"                                                                       
[119] "Landscape Ecology"                                                                                     
[120] "Landscape Ecology and Management"                                                                      
[121] "Le Naturaliste canadien"                                                                               
[122] "Letters on Evolutionary Behavioral Science"                                                            
[123] "Limnologica - Ecology and Management of Inland Waters"                                                 
[124] "Marine Ecology"                                                                                        
[125] "Marine Ecology Progress Series"                                                                        
[126] "Methods in Ecology and Evolution"                                                                      
[127] "Microbial Ecology"                                                                                     
[128] "Microbial Ecology in Health & Disease"                                                                 
[129] "Microbial Ecology in Health and Disease"                                                               
[130] "Molecular Biology and Evolution"                                                                       
[131] "Molecular Ecology"                                                                                     
[132] "Molecular Ecology Notes"                                                                               
[133] "Molecular Ecology Resources"                                                                           
[134] "Molecular Phylogenetics and Evolution"                                                                 
[135] "Monographs of the Western North American Naturalist"                                                   
[136] "Netherlands Journal of Aquatic Ecology"                                                                
[137] "Northeastern Naturalist"                                                                               
[138] "Northwestern Naturalist"                                                                               
[139] "Open Journal of Ecology"                                                                               
[140] "Organisms Diversity & Evolution"                                                                       
[141] "Origins of Life and Evolution of Biospheres"                                                           
[142] "Persoonia - Molecular Phylogeny and Evolution of Fungi"                                                
[143] "Perspectives in Plant Ecology Evolution and Systematics"                                               
[144] "Plant Diversity and Evolution"                                                                         
[145] "Plant Ecology"                                                                                         
[146] "Plant Ecology & Diversity"                                                                             
[147] "Plant Ecology and Evolution"                                                                           
[148] "Plant Systematics and Evolution"                                                                       
[149] "Population Ecology"                                                                                    
[150] "Progress in Industrial Ecology An International Journal"                                               
[151] "Psychology Evolution & Gender"                                                                         
[152] "Rangeland Ecology & Management"                                                                        
[153] "Research Letters in Ecology"                                                                           
[154] "Researches on Population Ecology"                                                                      
[155] "Restoration Ecology"                                                                                   
[156] "Russian Journal of Ecology"                                                                            
[157] "SRX Ecology"                                                                                           
[158] "Sexualities Evolution & Gender"                                                                        
[159] "Southeastern Naturalist"                                                                               
[160] "Swarm and Evolutionary Computation"                                                                    
[161] "Systematic Biology"                                                                                    
[162] "Systematic Botany"                                                                                     
[163] "Systematic Entomology"                                                                                 
[164] "Systematic Parasitology"                                                                               
[165] "Systematic Reviews"                                                                                    
[166] "Systematic Reviews in Pharmacy"                                                                        
[167] "Systematic Zoology"                                                                                    
[168] "Systematic and Applied Microbiology"                                                                   
[169] "Systematics and Biodiversity"                                                                          
[170] "The American Midland Naturalist"                                                                       
[171] "The American Naturalist"                                                                               
[172] "The Anatomical Record Advances in Integrative Anatomy and Evolutionary Biology"                        
[173] "The Anatomical Record Part A Discoveries in Molecular Cellular and Evolutionary Biology"               
[174] "The International Journal of Sustainable Development and World Ecology"                                
[175] "The Korean Journal of Ecology"                                                                         
[176] "The Open Ecology Journal"                                                                              
[177] "The Open Evolution Journal"                                                                            
[178] "The Southwestern Naturalist"                                                                           
[179] "Theoretical Ecology"                                                                                   
[180] "Trends in Ecology & Evolution"                                                                         
[181] "Trends in Evolutionary Biology"                                                                        
[182] "Urban Ecology"                                                                                         
[183] "West African Journal of Applied Ecology"                                                               
[184] "Western North American Naturalist"                                                                     
[185] "Wetlands Ecology and Management"                                                                       
[186] "World Futures The Journal of General Evolution"                                                        
[187] "Zoology and Ecology"                                                                                   
[188] "Zoosystematics and Evolution"                                                                          
```


*********

### If you want to take the time to learn C++ or already know it, the RcppArmadillo option would likely be the fastest, but I think (IMO) for many scientists, especially ecologists, we probably don't already know C++, so will stick to the next fastest options. 

*********

### Get the .Rmd file used to create this post [at my github account](https://github.com/SChamberlain/schamberlain.github.com/blob/master/_drafts/2012-08-30-get-ecoevo-journal-titles.Rmd).
