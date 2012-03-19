#### mvabund play
# install mvabund from CRAN pkg repository
install.packages("mvabund")
require(mvabund)

# plot abundance by copepod species 
data(Tasmania)
attach(Tasmania)
tasmvabund <- mvabund(Tasmania$copepods)
plot(tasmvabund ~ treatment, col = as.numeric(block))

# fit negative binomial model for each species and plot residuals vs. fitted
tas.nb <- manyglm(copepods ~ block*treatment, family="negative.binomial") 
plot(tas.nb)