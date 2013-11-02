## Prototype for fast elastic net algorithms

soft.thresh <- function(z, lambda) {
    if (z > 0 && z > lambda) return (z - lambda)
    if (z < 0 && -z > lambda) return (z + lambda)
    0
}

## linear elastic net
el.lin <- function (x, y, alpha = 1, lambda = 0.1, thresh = 1e-6,
                    max.iter = 1000, use.active.set = TRUE, glmnet = FALSE) {
    x <- as.matrix(x)
    y <- as.vector(y)
    ## x <- scale(x)
    ## y <- scale(y, scale = FALSE)
    x.ctr <- colMeans(x)
    x.scl <- sqrt(rowMeans((t(x)-x.ctr)^2))
    y.ctr <- mean(y)
    x <- t((t(x) - x.ctr) / x.scl)
    y <- y - y.ctr
    if (glmnet) {
        y.scl <- sqrt(mean(y^2))
        y <- y / y.scl
        lambda <- lambda / y.scl
    } else y.scl <- 1
    xy <- t(x) %*% y
    xx <- t(x) %*% x
    n <- ncol(x)
    N <- nrow(x)
    a0 <- 0 # intercept
    a <- rep(0, n) # coef

    prev.a <- a
    count <- 0
    active.set <- FALSE
    repeat {
        if (active.set && use.active.set) {
            run <- seq_len(n)[a!=0]
        } else {
            run <- seq_len(n)
        }
        for (j in run) {
            z <- (xy[j] - sum(xx[j,a!=0] * a[a!=0]))/N + a[j]
            a[j] <- soft.thresh(z, alpha*lambda) / (1 + lambda * (1-alpha))
        }
        count <- count + 1
        if (count > max.iter) break
        if (sqrt(mean((a-prev.a)^2))/mean(abs(prev.a)) < thresh) {
            if (active.set && use.active.set)
                active.set <- FALSE
            else
                break
        } else {
            if (!active.set) active.set <- TRUE
        }
        prev.a <- a
    }

    a0 <- y.ctr - sum(x.ctr * a / x.scl) * y.scl
    a <- a * y.scl / x.scl
    list(a0=a0, a=a, iter=count, y.scl = y.scl)
}

## ----------------------------------------------------------------------

## x <- matrix(rnorm(100*20),100,20)
## y <- rnorm(100, 0.1, 2)

## save(x, y, file = "data.rda")
load("data.rda")

f <- el.lin(x, y, alpha = 0.2, lambda = 0.05, thresh = 1e-10, max.iter = 10000, use.active.set = TRUE, glmnet = T)

f

f$y.scl

## ----------------------------------------------------------------------

library(PivotalR)
db.connect(port = 5433, dbname = "madlib")

## dat <- as.data.frame(cbind(x, y))

## delete("eldata")
## z <- as.db.data.frame(dat, "eldata")

z <- db.data.frame("eldata")

g <- madlib.elnet(y ~ ., data = z, alpha = 0.2, lambda = 0.05, control = list(random.stepsize=FALSE, use.active.set=FALSE, tolerance=1e-6), glmnet = T)

g

p <- predict(g, z)

lk(p, 10)

## ----------------------------------------------------------------------

library(glmnet)

## w <- sqrt(mean((y-mean(y))^2))
s <- glmnet(x, y, family = "gaussian", alpha = 0.2, lambda = 0.05)

as.vector(s$beta)
s$a0

v <- scale(y)
ctr <- attr(v, "scaled:center")
scl <- attr(v, "scaled:scale")

s$a0*scl + ctr

g$intercept*scl + ctr
