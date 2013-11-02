library(glmnet)
library(PivotalR)
db.connect(port = 14526, dbname = "madlib")

d1 <- db.data.frame("madlibtestdata.lin_parkinsons_updrs_oi")
d2 <- db.data.frame("madlibtestdata.log_breast_cancer_wisconsin")

dd1 <- lk(d1, "all")
dd2 <- lk(d2, "all")[,-1]

## ----------------------------------------------------------------------

f <- madlib.elnet(y ~ x, data = d1, family = "gaussian", alpha = 1, lambda = 0.02, control = list(random.stepsize=TRUE))

f

p <- predict(f, d1)

lk(p-d1$y, 10)

## ----------------------------------------------------------------------

f <- madlib.elnet(y ~ x, data = d2, family = "binomial", alpha = 1, lambda = 0.01, control = list(random.stepsize=TRUE))

f

p <- predict(f, d2, type = "response")

lk(p, 100)
