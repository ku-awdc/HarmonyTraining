# packages and data -------------------------------------------------------
library(HSROC)
library(MCMCpack)
library(mada)

prj.dir <- "/Users/paoloeusebi/Desktop/Lavoro/Harmony/Athens2020/DTA Meta-analysis"

data("MRI")
MRI

MRI2 <- MRI # data for mada package
names(MRI2)[1] <- "TP"
names(MRI2)[2] <- "FP"
names(MRI2)[3] <- "FN"
names(MRI2)[4] <- "TN"

madad(MRI2)

# Forest plot
forest(madad(MRI2),
       type = "sens",
       main = "Sensitivity")

forest(madad(MRI2),
       type = "spec",
       main = "Specificity")

# Data on ROC space
ROCellipse(MRI2, pch = "")
points(fpr(MRI2), sens(MRI2))


# Meta-Analysis with a gold standard reference test -----------------------

# Biviariate Analysis (mada R package) ------------------------------------
fit.reitsma <- reitsma(MRI2)
summary(fit.reitsma)
plot(fit.reitsma, cex=2,
     sroclwd = 2, plotsumm = T,predict = T,pch = 19,
     main = "SROC curve (bivariate model) for MRI data")
points(fpr(MRI2),
       sens(MRI2), pch = 1)
legend("bottomright", c("data points", "summary estimate", "SROC", "95% conf. region", "95% pred.region"),
       pch = c(1, 19, NA, NA, NA),
       lwd = c(NA, 2, 2, 1, 1), lty = c(NA, NA, 1,1,3), bty = "n")

# Hierarchical Summary ROC (HSROC R package) ------------------------------
# Assuming perfect reference test

# Within study parameters
init.alpha = c(2.51, 2.54, 3.81, 2.41, 2.64, 2.70, 3.31, 3.39, 3.11, 2.99)
init.theta = c(-0.51, -0.39, 0.33, -2.06, -0.14, -0.08, 1.11, 0.38, -0.86, -0.38)
init.s1 = rep(0.9,10)
init.c1 = rep(0.9,10)
init.pi = c(0.38, 0.17, 0.78, 0.07, 0.74, 0.84, 0.52, 0.95, 0.07, 0.56)

init_within = cbind(init.alpha, init.theta, init.s1, init.c1, init.pi)

# Between study parameters
init.THETA = -0.16
init.sig.theta = 0.75
init.LAMBDA = 2.58
init.sig.alpha = 0.5
init.beta = 0.25

init_between = c(init.THETA, init.sig.theta, init.LAMBDA, init.sig.alpha, init.beta)

init = list(init_within, init_between)

## Running the Gibbs sampler
HSROC(data = MRI, iter.num = 5000, init = init)

a <- HSROCSummary(data = MRI, burn_in = 1000, Thin = 2, print_plot = T)
a[[1]]; a[[2]]; a[[3]]


# Multiple chains to assess convergence
dir.chain1 <- file.path(prj.dir, "Chain1")
dir.create(dir.chain1)
setwd(dir.chain1)
init1 = list(init_within, init_between)
HSROC(data = MRI, iter.num = 5000, init = init1, path = dir.chain1)
a1 <- HSROCSummary(data = MRI, burn_in = 1000, Thin = 2, print_plot = T)
a1[[1]]; a1[[2]]; a1[[3]]

dir.chain2 <- file.path(prj.dir, "Chain2")
dir.create(dir.chain2)
setwd(dir.chain2)
init2 = list(init_within, init_between)
HSROC(data = MRI, iter.num = 5000, init = init, path = dir.chain2)
a2 <- HSROCSummary(data = MRI, burn_in = 1000, Thin = 2, print_plot = T)
a2[[1]]; a2[[2]]; a2[[3]]

dir.chain3 <- file.path(prj.dir, "Chain3")
dir.create(dir.chain3)
setwd(dir.chain3)
init3 = list(init_within, init_between)
HSROC(data = MRI, iter.num = 5000, init = init, path = dir.chain3)
a3 <- HSROCSummary(data = MRI, burn_in = 1000, Thin = 2, print_plot = T)
a3[[1]]; a3[[2]]; a3[[3]]

# Once all 3 chains have reached the desired number of iterations, a single call to
# the function HSROCSummary will summarize all 3 chains.

