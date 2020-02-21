# packages and data -------------------------------------------------------
library(HSROC)
library(MCMCpack)
library(mada)

# Please create one folder and setup as your home directory  
prj.dir <- "/Users/paoloeusebi/Desktop/Lavoro/Harmony/Athens2020/AdvTraining6"

list.files(prj.dir)

# Import MRI data from HSROC package
data("MRI")
MRI

# manipulate for mada R package
MRI2 <- MRI 
names(MRI2) = c("TP", "FP", "FN", "TN")
madad(MRI2)

# Forest plot (mada R package)
forest(madad(MRI2),
       type = "sens",
       main = "Sensitivity")

forest(madad(MRI2),
       type = "spec",
       main = "Specificity")

# Data on ROC space (mada R package)
ROCellipse(MRI2, pch = "")
points(fpr(MRI2), sens(MRI2))


# Meta-Analysis with a gold standard reference test -----------------------

# Biviariate Analysis (mada R package) ------------------------------------
fit.reitsma <- reitsma(MRI2)
summary(fit.reitsma)
plot(fit.reitsma, cex = 2,
     sroclwd = 2, plotsumm = T,predict = T,pch = 19,
     main = "Bivariate analysis of MRI data")
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
init.s1 = rep(0.5,10)
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

# Create directory for storing results
dir.perfect <- file.path(prj.dir, "Perfect_One_Chain")
dir.create(dir.perfect)
setwd(dir.perfect)

## Running the Gibbs sampler
HSROC(data = MRI,
      iter.num = 5000,
      init = init)

a <- HSROCSummary(data = MRI,
                  burn_in = 1000, print_plot = T)
a


# Multiple chains to assess convergence
dir.chain1 <- file.path(prj.dir, "Perfect_Chain1")
dir.create(dir.chain1)
setwd(dir.chain1)
init1 = list(init_within, init_between)
HSROC(data = MRI, iter.num = 5000, init = init1, path = dir.chain1)
a1 <- HSROCSummary(data = MRI, burn_in = 1000, print_plot = T)
a1

dir.chain2 <- file.path(prj.dir, "Perfect_Chain2")
dir.create(dir.chain2)
setwd(dir.chain2)
init2 = list(init_within, init_between)
HSROC(data = MRI, iter.num = 5000, init = init2, path = dir.chain2)
a2 <- HSROCSummary(data = MRI, burn_in = 1000, print_plot = T)
a2

dir.chain3 <- file.path(prj.dir, "Perfect_Chain3")
dir.create(dir.chain3)
setwd(dir.chain3)
init3 = list(init_within, init_between)
HSROC(data = MRI, iter.num = 5000, init = init3, path = dir.chain3)
a3 <- HSROCSummary(data = MRI, burn_in = 1000, print_plot = T)
a3

# Once all 3 chains have reached the desired number of iterations, a single call to
# the function HSROCSummary will summarize all 3 chains.

dir.all.chains <- file.path(prj.dir, "Perfect_AllChains")
dir.create(dir.all.chains)
setwd(dir.all.chains)
all.chains.fit <- HSROCSummary(data = MRI,
                               burn_in = 1000,
                               print_plot = T,
                               chain = list(dir.chain1,
                                            dir.chain2,
                                            dir.chain3))
all.chains.fit

# Meta-Analysis with imperfect reference test -----------------------------
dir.imperfect <- file.path(prj.dir, "Imperfect_One_Chain")
dir.create(dir.imperfect)
setwd(dir.imperfect)

# Provide a list with number of imperfect reference (1) and the corresponding studies
REFSTD = list(1, 1:7)

# Data fram from Timsit paper
brd = data.frame(TP = c(49, 37, 265, 121, 195, 157, 127),
                 FP = c(53, 1, 196, 42, 60, 29, 157),
                 FN = c(38, 90, 606, 910, 1395, 1344, 4591),
                 TN = c(64, 18, 969, 592, 373, 806, 8316))
M = dim(brd)[1]

names(brd) = c("++", "+-", "-+", "--")

brd

#Initial values for the within-study parameters
init.alpha = rep(2.5, M)
init.theta = rep(1, M)
init.s1 =  rep(0.5, M)
init.c1 = rep(0.5, M)
init.pi = rep(0.5, M)

#Initial values for the between-study parameters
init.THETA = -1.3
init.sd.theta = 2.3
init.LAMBDA = 3.4
init.sd.alpha = 1.3
init.beta = -0.9

#Initial values for the reference standard sensitivities and specificities
init.s2 = rep(0.75, REFSTD[[1]])
init.c2 = rep(0.75, REFSTD[[1]])

#The ordering of the initial values is important!
init1 = cbind(init.alpha, init.theta, init.s1, init.c1, init.pi)
init2 = c(init.THETA, init.sd.theta, init.LAMBDA, init.sd.alpha, init.beta)
init3 = rbind(init.s2, init.c2)

#pooling all togheter
init = list(init1, init2, init3)

# No prior information on reference test accuracy
set.seed(123)
HSROC(data = brd,
      init = init,
      iter.num = 10000,
      sub_rs = REFSTD) 

brd.fit <- HSROCSummary(data = brd,
                        burn_in = 1000,
                        print_plot = T)

brd.fit

# Putting prior information on reference test accuracy
S2.a = c(0.01)
S2.b = c(0.99) # sensitivity
C2.a = rep(0.8)
C2.b = rep(0.99) # specificity

HSROC(data = brd,
      init = init,
      iter.num = 10000,  
      prior.SEref = c(S2.a, S2.b), 
      prior.SPref = c(C2.a,C2.b),
      sub_rs = REFSTD) 

brd.fit <- HSROCSummary(data = brd,
                        burn_in = 1000,
                        print_plot = T)

brd.fit

# Meta-Analysis with multiple imperfect reference test --------------------
# Data simulations

# Simulating data for 15 studies based on an HSROC model such that
# the first 5 studies share one common reference standard and the remaining
# 10 studies another reference standard.

N = 15
LAMBDA = 7.5
sd_alpha = 0.75
THETA = -0.75
sd_theta = 0.75
beta = 0.5
pi = runif(15, 0.1, 0.5)
REFSTD = list(2, 1:5, 6:15) #Two different reference standards ...
s2 = c(0.5, 0.6) # Sensitivity of the reference tests (0.50 and 0.60, respectively)
c2 = c(0.75,0.95) # Specificity of the reference tests (0.75 and 0.95, respectively)

sim.data = simdata(N = N, n = seq(30, 120, 1),
                   n.random = T, sub_rs = REFSTD,
                   prev = pi, se_ref = s2, sp_ref = c2, T = THETA, L = LAMBDA, sd_t = sd_theta,
                   sd_a = sd_alpha, b = beta)
sim.data

sim.data$Data

dir.imp.ref.sim <- file.path(prj.dir, "Imperfect_Sim")
dir.create(dir.imp.ref.sim)
setwd(dir.imp.ref.sim)

init.s2 = rep(0.75, 2)
init.c2 = rep(0.75, 2)
init_ref = rbind(init.s2, init.c2)

init.alpha = rep(2.51, 15)
init.theta = rep(-0.51, 15)
init.s1 = rep(0.9, 15)
init.c1 = rep(0.9, 15)
init.pi = rep(0.5, 15)
 
init_within = cbind(init.alpha, init.theta, init.s1, init.c1, init.pi)

init = list(init_within, init_between, init_ref)

HSROC(data = sim.data$Data, iter.num = 5000,
      sub_rs = REFSTD)

sim.fit <- HSROCSummary(data = sim.data$Data,
                        burn_in = 1000,
                        print_plot = T)
sim.fit