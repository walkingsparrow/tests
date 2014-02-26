library(PivotalR)
db.connect(port = 16526, dbname = "madlib")

dat <- db.data.frame("madlibtestdata.dt_abalone")
dd <- lk(dat, -1)

for (i in 1:7) dd <- rbind(dd, dd)

dim(dd)

dat <- as.db.data.frame(dd)

system.time({fit <- madlib.glm(rings < 10 ~ length + diameter + shell, data = dat, family = "binomial", control = list(method="cg"))})

fit

fit$num_iterations

logit <- function(x, y, init)
{
    fn <- function(beta) {
        p <- 1/(1 + exp(-rowSums(x * beta)))
        y <- as.integer(y)
        lk(mean(y * log(p) + (1 - y) * log(1 - p)))
    }

    gr <- function(beta) {
        p <- 1/(1 + exp(-rowSums(x * beta)))
        y <- as.integer(y)
        lk(mean((y - p) * x))
    }

    optim(init, fn, gr, method = "CG", control = list(fnscale = -1, maxit = 41), hessian = FALSE)
}

system.time({g <- logit(cbind(1, dat[,c("length", "diameter", "shell")]), dat$rings < 10, init = rep(0, 4))})

g$par

## ----------------------------------------------------------------------

logit1 <- function(x, y, init)
{
    compute <- function(beta) {
        p <- 1/(1 + exp(-rowSums(x * beta)))
        y <- as.integer(y)
        res <- cbind(y * log(p) + (1 - y) * log(1 - p), (y - p) * x)
        lk(mean(res))
    }

    res <- numeric(0)

    fn <- function(beta) {
        res <<- compute(beta)
        res[1]
    }

    gr <- function(beta) res[-1]

    optim(init, fn, gr, method = "CG", control = list(fnscale = -1, maxit = 21), hessian = FALSE)
}

system.time({g1 <- logit1(cbind(1, dat[,c("length", "diameter", "shell")]), dat$rings < 10, init = rep(0, 4))})

g1$par

g1$counts

g1$convergence
