# df <- iris
# by <- "Species"
ggfacetall <- function(df, by, x_, y_) {
  require(ggplot2)
  dat2 <- df
  dat2[,by] <- "all"
  datall <- rbind(df, dat2)
  vars <- c(x_,y_)
  
  ggplot(datall) +
    theme_bw(base_size=16) +
    geom_point(aes(x=vars[1], y=vars[2])) +
    facet_wrap(~ by) +
    opts(panel.grid.major = theme_blank(),
         panel.grid.minor=theme_blank(),
         panel.background = theme_blank()) 
}

# example
ggfacetall(iris, "Species", x_="Sepal.Width", y_="Sepal.Length")