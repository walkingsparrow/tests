library(PivotalR)
db.connect(port = 5433, dbname = "madlib")

dat <- db.data.frame("madlibtestdata.dt_abalone")
dd <- lk(dat, -1)

hist(dd$rings)

f <- glm(rings ~ length + diameter + shell, data = dd, family = "poisson")

r <- summary(f)

## all platforms, trace to display details
poisson <- function(x, y, init = rep(0, 4)) {
    fn <- function(beta) {
        f <- y*rowSums(beta*x) - exp(rowSums(beta*x))
        lk(mean(f))
    }
    gr <- function(beta) {
        g <- (y - exp(rowSums(beta*x))) * x
        lk(mean(g))
    }
    optim(init, fn, gr, method = "L-BFGS-B",
          control = list(fnscale = -1, trace = 5),
          hessian = TRUE)
}

g <- poisson(cbind(1, dat[,c("length", "diameter", "shell")]),
             dat$rings, init = rnorm(4, 0, 0.01))

g$par

sqrt(diag(solve(-g$hessian)) / nrow(dat))

r

x <- cbind(1, dat[,c("length", "diameter", "shell")])
h <- lk(crossprod(-x*exp(rowSums(g$par*x)), x))

sqrt(diag(solve(-h)))

## ----------------------------------------------------------------------

poisson.regr <- function(x, y)
{
    fn <- function(beta) {
        f <- y*rowSums(beta*x) - exp(rowSums(beta*x))
        lk(mean(f))
    }
    gr <- function(beta) {
        g <- (y - exp(rowSums(beta*x))) * x
        lk(mean(g))
    }
    res <- optim(init = c(0,0,0,0), fn, gr, method = "L-BFGS-B",
                 control = list(fnscale = -1, trace = 5), hessian = FALSE)
    coef <- res$par
    hessian <- lk(crossprod(-x * exp(rowSums(coef*x)), x))
    std.err <- sqrt(diag(solve(-hessian)))
    z <- coef / std.err
    p <- 2*(1 - pnorm(abs(z)))
    data.frame(Estimate = coef, `Std. Error` = std.err,
               `z value` = z, `Pr(>|t|)` = p, check.names = FALSE)
}

g <- poisson.regr(cbind(1, dat[,c("length", "diameter", "shell")]), dat$rings)

rownames(g) <- c("(Intercept)", "length", "diameter", "shell")
printCoefmat(g)
