require(devtools)
install_github("ggphylo", "gjuggler")
require(ggphylo)

if (!require(devtools)) install.packages('devtools')
dev_mode(TRUE)
install_github('ggphylo', 'gjuggler')
library(ggphylo)
ggphylo(rcoal(20)) + theme_bw()



dat <- data.frame(x = 1:5, y = 1:5, p = 1:5, q = factor(1:5),
                  r = factor(1:5))
p <- ggplot(dat, aes(x, y, colour = p, size = q, shape = r)) + geom_point()

p

p + guides(colour = guide_legend("title"), size = guide_legend("title"),
           shape = guide_legend("title"))
# same as
g <- guide_legend("title")
p + guides(colour = g, size = g, shape = g)