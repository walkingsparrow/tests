## prototype fo ARIMA

## use previous J for computation

library(tseries)
data(camp)
ts <- camp

## ts - time series, p - AR order, q - MA order
madlib.arima <- function (ts, p, d, q, include.mean = TRUE, max.iter = 100,
                          tau = 1e-3, e1 = 1e-15, e2 = 1e-15, e3= 1e-15)
{
    if (d > 0) ts <- diff(ts, differences = d)
    if (p != 0) phi <- runif(p, 0, 1) * 0.01
    else phi <- 0
    if (q != 0) theta <- runif(q, 0, 1) * 0.01
    else theta <- 0
    mn = if (include.mean) mean(ts) else 0 # mean value, another parameter
    cat("... init: phi = [", paste0(phi, collapse = ", "),
        "], theta = [", paste0(theta, collapse = ", "), "], mean = ",
        mn, "\n")

    ts <- ts - mn
    z <- get.errors(ts, p, q, phi, theta)
    jacob <- get.jacob(ts, p, q, z, theta)

    v <- 2
    A <- t(jacob) %*% jacob
    g <- t(jacob) %*% z
    
    mu <- tau * max(diag(A))
    if (sqrt(sum(g^2)) <= e1) return (list(phi = phi, theta = theta, mu = mn))

    stop <- FALSE
    rho <- 0
    for (k in seq_len(max.iter)) {
        while (!stop) {
            delta <- solve(A + diag(rep(mu, dim(A)[1]), nrow = dim(A)[1])) %*% g
            
            if (sqrt(sum(delta^2)) <= e2 * (sqrt(sum(phi^2) + sum(theta^2))))
                stop <- TRUE
            else {
                if (p != 0) phi.new <- phi - delta[seq_len(p)]
                else phi.new <- 0
                if (q != 0) theta.new <- theta - delta[seq_len(q) + p]
                else theta.new <- 0
                z1 <- get.errors(ts, p, q, phi.new, theta.new)
                rho <- (sum(z^2) - sum(z1^2)) / (t(delta) %*% (mu*delta + g))
                if (rho > 0) {
                    phi <- phi.new
                    theta <- theta.new
                    z <- get.errors(ts, p, q, phi, theta)
                    jacob <- get.jacob(ts, p, q, z, theta)
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

    list(phi = phi, theta = theta, mu = mn)
}

## ------------------------------------------------------------------------

get.errors <- function (ts, p, q, phi, theta)
{
    n <- max(p, q)
    z <- rep(0, length(ts) - n)
    for (i in seq_len(length(ts)-n)+n) {
        t <- sum(phi * ts[i - seq_len(p)]) + sum(theta * (c(rep(0,n), z))[i - seq_len(q)])
        z[i-n] <- ts[i] - t
    }
    z
}

## ------------------------------------------------------------------------

get.jacob <- function (ts, p, q, z, theta)
{
    n <- max(p, q)
    jacob <- array(0, dim = c(length(ts) - n, p + q))
    cz <- c(rep(0,n), z)
    for (i in seq_len(length(ts)-n)+n) {
        tmp <- (rbind(array(0, dim = c(n,p+q)), jacob))[i - seq_len(q),]
        if (is.null(dim(tmp))) tmp <- matrix(tmp, nrow = 1)
        if (p != 0 && q != 0) a <- -ts[i-seq_len(p)] - colSums(matrix(theta * tmp[,seq_len(p)], nrow = q))
        else a <- -ts[i-seq_len(p)]
        if (q != 0) b <- -cz[i-seq_len(q)] - colSums(matrix(theta * tmp[,seq_len(q)+p], nrow = q))
        else b <- -cz[i-seq_len(q)]
        jacob[i-n,] <- c(a, b)                         
    }
    jacob
}

## ------------------------------------------------------------------------

r <- madlib.arima(ts - mean(ts), 1, 0, 1, include.mean = FALSE, max.iter = 100, tau = 1e-3, e1 = 1e-6, e2 = 1e-6, e3= 1e-6)

arima(ts - mean(ts), order = c(1,0,1), include.mean = FALSE, method = "CSS")
