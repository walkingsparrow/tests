
library(PivotalR)

db.connect(port = 14526, dbname = "madlib")

dat <- lk("sample_data", "all")

library(survival)

coxph(Surv(timedeath, status) ~ grp + wbc, dat, robust = TRUE)
