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
