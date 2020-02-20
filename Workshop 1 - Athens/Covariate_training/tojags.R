rm(list=ls())


setwd("C:\\Users\\admin\\Documents\\COST\\cestode")
getwd()


library(rjags)

# first run models without a covariate

system("jags script1.without.R");  system("jags script2.without.R");  system("jags script3.without.R")

# second run models with a covariate
system("jags script1.cestode.R");  system("jags script2.cestode.R"); system("jags script3.cestode.R")

