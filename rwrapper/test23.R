library(PivotalR)
library(glmnet)
options(digits = 15)

## db.connect(port = 14526, dbname = "madlib")

db.connect(port = 5433, dbname = "madlib")

dat <- db.data.frame("madlibtestdata.dt_abalone")

dat$rings <- scale(dat$rings)

f1 <- madlib.elnet(rings ~ . - id - sex, data = dat, family = "gaussian",
                   method = "cd", alpha = 0.5, lambda = 0.05, glmnet = F,
                   standardize = T, control = list(use.active.set = T))

f1

d <- lk(dat, "all")
x <- as.matrix(d[,-c(1,2,10)])
y <- as.vector(d[,10])

g <- glmnet(x, y, family = "gaussian", alpha = 0.5, lambda = 0.05, standardize = T)

g$beta
g$a0

## ----------------------------------------------------------------------

log.likelihood <- function(x, y, coef, a0, lambda, alpha, scaling = FALSE)
{
    s <- 0
    for (i in seq(length(y)))
    {
        t <- sum(coef * x[i,]) + a0 - y[i]
        s <- s + 0.5 * t^2
    }
    s <- s / length(y)
    if (!scaling)
    {
        s <- s + 0.5 * lambda * (1 - alpha) * sum(coef * coef) + lambda * alpha * sum(abs(coef))
    }
    else
    {
        xsd <- apply(x, 2, sd) * sqrt(1 - 1./length(y))
        s <- s + 0.5 * lambda * (1- alpha) * sum((coef * xsd)^2) + lambda * alpha * sum(abs(coef * xsd))
    }
    ##
    as.numeric(-s)
}


log.likelihood(x, y, f1$coef, f1$intercept, 0.05, 0.5, scaling = TRUE)

log.likelihood(x, y, g$beta, g$a0, 0.05, 0.5, scaling = TRUE)

log.likelihood2 <- function(x, y, coef, a0, lambda, alpha, scaling = FALSE)
{
    s <- 0
    for (i in seq(length(y)))
    {
        t <- sum(coef * x[i,]) + a0
        if (y[i] == TRUE)
            s <- s + log(1 + exp(-t))
        else
            s <- s + log(1 + exp(t))
    }
    s <- s / length(y)
    if (!scaling)
    {
        s <- s + 0.5 * lambda * (1 - alpha) * sum(coef * coef) + lambda * alpha * sum(abs(coef))
    }
    else
    {
        xsd <- apply(x, 2, sd) * sqrt(1 - 1./length(y))
        s <- s + 0.5 * lambda * (1- alpha) * sum((coef * xsd)^2) + lambda * alpha * sum(abs(coef * xsd))
    }
    as.numeric(-s)
}

## ----------------------------------------------------------------------

library(PivotalR)
library(glmnet)
options(digits = 15)

db.connect(port = 5433, dbname = "madlib")

dat <- db.data.frame("madlibtestdata.dt_abalone")

dat[,-c(1,2,10)] <- scale(dat[,-c(1,2,10)])

f1 <- madlib.elnet(rings < 10 ~ . - id - sex, data = dat, family = "binomial",
                   method = "cd", alpha = 0.5, lambda = 0.05, standardize = T,
                   control = list(max.iter = 10000, tolerance = 1e-6,
                   use.active.set = FALSE, warmup = TRUE))

f1

d <- lk(dat, "all")
x <- as.matrix(d[,-c(1,2,10)])
y <- as.vector(d[,10] < 10)

g <- glmnet(x, y, family = "binomial", alpha = 0.5, lambda = 0.05, standardize = T)

g$beta
g$a0

log.likelihood2(x, y, f1$coef, f1$intercept, 0.05, 0.5, TRUE)

log.likelihood2(x, y, g$beta, g$a0, 0.05, 0.5, TRUE)

p <- predict(f1, dat, type = "response")

lk(p, 10)
