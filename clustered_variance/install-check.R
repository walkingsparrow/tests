library(PivotalR)

db.connect(port = 14526, dbname = "madlib")

x <- db.data.frame("abalone1")

dat <- lookat(x, "all")

r1 <- lm(rings ~ length + diameter + height + whole, data = dat)

summary(r1)

clx <- function(fm, dfcw, cluster)
{
    library(sandwich)
    library(lmtest)
    M <- length(unique(cluster))
    N <- length(cluster)
    dfc <- (M/(M-1))*((N-1)/(N-fm$rank))
    print(dfc)
    print(N)
    u <- apply(estfun(fm), 2,
               function(x) tapply(x, cluster, sum))
    vcovCL <- dfc * sandwich(fm, meat = crossprod(u)/N) * dfcw
    list(coef = coeftest(fm, vcovCL), u = u)
}

cf <- clx(r1, 1, dat$sex)$coef

cf
