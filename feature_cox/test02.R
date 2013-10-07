library(survival)

help(coxph)

test1 <- list(time=c(4,3,1,1,2,2,3), 
              status=c(1,1,1,0,1,1,0), 
              x=c(0,2,1,1,1,0,0), 
              sex=c(0,0,0,0,1,1,1)) 

s <- coxph(Surv(time, status) ~ x + strata(sex), test1) 

s

0.802/0.822

pnorm(0.9756691)

pnorm(-2.47)

1 - pchisq((0.802/0.822)^2,1)

r <- cox.zph(s)

r



1 - pchisq(0.3221,1)
