## test sampling methods
library(PivotalR)
library(glmnet)
options(digits = 12, width=150)
db.connect(port = 5433, dbname = "madlib")

dat <- db.data.frame("madlibtestdata.dt_abalone")

fit <- madlib.elnet(rings < 10 ~ . - id - sex + weight(as.integer(sex == "M")), data = dat, family = "binomial",
                    method = "cd", alpha = 1, lambda = 0.05, control = list(tolerance = 1e-6))

fit

madlib.elnet(rings < 10 ~ . - id - sex, data = dat, family = "binomial", method = "fista", alpha = 1, lambda = 0.05)
