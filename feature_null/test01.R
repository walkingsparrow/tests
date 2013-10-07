library(PivotalR)

db.connect(port=14526, dbname = "madlib")

dat <- db.data.frame("madlibtestdata.log_wpbc")

dim(dat)

x <- lookat(dat, "all")

x[1:10,]

## x$y <- as.factor(x$y)

glm(y ~ ., data = x, family = binomial, na.action = na.omit, control = list(epsilon = 1e-8, maxit = 2000))
