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
    count <- 0
    fn <- function(beta) {
        count <<- count + 1
        f <- y*rowSums(beta*x) - exp(rowSums(beta*x))
        dt <- system.time({res <- lk(mean(f))})
        print(dt)
        res
    }
    gr <- function(beta) {
        count <<- count + 1
        g <- (y - exp(rowSums(beta*x))) * x
        dt <- system.time({res <- lk(mean(g))})
        print(dt)
        res
    }
    res <- optim(init, fn, gr, method = "L-BFGS-B",
          control = list(fnscale = -1, trace = 0),
          hessian = FALSE)
    print(count)
    res
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
    count <- 0
    compute <- function(beta) {
        f <- y*rowSums(beta*x) - exp(rowSums(beta*x))
        g <- (y - exp(rowSums(beta*x))) * x
        ## dt <- system.time({res <- lk(mean(as.double(cbind(f, g))))})
        ## print(dt)
        ## return (res)
        count <<- count + 1
        lk(mean(cbind(f, g)))
    }

    updated <- FALSE
    res <- numeric(0)

    fn <- function(beta) {
        if (updated) {
            updated <<- FALSE
        } else {
            res <<- compute(beta)
            updated <<- TRUE
        }
        res[1]
    }

    gr <- function(beta) {
        if (updated) {
            updated <<- FALSE
        } else {
            res <<- compute(beta)
            updated <<- TRUE
        }
        res[-1]
    }

    res <- optim(init, fn, gr, method = "L-BFGS-B",
          control = list(fnscale = -1, trace = 5),
          hessian = FALSE)
    print(count)
    res
}

system.time({g1 <- poisson1(cbind(1, dat[,c("length", "diameter", "shell")]),
                            dat$rings)})

g1$par

x <- cbind(1, dat[,c("length", "diameter", "shell")])
h <- lk(crossprod(-x*exp(rowSums(g1$par*x)), x))
sqrt(diag(solve(-h)))

r

system.time(lk("temp_result"))
