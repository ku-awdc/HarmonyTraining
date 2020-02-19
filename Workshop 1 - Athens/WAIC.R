# A function to return the WAIC
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

library('runjags')
library('rjags')

# For reproducibility:
set.seed(2016-10-03)

# A simple example:

m1 <- 'model{

	for(r in 1:R){
		for(c in 1:C){
		
			Obs[r,c] ~ dpois(lambda[r])
			
			# These are required to monitor the variance of the log likelihood:
			log_lik[r,c] <- logdensity.pois(Obs[r,c], lambda[r])
			# And the mean of the likelihood:
			lik[r,c] <- exp(log_lik[r,c])
			
		}
		
		# Model 1 has lambda as fixed:
		lambda[r] <- mean
	}
	
	# Priors
	mean ~ dmouch(1)
	shape ~ dmouch(1)
	# The dmouch distribution is implemented in runjags - see https://www.jstatsoft.org/article/view/v071i09

	#monitor# mean, shape
	#data# R, C, Obs
}'
m2 <- 'model{

	for(r in 1:R){
		for(c in 1:C){
		
			Obs[r,c] ~ dpois(lambda[r])
			
			# These are required to monitor the variance of the log likelihood:
			log_lik[r,c] <- logdensity.pois(Obs[r,c], lambda[r])
			# And the mean of the likelihood:
			lik[r,c] <- exp(log_lik[r,c])
			
		}
		
		# Model 2 has lambda as varying according to a Gamma distribution:
		lambda[r] ~ dgamma(shape, shape/mean)
	}
	
	# Priors
	mean ~ dmouch(1)
	shape ~ dmouch(1)
	# The dmouch distribution is implemented in runjags - see https://www.jstatsoft.org/article/view/v071i09

	#monitor# mean, shape
	#data# R, C, Obs
}'

R <- 20
C <- 10

# Simulate data as gamma-Poisson:
lambda <- rgamma(R, 1, rate=1/10)
Obs <- rpois(R*C, lambda)
dim(Obs) <- c(R,C)

# Fit model 1:
results <- run.jags(m1, n.chains=2)
# Check convergence etc:
results
plot(results)
# Extend the model using rjags to get mean and variance monitors:
# (this won't be necessary when runjags is updated)
meanl <- jags.samples(as.jags(results), 'lik', type='mean', 10000)
varll <- jags.samples(as.jags(results), 'log_lik', type='variance', 10000)
mean_lik <- apply(meanl[[1]],c(1,2),mean)
var_loglik <- apply(varll[[1]],c(1,2),mean)
waic1 <- get_waic(mean_lik, var_loglik)

# Fit model 2:
results <- run.jags(m2, n.chains=2)
# Check convergence etc:
results
plot(results)
# Extend the model using rjags to get mean and variance monitors:
# (this won't be necessary when runjags is updated)
meanl <- jags.samples(as.jags(results), 'lik', type='mean', 10000)
varll <- jags.samples(as.jags(results), 'log_lik', type='variance', 10000)
mean_lik <- apply(meanl[[1]],c(1,2),mean)
var_loglik <- apply(varll[[1]],c(1,2),mean)
waic2 <- get_waic(mean_lik, var_loglik)

waic1$waic
waic1$p_waic
waic2$waic
waic2$p_waic
# Model 2 has a much better WAIC



# Now resimulate using a fixed lambda:
lambda <- 10
Obs <- rpois(R*C, lambda)
dim(Obs) <- c(R,C)

# Fit model 1:
results <- run.jags(m1, n.chains=2)
# Check convergence etc:
results
plot(results)
# Extend the model using rjags to get mean and variance monitors:
# (this won't be necessary when runjags is updated)
meanl <- jags.samples(as.jags(results), 'lik', type='mean', 10000)
varll <- jags.samples(as.jags(results), 'log_lik', type='variance', 10000)
mean_lik <- apply(meanl[[1]],c(1,2),mean)
var_loglik <- apply(varll[[1]],c(1,2),mean)
waic1 <- get_waic(mean_lik, var_loglik)

# Fit model 2:
results <- run.jags(m2, n.chains=2)
# Check convergence etc:
results
plot(results)
# Extend the model using rjags to get mean and variance monitors:
# (this won't be necessary when runjags is updated)
meanl <- jags.samples(as.jags(results), 'lik', type='mean', 10000)
varll <- jags.samples(as.jags(results), 'log_lik', type='variance', 10000)
mean_lik <- apply(meanl[[1]],c(1,2),mean)
var_loglik <- apply(varll[[1]],c(1,2),mean)
waic2 <- get_waic(mean_lik, var_loglik)

waic1$waic
waic1$p_waic
waic2$waic
waic2$p_waic
# Now model 1 has the better WAIC as expected (and far fewer parameters)

