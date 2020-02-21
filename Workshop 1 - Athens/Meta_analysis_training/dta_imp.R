# Please create one folder and setup as your home directory  
prj.dir <- "/Users/paoloeusebi/Desktop/Lavoro/Harmony/Athens2020/AdvTraining6"

library('runjags')

cell = matrix(c(49, 37, 265, 121, 195, 157, 127,
               53, 1, 196, 42, 60, 29, 157,
               38, 90, 606, 910, 1395, 1344, 4591,
               64, 18, 969, 592, 373, 806, 8316),
              ncol=4)

cell
l = 7
n = apply(cell, 1, sum)

# Initial values 
LAMBDA = 3.431034184913633
THETA = -1.304227078288899
beta = -0.9265053531278415
#pi=rep(0.5,7)
pi = c(0.4422856231386147,0.1323546770728543,0.9361053272154514,0.5561267869568134,0.5606566044504981,
  0.6356740494799841,0.1393668380217704)
sigma = c(2.276785798926327,1.294218492545403)

results <- run.jags(file.path(prj.dir, 'dta_imp.txt'), 
                    n.chains = 3,
                    burnin = 10000,
                    sample = 110000)

results

plot(results,vars = "Se_overall",
     plot.type = c("trace", "density", "autocorr"))

plot(results,vars = "Sp_overall",
     plot.type = c("trace", "density", "autocorr"))

plot(results,vars = "s2",
     plot.type = c("trace", "density", "autocorr"))

plot(results,vars = "c2",
     plot.type = c("trace", "density", "autocorr"))
