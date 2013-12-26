library(PivotalR)
library("glmnet")
source("log.liklihood.R")
options(digits = 12)

db.connect(port = 14526, dbname = "madlib")

db.connect(port = 5433, dbname = "madlib")

dat <- db.data.frame("madlibtestdata.log_breast_cancer_wisconsin")

fit <- madlib.elnet(y ~ x, data = dat, family = "binomial", alpha = 0.5, lambda = 0.05, method = "cd", control = list(tolerance = 1e-6))

fit

system.time(madlib.elnet(y ~ x, data = dat, family = "binomial", alpha = 0.5, lambda = 0.05, method = "fista", control = list(tolerance = 1e-6)))

dat <- db.data.frame("madlibtestdata.dt_abalone")

dat <- db.data.frame("madlibtestdata.lin_auto_mpg_wi", conn.id = 2)

dat <- db.data.frame("ticcompl_l", 1)

fit <- madlib.elnet(caravan ~ ., data = dat, family = "binomial", alpha = 1, lambda = 0.005, method = "cd", control = list(tolerance = 1e-4))

fit

system.time(madlib.elnet(caravan ~ ., data = dat, family = "binomial", alpha = 1, lambda = 0.005, method = "cd", control = list(tolerance = 1e-4)))

x <- as.matrix(lk(dat[,1], -1))
y <- lk(dat[,2],-1)

g <- glmnet(x, y, family = "binomial", alpha = 0.5, lambda = 0.05)

g$beta
g$a0

log.likelihood2(x, y, g$beta, g$a0, 0.05, 0.5, TRUE)

## ----------------------------------------------------------------------

x <- dat[,1:85]
y <- dat[,86]
coef <- rep(0,86)

n <- length(coef) - 1 # exclude the intercept
intercept <- coef[n+1]
rcoef <- coef[1:n]
mid <- cbind2(x, as.integer(y))
names(mid) <- c(paste("x", 1:n, sep = ""), "y")

mid$lin <- intercept + rowSums(rcoef * x)

mid$lin <- intercept + Reduce(function(l,r) l+r, as.list(rcoef*x))

mid$lin <- 1
mid$lin@.expr <- paste(intercept, "+", paste(rcoef, "*", x@.expr, collapse = "+"))
mid$lin@.content <- gsub("^select 1 as", paste("select", mid$lin@.expr, "as"),mid$lin@.content)

system.time(intercept + Reduce(function(l,r) l+r, as.list(rcoef*x)))

mid$p <- 1 / (1 + exp(-1 * mid$lin))
mid$w <- mid$p * (1 - mid$p)
mid$wx <- mid$w * db.array(x)
mid$x <- db.array(x)
## mid$w[mid$p < 1e-5 | mid$p > 1 - 1e-5] <- 1e-5
## mid$p[mid$p < 1e-5] <- 0
## mid$p[mid$p > 1 - 1e-5] <- 1

f <- as.db.data.frame(mid, is.view = FALSE, verbose = FALSE)

system.time(as.db.data.frame(mid, is.view = FALSE, verbose = FALSE))

w <- f$w
## w <- f$p * (1 - f$p)
z <- f$lin + (f$y - f$p) / w

compute <- Reduce(cbind2, c(crossprod(f$x, f$wx), crossprod(f$wx, z),
                            mean(Reduce(cbind2, c(f$wx, f$x, z, w*z, w)))))

compute <- as.db.data.frame(compute, verbose = FALSE)

system.time(as.db.data.frame(compute, verbose = FALSE))

xx <- compute[,1]; class(xx) <- "db.Rcrossprod"; xx@.dim <- c(n,n)
xx@.is.symmetric <- FALSE; xx <- as.matrix(lk(xx))

xy <- compute[,2]; class(xy) <- "db.Rcrossprod"; xy@.dim <- c(1,n)
xy@.is.symmetric <- FALSE; xy <- as.vector(lk(xy))

ms <- unlist(lk(compute[,-c(1,2)]))
mwx <- ms[1:n]
mx <- ms[1:n + n]
my <- ms[2*n+1]
mwz <- ms[2*n+2]
mw <- ms[2*n+3]
iter <- 0
## coef <- rep(0, n+1)

rst <- .Call("elcd_binom", xx, xy, mwx, mx, mwz, mw,
             alpha, lambda, control$use.active.set,
             as.integer(control$max.iter),
             control$tolerance, as.integer(N), coef, iter,
             PACKAGE = "PivotalR")
