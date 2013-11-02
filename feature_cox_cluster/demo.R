library(PivotalR)
library(survival)
db.connect(port = 14526, dbname = "madlib")
options(digits = 15)

## ----------------------------------------------------------------------

bladder2 <- lk("bladder2", "all")

coxph(Surv(stop, event>0) ~ rx + number + size + strata(enum) + cluster(cl), data = bladder2, ties = "breslow")

## ----------------------------------------------------------------------

lung <- lk('madlibtestdata.lung', "all")

coxph(Surv(time) ~ age + ph.ecog + cluster(ph.karno), data = lung, ties = "breslow")

coxph(Surv(time) ~ age + ph.ecog + cluster(ph.karno), data = lung, ties = "breslow",
      na.action = function(object, ...) object[with(object, !(is.na(age) | is.na(ph.ecog))),])
