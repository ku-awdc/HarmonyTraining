#### Code for Hui Walter model of assessing diagnostic tests

# Required package:
library('runjags')

# Things to test:
# Sensitivity to priors
# Sensitivity to parameter values (e.g. low prevalence)
# Convergence difficulties


#### A 2-test, 1-population model:

# Parameter values to simulate:
N <- 200
se1 <- 0.8
se2 <- 0.9
sp1 <- 0.99
sp2 <- 0.95
prevalence <- 0.5

# Ensure replicable data:
set.seed(2017-11-21)

# Simulate the latent state (which is unobserved in real life):
true <- rbinom(N, 1, prevalence)
# Simulate test results:
test1 <- rbinom(N, 1, se1*true + (1-sp1)*(1-true))
test2 <- rbinom(N, 1, se2*true + (1-sp2)*(1-true))
# Convert these to the test result combinations:
data <- table(test1, test2)
Tally <- as.numeric(data)

# Model code:

modelcode_2t_1p <- "model{
	
	# The observed tally for each test combination (= 2^2)
	Tally[1:4] ~ dmulti(prob[1:4], N)
	# Be careful that this vector of prob aligns with the order in Tally!!!
	
	# Probability of observing test -/-
	prob[1] <- prev * ((1-se[1])*(1-se[2]))  +  (1-prev) * (sp[1])*(sp[2])

	# Probability of observing test +/-
	prob[2] <- prev * (se[1]*(1-se[2]))  +  (1-prev) * (1-sp[1])*sp[2]
	
	# Probability of observing test -/+
	prob[3] <- prev * ((1-se[1])*(se[2]))  +  (1-prev) * (sp[1])*(1-sp[2])

	# Probability of observing test +/+
	prob[4] <- prev * (se[1]*se[2])  +  (1-prev) * (1-sp[1])*(1-sp[2])

	# Prior for prevalence - minimally informative:
	prev ~ dbeta(1,1)
	
	# Priors for diagnostic tests, weakly informative:
	se[1] ~ dbeta(2,1)
	se[2] ~ dbeta(2,1)
	sp[1] ~ dbeta(2,1)
	sp[2] ~ dbeta(2,1)
	# More prior information for these always helps
	
	#data# Tally, N
	#monitor# prev, se, sp
	#inits# prev, se, sp
}"

# Initial values:
se <- list(chain1=c(0.5, 0.99), chain2=c(0.99, 0.5))
sp <- list(chain1=c(0.5, 0.99), chain2=c(0.99, 0.5))
prev <- list(chain1=0.25, chain2=0.75)

# Run the model:
results <- run.jags(modelcode_2t_1p, n.chains=2)
# Ensure it has converged:
#plot(results)
# Look at 95% CI etc:
results
# Do we recover the simulated values??
prevalence
se1
se2
sp1
sp2
# Prevalence is not very well estimated!



#### A 2-test, multiple-population model

# Parameter values to simulate:
N <- 200
se1 <- 0.8
se2 <- 0.9
sp1 <- 0.99
sp2 <- 0.95
Populations <- 2
prevalence <- c(0.1,0.9)
Group <- rep(1:Populations, each=N)

# Ensure replicable data:
set.seed(2017-11-21)

# Simulate the latent state (which is unobserved in real life):
true <- rbinom(N*Populations, 1, prevalence[Group])
# Simulate test results:
test1 <- rbinom(N*Populations, 1, se1*true + (1-sp1)*(1-true))
test2 <- rbinom(N*Populations, 1, se2*true + (1-sp2)*(1-true))
# Convert these to the test result combinations (2x2 rows) by population (2 cols):
Tally <- matrix(nrow=4, ncol=2)
for(p in 1:Populations){
	data <- table(test1[Group==p], test2[Group==p])
	Tally[,p] <- as.numeric(data)
}

# Model code:
modelcode_2t_mp <- "model{
	
	# The observed tally for each test combination (= 2^2) and population (2)
	for(p in 1:Populations){
		Tally[1:4,p] ~ dmulti(prob[1:4,p], N)
		# Be careful that this vector of prob aligns with the order in Tally!!!
		
		# Probability of observing test -/-
		prob[1,p] <- prev[p] * ((1-se[1])*(1-se[2]))  +  (1-prev[p]) * (sp[1])*(sp[2])
	
		# Probability of observing test +/-
		prob[2,p] <- prev[p] * (se[1]*(1-se[2]))  +  (1-prev[p]) * (1-sp[1])*sp[2]
		
		# Probability of observing test -/+
		prob[3,p] <- prev[p] * ((1-se[1])*(se[2]))  +  (1-prev[p]) * (sp[1])*(1-sp[2])
	
		# Probability of observing test +/+
		prob[4,p] <- prev[p] * (se[1]*se[2])  +  (1-prev[p]) * (1-sp[1])*(1-sp[2])
	
		# Prior for prevalence - minimally informative:
		prev[p] ~ dbeta(1,1)
	}
	
	# Priors for diagnostic tests, weakly informative:
	se[1] ~ dbeta(2,1)
	se[2] ~ dbeta(2,1)
	sp[1] ~ dbeta(2,1)
	sp[2] ~ dbeta(2,1)
	# More prior information for these always helps
	
	#data# Tally, N, Populations
	#monitor# prev, se, sp
	#inits# prev, se, sp
}"

