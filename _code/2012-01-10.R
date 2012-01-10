# Define the function
loghistplot  <- function(data) {
  
  require(ggplot2); require(gridExtra) # load packages

  names(data) <- c('x','y') # rename columns

  # get min and max axis values
  min_x <- min(data$x)
  max_x <- max(data$x)
  min_y <- min(data$y)
  max_y <- max(data$y)
  
  # get bin numbers
  bin_no <- max(hist(data$x)$counts) + 5

  # create plots
  a <- ggplot(data, aes(x = x, y = y)) +
    theme_bw(base_size=16) +
    geom_smooth(method = "glm", family = "binomial", se = TRUE,
                colour='black', size=1.5, alpha = 0.3) +
    #     scale_y_continuous(limits=c(0,1), breaks=c(0,1)) +
    scale_x_continuous(limits=c(min_x,max_x)) +
    opts(panel.grid.major = theme_blank(),
         panel.grid.minor=theme_blank(),
         panel.background = theme_blank()) +
    labs(y = "Probability\n", x = "\nYour X Variable")
  
  b <- ggplot(data[data$y == unique(data$y)[1], ], aes(x = x)) +
    theme_bw(base_size=16) +
    geom_histogram(fill = "grey") +
    scale_y_continuous(limits=c(0,bin_no)) +
    scale_x_continuous(limits=c(min_x,max_x)) +
    opts(panel.grid.major = theme_blank(),
         panel.grid.minor=theme_blank(),
         axis.text.y = theme_blank(),
         axis.text.x = theme_blank(),
         axis.ticks = theme_blank(),
         panel.border = theme_blank(),
         panel.background = theme_blank()) +
    labs(y='\n', x='\n')
  
  c <- ggplot(data[data$y == unique(data$y)[2], ], aes(x = x)) +
    theme_bw(base_size=16) +
    geom_histogram(fill = "grey") +
    scale_y_continuous(trans='reverse') +
    scale_y_continuous(trans='reverse', limits=c(bin_no,0)) +
    scale_x_continuous(limits=c(min_x,max_x)) +
    opts(panel.grid.major = theme_blank(),panel.grid.minor=theme_blank(),
         axis.text.y = theme_blank(), axis.text.x = theme_blank(),
         axis.ticks = theme_blank(),
         panel.border = theme_blank(),
         panel.background = theme_blank()) +
    labs(y='\n', x='\n')
  
  grid.newpage()
  pushViewport(viewport(layout = grid.layout(1,1)))
  
  vpa_ <- viewport(width = 1, height = 1, x = 0.5, y = 0.5)
  vpb_ <- viewport(width = 1, height = 1, x = 0.5, y = 0.5)
  vpc_ <- viewport(width = 1, height = 1, x = 0.5, y = 0.5)
  
  print(b, vp = vpb_)
  print(c, vp = vpc_)
  print(a, vp = vpa_)
}

# Examples
# loghistplot(mtcars[,c("mpg","vs")])
# loghistplot(movies[,c("rating","Action")])