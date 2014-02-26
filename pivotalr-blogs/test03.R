library(PivotalR)
db.connect(port = 16526, dbname = "madlib")

dat <- db.data.frame("madlibtestdata.dt_abalone")
dd <- lk(dat, -1)

for (i in 1:10) dd <- rbind(dd, dd)

dim(dd)

dat <- as.db.data.frame(dd)

system.time({fit <- glm(rings ~ length + diameter + shell, data = dd, family = "poisson"); r <- summary(fit)})

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
          control = list(fnscale = -1, trace = 0),
          hessian = FALSE)
}

system.time({g <- poisson(cbind(1, dat[,c("length", "diameter", "shell")]),
                          dat$rings)})

g$par

x <- cbind(1, dat[,c("length", "diameter", "shell")])
h <- lk(crossprod(-x*exp(rowSums(g$par*x)), x))
sqrt(diag(solve(-h)))

r

## ----------------------------------------------------------------------

poisson1 <- function(x, y, init = rep(0,4))
{
    compute <- function(beta) {
        f <- y*rowSums(beta*x) - exp(rowSums(beta*x))
        g <- (y - exp(rowSums(beta*x))) * x
        lk(mean(cbind(f, g)))
    }

    res <- numeric(0)

    fn <- function(beta) {
        res <<- compute(beta)
        res[1]
    }

    gr <- function(beta) res[-1]

    optim(init, fn, gr, method = "L-BFGS-B",
          control = list(fnscale = -1, trace = 5),
          hessian = FALSE)
}

system.time({g1 <- poisson1(cbind(1, dat[,c("length", "diameter", "shell")]),
                            dat$rings)})

g1$par

x <- cbind(1, dat[,c("length", "diameter", "shell")])
h <- lk(crossprod(-x*exp(rowSums(g1$par*x)), x))
sqrt(diag(solve(-h)))

r

system.time(lk("temp_result"))
