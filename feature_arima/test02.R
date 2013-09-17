## prototype fo ARIMA

ts <- c(100.8, 81.6, 66.5, 34.8, 30.6, 7, 19.8, 92.5,
        154.4, 125.9, 84.8, 68.1, 38.5, 22.8, 10.2, 24.1, 82.9,
        132, 130.9, 118.1, 89.9, 66.6, 60, 46.9, 41, 21.3, 16,
        6.4, 4.1, 6.8, 14.5, 34, 45, 43.1, 47.5, 42.2, 28.1, 10.1,
        8.1, 2.5, 0, 1.4, 5, 12.2, 13.9, 35.4, 45.8, 41.1, 30.4)

load("ts.rda")

library(forecast)

library(tseries)

data(camp)
ts <- camp

## ts - time series, p - AR order, q - MA order
madlib.arima <- function (ts, p, d, q, include.mean = TRUE, max.iter = 100,
                          tau = 1e-3, e1 = 1e-15, e2 = 1e-15, e3= 1e-15)
{
    if (d > 0) ts <- diff(ts, differences = d)
    if (p != 0) phi <- runif(p, 0, 1)* 0.1
    else phi <- 0
    if (q != 0) theta <- runif(q, 0, 1) * 0.1
    else theta <- 0
    phi = c(-0.0409297771002,-0.0261257143349)
    theta = c(0.00943832585295)

    mn <- if (include.mean) mean(ts) else 0 # mean value, another parameter
    cat("... init: phi = [", paste0(phi, collapse = ", "),
        "], theta = [", paste0(theta, collapse = ", "), "], mean = ",
        mn, "\n")

    z <- get.errors(ts, p, q, phi, theta, include.mean, mn)
    jacob <- get.jacob(ts, p, q, z, phi, theta, include.mean, mn)

    v <- 2
    A <- t(jacob) %*% jacob

    g <- t(jacob) %*% z
    
    mu <- tau * max(diag(A))
    if (sqrt(sum(g^2)) <= e1) return (list(phi = phi, theta = theta, mu = mn))

    stop <- FALSE
    rho <- 0
    for (k in seq_len(max.iter)) {
        while (!stop) {
            ## delta <- solve(A + diag(rep(mu, dim(A)[1]), nrow = dim(A)[1])) %*% g
            delta <- solve(A + diag(mu * diag(A))) %*% g
            
            if (sqrt(sum(delta^2)) <= e2 * (sqrt(sum(phi^2) + sum(theta^2))))
                stop <- TRUE
            else {
                if (p != 0) phi.new <- phi - delta[seq_len(p)]
                else phi.new <- 0
                if (q != 0) theta.new <- theta - delta[seq_len(q) + p]
                else theta.new <- 0
                if (include.mean) mn.new <- mn - delta[p+q+1]
                else mn.new <- mn

                z1 <- get.errors(ts, p, q, phi.new, theta.new, include.mean, mn.new)
                rho <- (sum(z^2) - sum(z1^2)) / (t(delta) %*% (mu*delta + g))
                if (rho > 0) {
                    phi <- phi.new
                    theta <- theta.new
                    mn <- mn.new
                    
                    z <- get.errors(ts, p, q, phi, theta, include.mean, mn)
                    jacob <- get.jacob(ts, p, q, z, phi, theta, include.mean, mn)
                    A <- t(jacob) %*% jacob
                    g <- t(jacob) %*% z
                    if (sqrt(sum(g^2)) <= e1 || sum(phi^2)+sum(theta^2) <= e3) stop <- TRUE
                    v <- 2
                    mu <- mu * max(1/3, 1 - (2*rho - 1)^3)
                    break
                } else {
                    v <- v * 2
                    mu <- mu * v
                }
            }
        }
                
        cat("... iter ", k, ": phi = [", paste0(phi, collapse = ", "),
            "], theta = [", paste0(theta, collapse = ", "), "], mean = ",
            mn, "\n")
        
        if (stop) break
    }

    list(phi = phi, theta = theta, mu = mn, z = z, A = A,
         V = t(jacob) %*% (z %*% t(z)) %*% jacob)
}

## -----------------------------------------------------------------------

## solve for initial time series values
## Set the initial noise for t <= p to be 0 in AR models
## And the time series values for t <= 0 can be solved for.
slv <- function (ts, p, phi)
{
    val <- numeric(0)
    b <- rep(0, p)
    for (i in seq_len(p)) {
        if (i != 1) {
            b[i] <- ts[i] - sum(phi[seq_len(i-1)] * ts[i - seq_len(i-1)])
            tmp <- c(phi[-seq_len(i-1)], rep(0, i-1))
        } else {
            b[i] <- ts[i]
            tmp <- phi
        }
        val <- c(val, tmp)
    }
    rev(as.vector(solve(array(val, dim = c(p,p)), b)))
}

## ------------------------------------------------------------------------

