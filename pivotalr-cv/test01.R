library(PivotalR)
db.connect(port = 16526, dbname = "madlib")

## x <- matrix(rnorm(100000 * 350), 100000, 350)
## g2 <- sample(c(TRUE, FALSE), 100000, replace=TRUE)

## dat <- as.db.data.frame(data.frame(x, g2), "testcv")

dat <- db.data.frame("testcv")

system.time({fit <- madlib.elnet(
    g2 ~ ., data = dat, family = "binomial", method = "fista", alpha = 1,
    lambda = 0.1, control = list(max.iter = 100, tolerance = 1e-2))})

dat <- db.data.frame("madlibtestdata.lin_auto_mpg_wi")

madlib.lm(y ~ x + as.factor(x[2]), data = dat)
