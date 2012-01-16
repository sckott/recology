# calculate tree resolution stats
treeresstats <- function(x) {
  require(phangorn) # load the phangorn package
  require(plyr)
  todo <- ( 1+Ntip(x)) : (Ntip(x) + Nnode(x) )
  trsize <- Ntip(x)
  polytomyvec <- sapply(todo, function(y) length(Children(x, y)))
  numpolys <- length(polytomyvec[polytomyvec > 2])
  numpolysbytrsize <- numpolys/Ntip(x)
  proptipsdescpoly <- sum(polytomyvec[polytomyvec > 2])/Ntip(x)
  propnodesdich <- length(polytomyvec[polytomyvec == 2])
  list(trsize = trsize, numpolys = numpolys, numpolysbytrsize = numpolysbytrsize, 
       proptipsdescpoly = proptipsdescpoly, propnodesdich = propnodesdich)
}

tree <- read.tree(text="((((((artemisia_species:44,lactuca_species:44,senecio_species:44)6:46,campanula_species:90)5:17.75,((asclepias_species:71,galium_species:71)8:18.375,plantago_species:89.375)7:18.375)4:17.75,((cerastium_species:41.833332,silene_species:41.833332)10:41.833332,chenopodium_species:83.666664)9:41.833336)3:17.75,((geum_species:47,potentilla_species:47)12:48.125,lepidium_species:95.125)11:48.125)2:17.75,(bromus_species:12,elymus_species:12)13:149)1;")

dat <- treeresstats(tree)

dat