get.errors <- function (ts, p, q, phi, theta, include.mean, mn)
{
    if (include.mean) ts <- ts - mn
    
    z <- rep(0, length(ts))

    ## Initial values of time series needs special care
    ## For AR(p) model, all noise for t <= p are set to
    ## be zero. And one then can solve for time series
    ## values for t <= 0.
    ## This part is repeated in function get.jacob,
    ## in real implementation, we shoud no repeat this calculation
    if (p != 0) {
        init <- slv(ts, p, phi)
        cts <- c(init, ts)
    } else
        cts <- ts

    ## Must compute the noise starting from t = 1
    ## instead of n+1 (n = max(p,q))
    for (i in seq_len(length(ts))) {
        t <- sum(phi * cts[p+i-seq_len(p)]) + sum(theta * (c(rep(0,q), z))[q+i-seq_len(q)])
        z[i] <- ts[i] - t
    }

    z
}

## -----------------------------------------------------------------------

get.jacob <- function (ts, p, q, z, phi, theta, include.mean, mn)
{
    ## n <- max(p, q)

    if (include.mean) {
        ts <- ts - mn
        l <- p + q + 1
    } else
        l <- p + q

    jacob <- array(0, dim = c(length(ts), l))

    cz <- c(rep(0,q), z)

    if (p != 0) {
        init <- slv(ts, p, phi)
        cts <- c(init, ts)
    } else
        cts <- ts

    ## t starts from 1 (the initial time)
    ## In order to get the same result as R, we need to compute
    ## J from t = 1, instead of n+1 (n = max(p, q))
    for (t in seq_len(length(ts))) {
        if (q != 0) {
            tmp <- (rbind(array(0, dim = c(q,l)), jacob))[q+t-seq_len(q),]
            if (is.null(dim(tmp))) tmp <- matrix(tmp, nrow = 1)
        }
        
        if (p != 0 && q != 0) {
            ## When t <= p, the partial derivative of noise over \phi is always 0
            ## because when there are AR terms, the first few noises are set to be
            ## zero (see function slv). So the derivative of a constant is always 0.
            if (t <= p) a <- rep(0, p)
            else a <- -cts[p+t-seq_len(p)] - colSums(matrix(theta * tmp[,seq_len(p)], nrow = q))
        }
        else
            ## when p = 0, a is numeric(0), which is OK
            a <- -cts[p+t-seq_len(p)]
        
        if (q != 0)
            ## include the partial derivative of noise over \theta,
            ## which has already been computed in J for previous t
            b <- -cz[q+t-seq_len(q)] - colSums(matrix(theta * tmp[,seq_len(q)+p], nrow = q))
        else
            ## no \theta terms
            b <- numeric(0)
        
        if (include.mean) {
            ## partial derivative of noise over the mean value
            if (q != 0) extra <- -colSums(matrix(theta * tmp[,l], nrow = q))
            else extra <- 0

            ## When t <= p, there are AR terms, and the noise is always
            ## set to be the constant zero (see function slv),
            ## therefore the partial derivative is always 0
            if (t <= p)
                jacob[t,] <- c(a, b, 0)
            else {
                if (p != 0) jacob[t,] <- c(a, b, -(1 - sum(phi)) + extra)
                else jacob[t,] <- c(a, b, -1+extra)
            }
        } else
            jacob[t,] <- c(a, b)
    }

    jacob
}

## -----------------------------------------------------------------------

include.mean <- T
order <- c(1,1,1)

r <- madlib.arima(ts, order[1], order[2], order[3], include.mean = include.mean, max.iter = 1000, tau = 1e-3, e1 = 1e-15, e2 = 1e-15, e3= 1e-15)

s <- arima(ts, order = order, include.mean = include.mean, method = "CSS", optim.control=list(reltol=1e-10,  abstol=1e-10))
s

s$residuals

mean(r$z^2)*49/48 - s$sigma2

-(length(ts)/2)*(1+log(2*pi*s$sigma2))

s$var.coef

(s$sigma2 / r$A)/s$var.coef

del <- 1e-4 * s$coef[2]

z <- get.errors(ts, 0, 2, 0, c(s$coef[1],s$coef[2]), T, s$coef[3])
z_1 <- get.errors(ts, 0, 2, 0, c(s$coef[1],s$coef[2]-del), T, s$coef[3])
z1 <- get.errors(ts, 0, 2, 0, c(s$coef[1],s$coef[2]+del), T, s$coef[3])

h <- (t(z1)%*%z1 - 2*(t(z)%*%z) + t(z_1)%*%z_1)/(del^2)

sqrt(2 * s$sigma2/h)

sqrt(s$var.coef)


## ----------------------------------------------------------------------

library(PivotalR)
db.connect(port=14526, dbname="madlib")

ts <- arima.sim(list(order = c(2,0,1), ar = c(0.7, -0.3), ma=0.2), n = 1000000) + 3.2

dat <- data.frame(tid=1:length(ts), tval=ts)

delete("tseries")
x <- as.db.data.frame(dat, "tseries", field.types=list(tid="integer", tval="double precision"))

include.mean <- T
order <- c(1,0,2)

s <- arima(ts, order = order, include.mean = include.mean, method = "CSS")
s

s$residuals[1:10]

system.time(arima(ts, order = order, include.mean = include.mean, method = "CSS"))

s$residuals[1:10]

r <- madlib.arima(ts, order[1], order[2], order[3], include.mean = include.mean, max.iter = 1000, tau = 1e-3, e1 = 1e-15, e2 = 1e-15, e3= 1e-15)
