library(survival)

test1 <- list(time=c(4,3,1,1,2,2,3), 
              status=c(1,1,1,0,1,1,0), 
              x=c(0,2,1,1,1,0,0), 
              sex=c(0,0,0,0,1,1,1)) 

fit <- coxph(Surv(time, status) ~ x, test1) 

dg <- cox.zph(fit, transform="rank", global = F)

dg

print(dg)

plot(dg)

names(dg)

names(fit)

cor(fit$residuals, test1$time)

cor(fit$residuals, rank(test1$time))

sr <- 5 * fit$var * fit$residuals

cor(sr, rank(test1$time))

length(fit$coefficients)

sum(fit$residuals)

fit$residuals

rs <- resid(fit, "schoenfeld")

cor(rs, rank(as.numeric(names(rs))))

cor(rs, as.numeric(names(rs)))

## ----------------------------------------------------------------------

library(survival)
library(PivotalR)

db.connect(port = 14526, dbname = "madlib")

dat <- db.data.frame("leukemia")

x <- lookat(dat, "all")

x

coxph(Surv(timedeath, status) ~ grp + wbc, data = x)

## ----------------------------------------------------------------------

rossi <- read.table('Rossi.txt', header=T)

rossi$age_cat <- recode(rossi$age, "lo:19=1; 20:25=2; 26:30=3; 31:hi=4")

rossi$age_cat <- recode(rossi$age, "lo:hi=1")

coxph(Surv(week, arrest) ~ fin + prio, data = rossi, ties = "breslow")

coxph(Surv(week, arrest) ~ fin + prio + strata(age_cat), data = rossi, ties = "breslow")

delete("rossi")
x <- as.db.data.frame(rossi, "rossi")

unique(rossi$age.cat)
