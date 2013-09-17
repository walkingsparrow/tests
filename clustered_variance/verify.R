library(PivotalR)

db.connect(port = 14526, dbname = "madlib")

x <- lookat(db.data.frame("abalone"), "all")

clx <- function(fm, cluster) {
    library(sandwich)
    library(lmtest)
    M <- length(unique(cluster))
    cl <- cluster
    N <- length(cl)
    dfc <- (M/(M-1))*((N-1)/(N-fm$rank))
    u <- apply(estfun(fm), 2,
               function(x) tapply(x, cl, sum))
    vcovCL <- dfc * sandwich(fm, meat = crossprod(u)/N)
    coeftest(fm, vcovCL)
}

## ------------------------------------------------------------------------

fit <- lm(rings ~ shell + viscera + shucked + whole + height + diameter + length, data = x)

clx(fit, x$sex)

## ------------------------------------------------------------------------

git <- glm(rings < 10 ~ shell + viscera + shucked + whole + height + diameter + length, data = x, family = binomial)

clx(git, x$sex)

## ------------------------------------------------------------------------

y <- db.data.frame("abalone")

y$const <- 1

z <- as.db.data.frame(y, "abalone1")
