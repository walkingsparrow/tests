## prototype fo ARIMA

ts <- c(100.8, 81.6, 66.5, 34.8, 30.6, 7, 19.8, 92.5,
        154.4, 125.9, 84.8, 68.1, 38.5, 22.8, 10.2, 24.1, 82.9,
        132, 130.9, 118.1, 89.9, 66.6, 60, 46.9, 41, 21.3, 16,
        6.4, 4.1, 6.8, 14.5, 34, 45, 43.1, 47.5, 42.2, 28.1, 10.1,
        8.1, 2.5, 0, 1.4, 5, 12.2, 13.9, 35.4, 45.8, 41.1, 30.4)

## ts - time series, p - AR order, q - MA order
madlib.arima <- function (ts, p, d, q, include.mean = TRUE, max.iter = 100,
                          tau = 1e-3, e1 = 1e-15, e2 = 1e-15, e3= 1e-15)
{
    if (d > 0) ts <- diff(ts, differences = d)
    if (p != 0) phi <- runif(p, 0, 1)
    else phi <- 0
    if (q != 0) theta <- runif(q, 0, 1)
    else theta <- 0
    ## theta <- 0.5
    mn = if (include.mean) mean(ts) else 0 # mean value, another parameter
    cat("... init: phi = [", paste0(phi, collapse = ", "),
        "], theta = [", paste0(theta, collapse = ", "), "], mean = ",
        mn, "\n")

    ts <- ts - mn
    ## z0 <- rnorm(length(ts) - max(p,q)) 
    z <- get.errors(ts, p, q, phi, theta)
    jacob <- get.jacob(ts, p, q, z)

    v <- 2
    A <- t(jacob) %*% jacob
    g <- t(jacob) %*% z
    mu <- tau * max(diag(A))
    if (sqrt(sum(g^2)) <= e1) return (list(phi = phi, theta = theta, mu = mn))

    stop1 <- FALSE
    ## stop2 <- FALSE
    rho <- 0
    for (k in seq_len(max.iter)) {
        ## z0 <- z
        while (!stop1) {
            delta <- solve(A + diag(rep(mu, dim(A)[1]), nrow = dim(A)[1])) %*% g
            if (sqrt(sum(delta^2)) <= e2 * (sqrt(sum(phi^2) + sum(theta^2)))) {
                stop1 <- TRUE
            } else {
                if (p != 0) phi.new <- phi - delta[seq_len(p)]
                else phi.new <- 0
                if (q != 0) theta.new <- theta - delta[seq_len(q)+p]
                else theta.new <- 0
                z1 <- get.errors(ts, p, q, phi.new, theta.new)
                rho <- (sum(z^2) - sum(z1^2)) / (t(delta) %*% (mu*delta + g))
                print(rho)
                if (rho > 0) {
                    phi <- phi.new
                    theta <- theta.new
                    ## z <- get.errors(ts, p, q, phi, theta)
                    ## z0 <- z
                    z <- z1
                    jacob <- get.jacob(ts, p, q, z)
                    A <- t(jacob) %*% jacob
                    g <- t(jacob) %*% z
                    if (sqrt(sum(g^2)) <= e1 || sum(phi^2)+sum(theta^2) <= e3) stop1 <- TRUE
                    v <- 2
                    mu <- mu * max(1/3, 1 - (2*rho - 1)^3)
                    break
                } else {
                    v <- v * 2
                    mu <- mu * v
                }
            }
        }

        ## z <- get.errors(ts, p, q, phi, theta)
        ## jacob <- get.jacob(ts, p, q, z0)
        ## A <- t(jacob) %*% jacob
        ## g <- t(jacob) %*% z
        ## mu <- tau * max(diag(A))
        ## if (sqrt(sum(g^2)) <= e1) return (list(phi = phi, theta = theta, mu = mn))
        ## rho <- (sum(z^2) - sum(z1^2)) / (t(delta) %*% (mu*delta + g))
        ## if (rho > 0) {
            ## if (sqrt(sum(g^2)) <= e1 || sum(phi^2)+sum(theta^2) <= e3) stop2 <- TRUE
        ## } else
        ## stop1 <- FALSE
                
        cat("... iter ", k, ": phi = [", paste0(phi, collapse = ", "),
            "], theta = [", paste0(theta, collapse = ", "), "], mean = ",
            mn, "\n")

        if (stop1) break
    }

    list(phi = phi, theta = theta, mu = mn)
}

## ------------------------------------------------------------------------

get.errors <- function (ts, p, q, phi, theta, z0 = NULL)
{
    n <- max(p, q)
    z <- rep(0, length(ts) - n)
    for (i in seq_len(length(ts)-n)+n) {
        if (!is.null(z0)) cz <- c(rep(0,n), z0)
        else cz <- c(rep(0,n), z)
        t <- sum(phi * ts[i - seq_len(p)]) + sum(theta * cz[i - seq_len(q)])
        z[i-n] <- ts[i] - t
    }
    z
}

## ------------------------------------------------------------------------

get.jacob <- function (ts, p, q, z)
{
    n <- max(p, q)
    jacob <- array(0, dim = c(length(ts) - n, p + q))
    cz <- c(rep(0,n), z)
    for (i in seq_len(length(ts)-n)+n)
        jacob[i-n,] <- c(-ts[i-seq_len(p)], -cz[i-seq_len(q)])
    jacob
}

## ------------------------------------------------------------------------

r <- madlib.arima(ts - mean(ts), 1, 0, 0, include.mean = FALSE, max.iter = 40, tau = 1e-4, e1 = 1e-8, e2 = 1e-8, e3= 1e-8)

arima(ts - mean(ts), order = c(1,0,0), include.mean = FALSE, method = "CSS")

r$jacob

r$z

t(r$jacob) %*% r$z

A <- array(c(76214.54, 26794.01, 26794.01, 17099.58), dim = c(2,2))
g <- array(c(-10414.93, -9073.75), dim = c(2,1))

mu <- 1e-3 * max(diag(A))

solve(A + diag(rep(mu, dim(A)[1]))) %*% g

