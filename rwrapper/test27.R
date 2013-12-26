library(PivotalR)
library(glmnet)
db.connect(port = 14526, dbname = "madlib")

x <- matrix(rnorm(100000*385),100000,385)
g2 <- sample(1:2,100,replace=TRUE)
fit2 <- glmnet(x, g2, family="binomial", alpha = 1, lambda = 0.001)

f <- madlib.elnet(g2 ~ ., data = db, family = "binomial", alpha = 1, lambda = 0.001, method = "fista", control = list(random.stepsize = TRUE))
     

dat <- db.data.frame("madlibtestdata.dt_abalone")

options(digits = 12)

madlib.elnet(rings < 10 ~ . - id - sex, data = dat, family = "binomial", method = "fista", alpha = 0.5, lambda = 0.01, control = list(max.iter=400, random.stepsize = TRUE))

madlib.elnet(rings < 10 ~ . - id - sex, data = dat, family = "binomial", method = "cd", alpha = 0.5, lambda = 0.01, control = list(max.iter=2500))

## fit2$nulldev * (1 - fit2$dev.ratio) / (-2*N)
