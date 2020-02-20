rm(list=ls())


setwd("C:\\Users\\admin\\Documents\\COST\\cestode")
getwd()



library(rjags)

library(coda);

# analysis for model without covariates
res1 <- read.coda("model1.withoutchain1.txt","model1.withoutindex.txt");
res2 <- read.coda("model2.withoutchain1.txt","model2.withoutindex.txt");
res3 <- read.coda("model3.withoutchain1.txt","model3.withoutindex.txt");




#summary(res1); summary(res2); summary(res3)
heidel.diag(res1);heidel.diag(res2);heidel.diag(res3);
geweke.diag(res1); geweke.diag(res2); geweke.diag(res3)


all<-mcmc.list(res1,res2,res3);
plot(all)

par(mfrow=c(1,1))
plot(density(c(res1[,"s1"])),col="red");
lines(density(c(res2[,"s1"])),col="darkgreen");
lines(density(c(res3[,"s1"])),col="blue");

plot(density(c(res1[,"s2"])),col="red");
lines(density(c(res2[,"s2"])),col="darkgreen");
lines(density(c(res3[,"s2"])),col="blue");

plot(density(c(res1[,"s3"])),col="red");
lines(density(c(res2[,"s3"])),col="darkgreen");
lines(density(c(res3[,"s3"])),col="blue");

plot(density(c(res1[,"c2"])),col="red");
lines(density(c(res2[,"c2"])),col="darkgreen");
lines(density(c(res3[,"c2"])),col="blue");

plot(density(c(res1[,"c3"])),col="red");
lines(density(c(res2[,"c3"])),col="darkgreen");
lines(density(c(res3[,"c3"])),col="blue");

hist(c(res1[,"covs12"],res2[,"covs12"],res3[,"covs12"]),100,main="Histogram of covs12",xlab="")


cbind(prettyNum(apply(rbind(res1),2,mean)))
cbind(prettyNum(apply(rbind(res2),2,mean)))
cbind(prettyNum(apply(rbind(res3),2,mean)))

cbind(prettyNum(apply(rbind(res1,res2,res3),2,mean)))

t(apply(rbind(res1),2,quantile,probs=c(0.025,0.975)))
t(apply(rbind(res2),2,quantile,probs=c(0.025,0.975)))
t(apply(rbind(res3),2,quantile,probs=c(0.025,0.975)))

t(apply(rbind(res1,res2,res3),2,quantile,probs=c(0.025,0.975)))



##############################################################################
# analysis for model with covariates
res1.cestode <- read.coda("model1.cestodechain1.txt","model1.cestodeindex.txt");
res2.cestode <- read.coda("model2.cestodechain1.txt","model2.cestodeindex.txt");
res3.cestode <- read.coda("model3.cestodechain1.txt","model3.cestodeindex.txt");




#summary(res1.cestode); summary(res2.cestode); summary(res3.cestode)
heidel.diag(res1.cestode);heidel.diag(res2.cestode);heidel.diag(res3.cestode);
geweke.diag(res1.cestode); geweke.diag(res2.cestode); geweke.diag(res3.cestode)


all<-mcmc.list(res1.cestode,res2.cestode,res3.cestode);
plot(all)


par(mfrow=c(1,1))
plot(density(c(res1.cestode[,"s1"])),col="red");
lines(density(c(res2.cestode[,"s1"])),col="darkgreen");
lines(density(c(res3.cestode[,"s1"])),col="blue");

plot(density(c(res1.cestode[,"s2"])),col="red");
lines(density(c(res2.cestode[,"s2"])),col="darkgreen");
lines(density(c(res3.cestode[,"s2"])),col="blue");

plot(density(c(res1.cestode[,"s3"])),col="red");
lines(density(c(res2.cestode[,"s3"])),col="darkgreen");
lines(density(c(res3.cestode[,"s3"])),col="blue");

plot(density(c(res1.cestode[,"c2"])),col="red");
lines(density(c(res2.cestode[,"c2"])),col="darkgreen");
lines(density(c(res3.cestode[,"c2"])),col="blue");

plot(density(c(res1.cestode[,"c3"])),col="red");
lines(density(c(res2.cestode[,"c3"])),col="darkgreen");
lines(density(c(res3.cestode[,"c3"])),col="blue");

hist(c(res1.cestode[,"covs12"],res2.cestode[,"covs12"],res3.cestode[,"covs12"]),100,main="Histogram of covs12",xlab="")

cbind(prettyNum(apply(rbind(res1.cestode),2,mean)))
cbind(prettyNum(apply(rbind(res2.cestode),2,mean)))
cbind(prettyNum(apply(rbind(res3.cestode),2,mean)))

cbind(prettyNum(apply(rbind(res1.cestode,res2.cestode,res3.cestode),2,mean)))

comb <- cbind(prettyNum(apply(rbind(res1.cestode,res2.cestode,res3.cestode),2,mean)))

t(apply(rbind(res1.cestode),2,quantile,probs=c(0.025,0.975)))
t(apply(rbind(res2.cestode),2,quantile,probs=c(0.025,0.975)))
t(apply(rbind(res3.cestode),2,quantile,probs=c(0.025,0.975)))

t(apply(rbind(res1.cestode,res2.cestode,res3.cestode),2,quantile,probs=c(0.025,0.975)))




# for OR and prevalence with and without covariates
comb[15] # slope
exp(as.numeric(comb[15])) # OR

# prevalence in Taenia neg. population
comb[16] # intercept
exp(as.numeric(comb[16]))

PrTneg <- exp(as.numeric(comb[16]))/(1+exp(as.numeric(comb[16])))
PrTneg

# prevalence in Taenia pos. population
exp(as.numeric(comb[15])+as.numeric(comb[16]))

PrTpos <- exp(as.numeric(comb[15])+as.numeric(comb[16]))/(1+exp(as.numeric(comb[15])+as.numeric(comb[16])))
PrTpos

#############################################################



#Figure 1 effect of Taenia on prevalence of Echinococcus
#Plot for effect of taenia on prevalence
slopd<-cbind(res1.cestode[,"slope"],res2.cestode[,"slope"],res3.cestode[,"slope"]);
itcp<-cbind(res1.cestode[,"intercept"],res2.cestode[,"intercept"],res3.cestode[,"intercept"]);



plot(density((exp(itcp)/(1+exp(itcp)))), col="blue",ylim=c(0,15),xlim=c(0,1),xlab="",lwd=2);
lines(density((exp(itcp+slopd)/(1+exp(itcp+slopd)))), col="red",lwd=2)
abline(v = PrTneg, col = "blue")
abline(v = PrTpos, col = "red")