dir.all.chains <- file.path(prj.dir, "All_Chains")
dir.create(dir.all.chains)
setwd(dir.all.chains)
all.chains.fit <- HSROCSummary(data = MRI,
                               burn_in = 1000,
                               Thin = 2,
                               print_plot = T,
                               chain = list(dir.chain1,
                                            dir.chain2,
                                            dir.chain3))


# Meta-Analysis with imperfect reference test -----------------------------

REFSTD = list(1, 1:7)
brd = data.frame(TP = c(49, 37, 265, 121, 195, 157, 127),
                 FP = c(53, 1, 196, 42, 60, 29, 157),
                 FN = c(38, 90, 606, 910, 1395, 1344, 4591),
                 TN = c(64, 18, 969, 592, 373, 806, 8316))
M = dim(brd)[1]

names(brd)[1] = "++"
names(brd)[2] = "+-"
names(brd)[3] = "-+"
names(brd)[4] = "--"
brd
#Initial values for the within-study parameters
init.alpha = rep(2.5, M) ;	init.theta = rep(1, M) ;
init.s1 =  rep(0.5, M) ;	init.c1 = rep(0.5, M) ;
init.pi = rep(0.5, M)

#Initial values for the between-study parameters
init.THETA = -1.3
init.sd.theta = 0.5
init.LAMBDA = 3.4
init.sd.alpha = 0.5
init.beta = 0

#Initial values for the reference standard sensitivities and specificities
init.s2 = rep(0.75, REFSTD[[1]]) ;	init.c2 = rep(0.75, REFSTD[[1]])

#The ordering of the initial values is important!
init1 = cbind(init.alpha, init.theta, init.s1, init.c1, init.pi)
init2 = c(init.THETA, init.sd.theta, init.LAMBDA, init.sd.alpha, init.beta)
init3 = rbind(init.s2, init.c2)

init = list(init1, init2, init3)

# prior information on sensitivity and specificity of reference test
S2.a = c(0.6) ; 	S2.b = c(0.85) # sensitivity
C2.a = rep(0.8) ;	C2.b = rep(0.95) # specificity

# No prior information on reference test accuracy
set.seed(123)
HSROC(data = brd,
      init = init,
      iter.num = 5000,
      sub_rs = REFSTD) 

brd.fit <- HSROCSummary(data = brd,
                        burn_in = 1000,
                        Thin = 2, print_plot = T)

brd.fit[[1]]; brd.fit[[2]]; brd.fit[[3]]

# Putting prior information on reference test accuracy
set.seed(123)
HSROC(data = brd,
      init = init, iter.num = 50000,  
      prior.SEref = c(S2.a, S2.b), prior.SPref = c(C2.a,C2.b),
      sub_rs = REFSTD) 

brd.fit <- HSROCSummary(data = brd,
                        burn_in = 1000,
                        Thin = 2, print_plot = T)

brd.fit[[1]]; brd.fit[[2]]; brd.fit[[3]]

# Meta-Analysis with multiple imperfect reference test --------------------
# Data simulations
library(HSROC)
#We want to simulate data for 15 studies based on an HSROC model such that
#the first 5 studies share a common reference standard and the remaining
#10 studies also share a common reference standard.
N = 15
LAMBDA = 3.6
sd_alpha = 1.15
THETA = 2.3
sd_theta = 0.75
beta = 0.15
pi = runif(15,0.1,0.5)
REFSTD = list(2, 1:5, 6:15) #Two different reference standards ...
s2 = c(0.40, 0.6) #Sensitivity of the reference tests
c2 = c(0.75,0.95) #Specificity of the reference tests


#Thus, for the first 5 studies, S2 = 0.40 and C2 = 0.75 while for the last
#10 studies s2 = 0.6 and c2 = 0.95
sim.data = simdata(N = N, n = seq(30, 120, 1),
                   n.random = T, sub_rs = REFSTD,
                   prev = pi, se_ref = s2, sp_ref = c2, T = THETA, L = LAMBDA, sd_t = sd_theta,
                   sd_a = sd_alpha, b = beta)
dir.imp.ref.sim <- file.path(prj.dir, "Imp_Ref_Sim")
dir.create(dir.imp.ref.sim)
setwd(dir.imp.ref.sim)
HSROC(data=sim.data$Data, iter.num = 5000,
      #prior.SEref=c(S2.a,S2.b), prior.SPref=c (C2.a,C2.b),
      sub_rs=REFSTD)
