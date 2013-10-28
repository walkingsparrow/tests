
library(survival)

bladder1 <- bladder[bladder$enum < 5, ] 

coxph(Surv(stop, event) ~ rx + size + number, bladder1, ties = "breslow")

r <- coxph(Surv(stop) ~ rx + size + number, bladder1, robust = TRUE, ties = "breslow")

r

names(r)

H <- solve(r$naive.var)

library(Zelig)

z.out <- zelig(Surv(stop, event) ~ rx + size + number, robust = TRUE, model = "coxph", data = bladder1, ties = "breslow")

z.out

library(PivotalR)

db.connect(port = 14526, dbname = "madlib")

as.db.data.frame(bladder1, "bladder1")

## ----------------------------------------------------------------------

leuk <- lookat("madlibtestdata.cox_leukemia", "all")

r <- coxph(Surv(y) ~ ., leuk[,1:3])

r

temp <- my.resid(r, type = "dfbeta",  weighted = TRUE)

delete("leuk")
as.db.data.frame(leuk[1:7,], "leuk")

coxr(Surv(y) ~ ., leuk[,1:3])

## ----------------------------------------------------------------------

r <- coxph(Surv(y) ~ `x[1]`, robust = TRUE, leuk[,1:3])

r

## ----------------------------------------------------------------------

lk <- leuk[,1:3]
lk$t0 <- 0
lk$event <- 1

r <- coxph(Surv(y) ~ `x[1]` + `x[2]`, robust = T, lk, ties = "breslow")

r

library(eha)

coxreg(Surv(y) ~ `x[1]`, lk, method = "breslow")

## ----------------------------------------------------------------------

## Prototype

computeB <- function(x, y, coef)
{
    x <- as.matrix(x)
    coef <- as.matrix(coef)
    B <- NULL
    for (i in 1:length(y)) {
        v <- x[y>=y[i],] * as.vector(exp(x[y>=y[i],] %*% coef))
        if (is.matrix(v))
            s1 <- colSums(v)
        else
            s1 <- v
        s0 <- sum(exp(x[y>=y[i],] %*% coef))
        w <- x[i,] - s1/s0
        for (j in (1:length(y))[y<=y[i]]) {
            num <- exp(sum(coef * x[i,]))
            s0 <- sum(exp(x[y>=y[j],] %*% coef))
            v <- x[y>=y[j],] * as.vector(exp(x[y>=y[j],] %*% coef))
            if (is.matrix(v))
                s1 <- colSums(v)
            else
                s1 <- v
            w <- w - (num/s0) * (x[i,] - s1/s0)
        }
        if (is.null(B))
            B <- w %*% t(w)
        else
            B <- B + w %*% t(w)
    }
    B / length(y)
}


x <- lk[,2:4]
y <- lk$stop
coef <- r$coefficients

B <- computeB(x, y, coef)

B

v <- r$naive.var %*% B %*% r$naive.var * 24

sqrt(v)

v / 0.485^2

x <- as.matrix(x)
j <- 18
x[y>=y[j],]
x[y>=y[j],] %*% coef
as.vector(exp(x[y>=y[j],] %*% coef))
x[y>=y[j],] * as.vector(exp(x[y>=y[j],] %*% coef))
colSums()
colSums(x[y>=y[j],] * as.vector(exp(x[y>=y[j],] %*% coef)))
