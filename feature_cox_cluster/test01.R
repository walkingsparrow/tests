library(PivotalR)
library(survival)
db.connect(port = 14526, dbname = "madlib")

leuk <- lookat("bladder1", "all")

leuk$cl <- sample(1:2, nrow(leuk), replace = TRUE)

computeB <- function(x, y, cl, coef, strata)
{
    n <- length(unique(strata))
    x <- as.matrix(x)
    coef <- as.matrix(coef)
    A <- array(0, dim = c(n,3,3))
    rA <- array(0, dim = c(3,3))
    for (i in 1:length(y)) {
        v <- x[y>=y[i] & strata == strata[i],] * as.vector(exp(x[y>=y[i] & strata == strata[i],] %*% coef))
        if (is.matrix(v))
            s1 <- colSums(v)
        else
            s1 <- v
        s0 <- sum(exp(x[y>=y[i] & strata == strata[i],] %*% coef))
        w <- x[i,] - s1/s0
        for (j in (1:length(y))[y<=y[i] & strata == strata[i]]) {
            num <- exp(sum(coef * x[i,]))
            s0 <- sum(exp(x[y>=y[j] & strata == strata[i],] %*% coef))
            v <- x[y>=y[j] & strata == strata[i],] * as.vector(exp(x[y>=y[j] & strata == strata[i],] %*% coef))
            if (is.matrix(v))
                s1 <- colSums(v)
            else
                s1 <- v
            w <- w - (num/s0) * (x[i,] - s1/s0)
        }
        if (cl[i] == 1) {
            A[strata[i],1,] <- A[strata[i],1,] + w
            rA[1,] <- rA[1,] + w
        } else {
            A[strata[i],2,] <- A[strata[i],2,] + w
            rA[2,] <- rA[2,] + w
        }
    }
    res <- t(A[1,,]) %*% A[1,,]
    if (n > 1) for (i in 2:n) res <- res + t(A[i,,]) %*% A[i,,]
    list(res=res, rA=t(rA) %*% rA)
}

## ----------------------------------------------------------------------

## No strata

r <- coxph(Surv(stop) ~ rx + number + size, leuk, ties = "breslow")

coxph(Surv(stop) ~ rx + number + size + cluster(cl), leuk, ties = "breslow")

x <- leuk[,2:4]
y <- leuk[,5]
cl <- leuk[,8]
coef <- r$coefficients
strata <- rep(1, nrow(leuk))

B <- computeB(x, y, cl, coef, strata)

sqrt(diag(r$var %*% B$res %*% r$var))

sqrt(diag(r$var %*% B$rA %*% r$var))

## ----------------------------------------------------------------------

## Have strata

r <- coxph(Surv(stop) ~ rx + number + size + strata(enum), leuk, ties = "breslow")

coxph(Surv(stop) ~ rx + number + size + cluster(cl) + strata(enum), leuk, ties = "breslow")

x <- leuk[,2:4]
y <- leuk[,5]
cl <- leuk[,8]
coef <- r$coefficients
strata <- leuk[,7]

B <- computeB(x, y, cl, coef, strata)

sqrt(diag(r$var %*% B$res %*% r$var))

sqrt(diag(r$var %*% B$rA %*% r$var))

