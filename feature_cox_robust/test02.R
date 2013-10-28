library(PivotalR)
library(survival)

db.connect(port = 14526, dbname = "madlib")

x <- db.data.frame("madlibtestdata.cox_leukemia")

dat <- lk(x, "all")

dat

coxph(Surv(y, y<15) ~ . - status, dat, robust = TRUE, ties = "breslow")

## ----------------------------------------------------------------------

x <- db.data.frame("bladder1")

names(x) <- c("id",     "rx",     "number", "size",   "stop",   "event",  "enum1")

as.db.data.frame(x, "bladder2")

dat <- lk(sort(x, F, x$stop), "all")

dim(dat)

r <- coxph(Surv(stop, event) ~ rx + size + number, dat, ties = "breslow")


coxph(Surv(stop, event) ~ rx + size + number, dat, ties = "breslow", robust = TRUE)

coxph(Surv(stop, event) ~ rx + size + number + strata(enum), dat, ties = "breslow", robust = TRUE)

## ----------------------------------------------------------------------

madlib.lm(y ~ . - `x[1]`, data = g)

madlib.lm(y ~ x - `x[1]`, data = g)

s <- db.data.frame("madlibtestdata.dt_abalone")

madlib.lm(rings ~ . - id | sex, data = s)