# Initial values:
se <- list(chain1=c(0.5, 0.99), chain2=c(0.99, 0.5))
sp <- list(chain1=c(0.5, 0.99), chain2=c(0.99, 0.5))
prev <- list(chain1=c(0.25,0.75), chain2=c(0.75,0.25))

# Run the model:
results <- run.jags(modelcode_2t_mp, n.chains=2)
# Ensure it has converged:
#plot(results)
# Look at 95% CI etc:
results
# Do we recover the simulated values??
prevalence
se1
se2
sp1
sp2
# Prevalence is better estimated



#### A 3-test, multiple-population model
## Health warning:  this one is complicated!

# Parameter values to simulate:
N <- 200
se1 <- 0.8
se2 <- 0.9
se3 <- 0.95
sp1 <- 0.95
sp2 <- 0.99
sp3 <- 0.95

Populations <- 2
prevalence <- c(0.25,0.75)
Group <- rep(1:Populations, each=N)

# Ensure replicable data:
set.seed(2017-11-21)

# We will assume test 1 is dependent of the others, but tests 2&3
# are not independent (e.g. they are both antibody tests)
# The probability of an antibody response given disease positive:
abse <- 0.8
# (One minus) the probability of an antibody response given disease negative:
absp <- 1 - 0.2

# Simulate the true latent state (which is unobserved in real life):
true <- rbinom(N*Populations, 1, prevalence[Group])
# Simulate test results for test 1:
test1 <- rbinom(N*Populations, 1, se1*true + (1-sp1)*(1-true))
# Tests 2&3 will be non-independent, so simulate another biological step 
# e.g. antibody response:
antibody <- rbinom(N*Populations, 1, abse*true + (1-absp)*(1-true))
# Simulate test 2&3 results based on this other latent state:
test2 <- rbinom(N*Populations, 1, se2*antibody + (1-sp2)*(1-antibody))
test3 <- rbinom(N*Populations, 1, se3*antibody + (1-sp3)*(1-antibody))
# Convert these to the test result combinations:
Tally <- matrix(nrow=8, ncol=2)
for(p in 1:Populations){
	data <- table(test1[Group==p], test2[Group==p], test3[Group==p])
	Tally[1:8,p] <- as.numeric(data)
}



