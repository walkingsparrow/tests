library(PivotalR)
library(glmnet)
db.connect(port = 5433, dbname = "madlib")

dat <- db.data.frame("madlibtestdata.dt_abalone")

ys <- f$y.scl

f <- madlib.elnet(rings ~ . - id - sex, data = dat, family = "gaussian", alpha = 0.3, lambda = 0.1, control = list(random.stepsize=TRUE, tolerance=1e-5, eta=1.1, max.stepsize=2), glmnet = T)

f

## ----------------------------------------------------------------------

ld <- lk(dat, "all")
x <- as.matrix(ld[,-c(1,2,10)])
y <- ld$rings

g <- glmnet(x, y, alpha = 0.3, lambda = 0.1, family = "gaussian")

g$beta
g$a0

## ----------------------------------------------------------------------

## x <- matrix(rnorm(100*20),100,20)
## y <- rnorm(100, 0.1, 2)
## save(x, y, file = "data.rda")

load("data.rda")

g <- glmnet(x, y, alpha = 0.3, lambda = 0.2, family = "gaussian", standardize = FALSE)

g$beta
g$a0

## dat <- as.data.frame(cbind(x, y))
## delete("eldata")
## z <- as.db.data.frame(dat, "eldata")

dat1 <- db.data.frame("eldata", conn.id = 1)

f <- madlib.elnet(y ~ ., data = dat1, family = "gaussian", alpha = 0.3, lambda = 0.2, control = list(random.stepsize=TRUE, tolerance=1e-4, eta=1.1, max.stepsize=2), glmnet = T, standardize = FALSE)

f

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


log.likelihood(x, y, f$coef, f$intercept, 0.2, 0.3, scaling = FALSE)

log.likelihood(x, y, g$beta, g$a0, 0.2, 0.3, scaling = FALSE)

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

SAheart <- read.csv("SAHeart_RawData.csv", head=TRUE, sep=",")
SAheart$adiposity <- NULL
SAheart$typea <- NULL

# Specify dependent and independent variables
y <- SAheart$chd
X <- SAheart;
X$chd <- NULL

g <- glmnet(scale(X), y, family=c("binomial"), alpha=1, lambda=0.1, standardize=FALSE, intercept=TRUE)

g$beta
g$a0

cvfit = cv.glmnet(scale(X), y, family=c("binomial"), nfolds=5, alpha=1, type.measure="mse", standardize=FALSE)

betas <- coef(cvfit, s=cvfit$lambda.1se)

plot(cvfit)

## ----------------------------------------------------------------------

library(PivotalR)
library(glmnet)
db.connect(port = 5433, dbname = "madlib")

dat <- db.data.frame("saheart")

dat[,-10] <- scale(dat[,-10])

dat$type <- 1 - dat$chd
dat$type <- as.factor(dat$type)

f <- madlib.elnet(chd ~ . - adiposity - typea, data = dat, family = "binomial", alpha = 1, lambda = 0.07, control = list(random.stepsize=TRUE, tolerance=1e-4), glmnet = F, standardize = FALSE)

f

p <- predict(f, dat)

lk(p, 10)

log.likelihood(scale(X), y, f$coef, f$intercept, 0.1, 1, scaling = FALSE)

log.likelihood(scale(X), y, g$beta, g$a0, 0.1, 1, scaling = FALSE)

## ----------------------------------------------------------------------

train <- function (data, alpha, lambda)
    madlib.elnet(chd ~ . - adiposity - typea, data = data, family = "binomial", alpha = alpha, lambda = lambda, control = list(random.stepsize=TRUE), standardize = FALSE)

metric <- function (predicted, actual) lk(mean(as.logical(actual$chd) == predicted))

g <- generic.cv(
    train = train,
    predict = predict,
    metric = metric,
    data = dat,
    params = list(alpha=1, lambda=seq(0,0.2,0.04)), k = 5, find.min = FALSE)

plot(g$params$lambda, g$errs$avg, type = 'b')

g <- generic.cv(
    train = function (data, alpha, lambda) {
        madlib.elnet(chd ~ . - adiposity - typea, data = data, family = "binomial", alpha = alpha, lambda = lambda, control = list(random.stepsize=TRUE), standardize = FALSE)
    },
    predict = predict,
    metric = function (predicted, actual) {
        lk(mean(as.logical(actual$chd) == predicted))
    },
    data = dat,
    params = list(alpha=1, lambda=seq(0,0.2,0.01)),
    k = 10, find.min = FALSE)

## ----------------------------------------------------------------------

library(PivotalR)
library(glmnet)
db.connect(port = 14526, dbname = "madlib")

db.connect(port = 5433, dbname = "madlib")

dat <- db.data.frame("eldata")

g <- generic.cv(
    train = function (data, alpha, lambda) {
        madlib.elnet(y ~ ., data = data, family = "gaussian", alpha = alpha, lambda = lambda, control = list(random.stepsize=TRUE))
    },
    predict = predict,
    metric = function (predicted, actual) {
        lk(mean((actual$y - predicted)^2))
    },
    data = dat,
    params = list(alpha=1, lambda=seq(0,0.2,0.1)),
    k = 5, find.min = TRUE)
