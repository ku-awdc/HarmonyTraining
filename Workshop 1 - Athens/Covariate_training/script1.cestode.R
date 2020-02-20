model in model.cestode.bug
data in data_emidfin.R
load dic      
compile, nchains(1)
parameters in inits1.R, chain(1)
initialize
update 5000, by(1000)
monitor prc, thin(10)
monitor c1, thin(10)
monitor c2, thin(10)
monitor c3, thin(10)
monitor s1, thin(10)
monitor s2, thin(10)
monitor s3, thin(10)
monitor deviance, thin(10)
monitor covs12, thin(10)
monitor covs13, thin(10)
monitor covs23, thin(10)
monitor covc12, thin(10)
monitor covc13, thin(10)
monitor covc23, thin(10)
monitor slope, thin(10)
monitor intercept, thin(10)    
update 20000, by(1000)
coda *, stem("model1.cestode")
 