#### Code for a 3-test, multiple-population model with correlations between tests:
modelcode_3t_mp <- "model{
	
	for(p in 1:Populations){

		# The observed tally for each test combination (= 2^3)
		Tally[1:8,p] ~ dmulti(prob[1:8,p], N)
		# Be careful that this vector of prob aligns with the order in Tally!!!
		
		# The covse and covsp may result in probabilities going over 1 (or below 0)
		# so we need to constrain all 8 sets of 2 probabilities to within 0, 1 and
		# sum to get the total probability:
		for(r in 1:8){
			prob[r,p] <- max(min(se_prob[r,p], 1), 0) + max(min(sp_prob[r,p], 1), 0)
		}
		
		# Probability of observing test -/-/- from a positive animal:
		se_prob[1,p] <- prev[p] * ((1-se[1])*(1-se[2])*(1-se[3]) +covse12 +covse13 +covse23)
		# Probability of observing test -/-/- from a negative animal:
		sp_prob[1,p] <- (1-prev[p]) * (sp[1]*sp[2]*sp[3] +covsp12 +covsp13 +covsp23)
			
		# Probability of observing test +/-/- from a positive animal:
		se_prob[2,p] <- prev[p] * (se[1]*(1-se[2])*(1-se[3]) -covse12 -covse13 +covse23)
		# Probability of observing test +/-/- from a negative animal:
		sp_prob[2,p] <- (1-prev[p]) * ((1-sp[1])*sp[2]*sp[3] -covsp12 -covsp13 +covsp23)
	
		# Probability of observing test -/+/- from a positive animal:
		se_prob[3,p] <- prev[p] * ((1-se[1])*se[2]*(1-se[3]) -covse12 +covse13 -covse23)
		# Probability of observing test -/+/- from a negative animal:
		sp_prob[3,p] <- (1-prev[p]) * (sp[1]*(1-sp[2])*sp[3] -covsp12 +covsp13 -covsp23)

		# Probability of observing test +/+/- from a positive animal:
		se_prob[4,p] <- prev[p] * (se[1]*se[2]*(1-se[3]) +covse12 -covse13 -covse23)
		# Probability of observing test +/+/- from a negative animal:
		sp_prob[4,p] <- (1-prev[p]) * ((1-sp[1])*(1-sp[2])*sp[3] +covsp12 -covsp13 -covsp23)
		
		# Probability of observing test -/-/+ from a positive animal:
		se_prob[5,p] <- prev[p] * ((1-se[1])*(1-se[2])*se[3] +covse12 -covse13 -covse23)
		# Probability of observing test -/-/+ from a negative animal:
		sp_prob[5,p] <- (1-prev[p]) * (sp[1]*sp[2]*(1-sp[3]) +covsp12 -covsp13 -covsp23)	
					
		# Probability of observing test +/-/+ from a positive animal:
		se_prob[6,p] <- prev[p] * (se[1]*(1-se[2])*se[3] -covse12 +covse13 -covse23)
		# Probability of observing test +/-/+ from a negative animal:
		sp_prob[6,p] <- (1-prev[p]) * ((1-sp[1])*sp[2]*(1-sp[3]) -covsp12 +covsp13 -covsp23)

		# Probability of observing test -/+/+ from a positive animal:
		se_prob[7,p] <- prev[p] * ((1-se[1])*se[2]*se[3] -covse12 -covse13 +covse23)
		# Probability of observing test -/+/+ from a negative animal:
		sp_prob[7,p] <- (1-prev[p]) * (sp[1]*(1-sp[2])*(1-sp[3]) -covsp12 -covsp13 +covsp23)

		# Probability of observing test +/+/+ from a positive animal:
		se_prob[8,p] <- prev[p] * (se[1]*se[2]*se[3] +covse12 +covse13 +covse23)
		# Probability of observing test +/+/+ from a negative animal:
		sp_prob[8,p] <- (1-prev[p]) * ((1-sp[1])*(1-sp[2])*(1-sp[3]) +covsp12 +covsp13 +covsp23)

		# Prior for prevalence - minimally informative:
		prev[p] ~ dbeta(1, 1)

	}
	
	
	# Priors for diagnostic tests - moderately informative to reduce the weight near zero:
	se[1] ~ dbeta(5,1)
	se[2] ~ dbeta(5,1)
	se[3] ~ dbeta(5,1)
	sp[1] ~ dbeta(10,1)
	sp[2] ~ dbeta(10,1)
	sp[3] ~ dbeta(10,1)
	# More prior information for these always helps
	
	# Priors on all possible covariances, but we fix some to 0:
	covse12 <- 0
	covse13 <- 0
	covse23 ~ dunif(-1,1)
	covsp12 <- 0
	covsp13 <- 0
	covsp23 ~ dunif(-1,1)

	#data# Tally, N, Populations
	#monitor# prev, se, sp, covse23, covsp23
	#inits# prev, se, sp, covse23, covsp23
	
}"

# Initial values:
se <- list(chain1=c(0.5, 0.75, 0.99), chain2=c(0.75, 0.99, 0.5), chain3=c(0.99, 0.5, 0.75))
sp <- list(chain1=c(0.5, 0.75, 0.99), chain2=c(0.75, 0.99, 0.5), chain3=c(0.99, 0.5, 0.75))
prev <- list(chain1=c(0.25,0.75), chain2=c(0.75,0.25), chain3=c(0.5,0.5))
covse23 <- list(chain1=-0.1, chain2=0, chain3=0.1)
covsp23 <- list(chain1=-0.1, chain2=0, chain3=0.1)

# Run the model:
results <- run.jags(modelcode_3t_mp, n.chains=3)

# Ensure it has converged:
plot(results)
# Look at 95% CI etc:
results

# Do we recover the simulated values??
prevalence
se1
# The overall sensitivity of the correlated tests is effectively this:
abse*se2 + (1-abse)*(1-sp2)
abse*se3 + (1-abse)*(1-sp3)
sp1
# The overall specificity of the correlated tests is effectively this:
absp*sp2 + (1-absp)*(1-se2)
absp*sp3 + (1-absp)*(1-se3)
# Notice also the positive correlation terms
