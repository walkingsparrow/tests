library(PivotalR)
db.connect(port = 5433, dbname = "madlib")

dat <- db.data.frame("madlibtestdata.dt_abalone")

madlib.glm(rings < 10 ~ length + diameter + shell, data = dat, family = "logistic")

glm(rings < 10 ~ length + diameter + shell, data = lk(dat, -1), family = "binomial")

logit <- function(x, y, init)
{
    fn <- function(beta) {
        p <- 1/(1 + exp(-rowSums(x * beta)))
        y <- as.integer(y)
        lk(sum(y * log(p) + (1 - y) * log(1 - p)))
    }

    gr <- function(beta) {
        p <- 1/(1 + exp(-rowSums(x * beta)))
        y <- as.integer(y)
        lk(colSums((y - p) * x))
    }

    optim(init, fn, gr, method = "L-BFGS-B", control = list(fnscale = -1), hessian = TRUE)
}

g <- logit(cbind(1, dat[,c("length", "diameter", "shell")]), dat$rings < 10, init = rep(0, 4))

g$par

sqrt(diag(solve(-g$hessian)))

## ----------------------------------------------------------------------

dd <- lk(dat, -1)

logit1 <- function(x, y, init)
{
    fn <- function(beta) {
        p <- 1/(1 + exp(-colSums(t(x) * beta)))
        sum(y * log(p) + (1 - y) * log(1 - p))
    }
    gr <- function(beta) {
        p <- 1/(1 + exp(-colSums(t(x) * beta)))
        colSums((y - p) * x)
    }
    optim(init, fn, gr, method = "BFGS", control = list(maxit = 200, fnscale = -1))
}

g1 <- logit1(cbind(1, dd[,c("length", "diameter", "shell")]), dd$rings < 10, init = rep(0, 4))

g1
