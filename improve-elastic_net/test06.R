library(PivotalR)
db.connect(port = 14526, dbname = "madlib")

dat <- db.data.frame("eldata")

f <- madlib.elnet(y ~ ., data = dat, family = "gaussian", method = "fista",
                  alpha = 1, lambda = 0.1)

f

f1 <- madlib.elnet(y ~ ., data = dat, family = "gaussian", method = "cd",
                  alpha = 1, lambda = 0.1)

f1

## ----------------------------------------------------------------------

dat <- db.data.frame("madlibtestdata.dt_abalone")

f <- madlib.elnet(rings ~ . - id - sex, data = dat, family = "gaussian", method = "fista", alpha = 1, lambda = 0.1)

f

f1 <- madlib.elnet(rings ~ . - id - sex, data = dat, family = "gaussian", method = "cd", alpha = 1, lambda = 0.1)

f1
