## This is an example of extracting WAIC from runjags/jags objects
# Matt Denwood, 2019-11-11
# Note that this will all get much easier with the release of JAGS 5 and the next verison of runjags!!

## A function to return the WAIC
# Also returns the effective number of parameters (p_waic), elpd and lpd as described by:
# www.stat.columbia.edu/~gelman/research/unpublished/waic_stan.pdf
# Note:  	mean_lik is the log of the (exponentiated) likelihoods
#			var_log_lik is the variance of the log likelihoods
#			these need separate monitors in JAGS
get_waic <- function(mean_lik, var_log_lik){
	
	stopifnot(length(mean_lik)==length(var_log_lik))
	stopifnot(all(mean_lik > 0))
	N <- length(mean_lik)
	
	lpd <- log(mean_lik)
	elpd <- lpd - var_log_lik
	waic <- -2 * elpd
	se <- (var(waic) / N)^0.5
	
	return(list(waic=-2*sum(elpd), p_waic=sum(var_log_lik), elpd=sum(elpd), lpd=sum(lpd), se_waic=se, pointwise=cbind(waic=waic, elpd=elpd, lpd=lpd)))
}


## An example based on Andrew Gelman's 8 schools data, to match that used in the Vehtari and Gelman (2014) paper

# Data as used by Gelman:
schools <-
structure(list(school = structure(1:8, .Label = c("A", "B", "C",
"D", "E", "F", "G", "H"), class = "factor"), estimate = c(28L,
8L, -3L, 7L, -1L, 1L, 18L, 12L), sd = c(15L, 10L, 16L, 11L, 9L,
11L, 10L, 18L)), .Names = c("school", "estimate", "sd"), class = "data.frame", row.names = c(NA,
-8L))

# Model definition:
model <- "
model {
	for (j in 1:J){  						# J = the number of schools 
		y[j] ~ dnorm (theta[j], tau.y[j])	# data model: the likelihood
		theta[j] <- mu.theta + eta[j]
		tau.y[j] <- pow(sigma.y[j], -2)
		
		# These are required to monitor the variance of the log likelihood:
		log_lik[j] <- logdensity.norm(y[j], theta[j], tau.y[j])
		# And the mean of the likelihood:
		lik[j] <- exp(log_lik[j])
	}
	for (j in 1:J){
		eta[j] ~ dnorm (0, tau.theta)
	}
	tau.theta <- pow(sigma.theta, -2)
	sigma.theta ~ dhalfcauchy(prior.scale)  # The dhalfcauchy distribution is also implemented in runjags
	mu.theta ~ dnorm (0.0, 1.0E-6)			# noninformative prior on mu
	#data# J, y, sigma.y, prior.scale
	#monitor# theta, mu.theta, sigma.theta
}"


## Run the model:
library('runjags')
library('rjags')

# Calculate the data:
J <- nrow(schools)
y <- schools$estimate
sigma.y <- schools$sd
prior.scale <- 25

# Initial run for main parameter monitoring:
results <- run.jags(model, sample=10000)
# Second run for WAIC monitors:
ll <- jags.samples(as.jags(results), c('lik', 'log_lik'), type=c('mean','variance'), 10000)
# Calculate the WAIC statistic and effective parameters etc:
get_waic(as.mcmc(ll$mean$lik)[,1], as.mcmc(ll$variance$log_lik)[,1])


## Comparison of figure 2 in Vehtari and Gelman 2014 paper

# In the Vehtari and Gelman 2014 paper they try scaling the data to show the effect:
N <- 20
data_scale <- seq(0.1,5,length=N)
params=elpd <- numeric(N)
for(i in 1:N){

	J <- nrow(schools)
	y <- schools$estimate * data_scale[i]
	sigma.y <- schools$sd
	prior.scale <- 25
	
	results <- run.jags(model, sample=10000)
	ll <- jags.samples(as.jags(results), c('lik', 'log_lik'), type=c('mean','variance'), 10000)
	w <- get_waic(as.mcmc(ll$mean$lik)[,1], as.mcmc(ll$variance$log_lik)[,1])
	
	params[i] <- w$p_waic
	elpd[i] <- w$elpd
	
}

par(mfrow=c(1,2))
plot(data_scale, elpd, type='l', ylim=c(-45, -28))
plot(data_scale, params, type='l', ylim=c(0,14))
# CF figure 2 of Vehtari and Gelman 2014
