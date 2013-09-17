clx <- function(fm, dfcw, cluster)
{
    library(sandwich)
    library(lmtest)
    M <- length(unique(cluster))
    N <- length(cluster)
    dfc <- (M/(M-1))*((N-1)/(N-fm$rank))
    u <- apply(estfun(fm), 2,
               function(x) tapply(x, cluster, sum))
    vcovCL <- dfc * sandwich(fm, meat = crossprod(u)/N) * dfcw
    coeftest(fm, vcovCL)
}

## ------------------------------------------------------------------------

library(PivotalR)
db.connect(port = 14526, dbname = "madlib")

dat <- lookat(db.data.frame("abalone"), "all")

fit <- lm(rings ~ length + diameter + height + shell, data = dat)

clx(fit, 1, dat$sex)

## ------------------------------------------------------------------------

git <- glm(rings < 10 ~ length + diameter + height + shell, data = dat, family = binomial)

summary(git)

clx(git, 1, dat$sex)
