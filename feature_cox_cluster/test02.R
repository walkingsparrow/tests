
library(PivotalR)
library(survival)
db.connect(port = 14526, dbname = "madlib")

leuk <- lookat("bladder1", "all")

leuk$cl <- sample(1:2, nrow(leuk), replace = TRUE)

## No strata
delete("bladder2")
as.db.data.frame(leuk, "bladder2")

r <- coxph(Surv(stop) ~ rx + number + size, leuk, ties = "breslow")

coxph(Surv(stop, event>0) ~ rx + number + size + cluster(cl) + strata(enum), leuk, ties = "breslow")

x <- leuk[,2:4]
y <- leuk[,5]
cl <- leuk[,8]
coef <- r$coefficients
strata <- rep(1, nrow(leuk))

B <- computeB(x, y, cl, coef, strata)

sqrt(diag(r$var %*% B$res %*% r$var))

sqrt(diag(r$var %*% B$rA %*% r$var))

## ----------------------------------------------------------------------

## Have strata

r <- coxph(Surv(stop) ~ rx + number + size + strata(enum), leuk, ties = "breslow")

coxph(Surv(stop) ~ rx + number + size + cluster(cl), leuk, ties = "breslow")

x <- leuk[,2:4]
y <- leuk[,5]
cl <- leuk[,8]
coef <- r$coefficients
strata <- leuk[,7]

B <- computeB(x, y, cl, coef, strata)

sqrt(diag(r$var %*% B$res %*% r$var))

sqrt(diag(r$var %*% B$rA %*% r$var))

## ----------------------------------------------------------------------

rossi <- lk("madlibtestdata.cox_rossi_strata_null", "all")

coxph(Surv(week, arrest) ~ fin + prio + cluster(race), data = rossi, ties = "breslow")

## ----------------------------------------------------------------------

rossi <- lk("madlibtestdata.pbc", "all")

coxph(Surv(time) ~ trt + log10(bili) + log10(protime) + age + platelet + cluster(stage), data = rossi, ties = "breslow")

z <- rossi[!(is.na(rossi$trt) | is.na(rossi$bili) | is.na(rossi$protime) | is.na(rossi$age) | is.na(rossi$platelet)),]

as.db.data.frame(z, "pbc_nonull")

coxph(Surv(time) ~ trt + log10(bili) + log10(protime) + age + platelet + cluster(stage), data = z, ties = "breslow")

##----------------------------------------------------------------------

rossi <- lk("madlibtestdata.lung", "all")

coxph(Surv(time) ~ age + ph.ecog + cluster(ph.karno) + strata(inst, na.group=T), data = rossi, ties = "breslow")

z <- rossi[!with(rossi, is.na(age) | is.na(ph.ecog) | is.na(ph.karno)),]

as.db.data.frame(z, "lung_nonull1")

coxph(Surv(time) ~ age + ph.ecog + cluster(ph.karno), data = rossi, ties = "breslow", na.action = function(object, ...) object[with(object, !(is.na(age) | is.na(ph.ecog))),])

coxph(Surv(time) ~ age + ph.ecog + cluster(ph.karno) + strata(inst, na.group = FALSE), data = rossi[!is.na(rossi$inst),], ties = "breslow", na.action = function(object, ...) object[with(object, !(is.na(age) | is.na(ph.ecog))),])


coxph(Surv(time) ~ age + ph.ecog + cluster(ph.karno) + strata(inst, na.group = TRUE), data = rossi, ties = "breslow", na.action = function(object, ...) object[with(object, !(is.na(age) | is.na(ph.ecog))),])
