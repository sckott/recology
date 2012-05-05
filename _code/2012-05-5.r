# Store a function with man lines
# Go Here: http://beta.opencpu.org/apps/opencpu.demo/storefunction/
# number: x3e50ee0780
# link: http://beta.opencpu.org/R/call/store:tmp/x3e50ee0780/png?id='ropensci'&type='org'
the <- function (id = 'hadley', type = 'user') 
{
  require(RCurl); require(RJSONIO); require(ggplot2); require(reshape2); require(plyr)
  if(type == 'user'){ url = "https://api.github.com/users/" } else
    if(type == 'org'){ url = "https://api.github.com/orgs/" } else
      stop("parameter 'type' has to be either 'user' or 'org' ")
  url2 <- paste(url, id, "/repos?per_page=100", sep = "")
  xx <- getURL(url2)
  tt <- fromJSON(xx)
  if(!length(tt) == 1) { tt <- tt } else
    { stop("user or organization not found - search GitHub? - https://github.com/") }   
  out <- ldply(tt, function(x) t(c(x$name, x$forks, x$watchers)))
  names(out) <- c("Repo", "Forks", "Watchers")
  out$Forks <- as.integer(out$Forks)
  out$Watchers <- as.integer(out$Watcher)
  out2 <- melt(out, id = 1)
  out2$value <- as.numeric(out2$value)
  out2$Repo <- as.factor(out2$Repo)
  repoorder <- unique(out2[order(out2$value, decreasing=FALSE),][,1])
  out2$Repo <- factor(out2$Repo, levels = repoorder)
  ggplot(out2, aes(Repo, value)) + geom_bar() + coord_flip() + 
    facet_wrap(~variable) + theme_bw(base_size = 18)
}
the() # default for hadley
the(id='defunkt', type='user') # works - a user with even more repos than Hadley
the(id='ropensci', type='org') # works - organization example
the(id='jeroenooms', type='user') # works - organization example
the(id='SChamberlain', type='org') # error message - mismatch of username with org type
the(id='adsff', type='user') # error message - name does not exist