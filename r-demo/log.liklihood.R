
log.likelihood <- function(x, y, coef, a0, lambda, alpha, scaling = FALSE)
{
    s <- 0
    for (i in seq(length(y)))
    {
        t <- sum(coef * x[i,]) + a0 - y[i]
        s <- s + 0.5 * t^2
    }
    s <- s / length(y)
    if (!scaling)
    {
        s <- s + 0.5 * lambda * (1 - alpha) * sum(coef * coef) + lambda * alpha * sum(abs(coef))
    }
    else
    {
        xsd <- apply(x, 2, sd) * sqrt(1 - 1./length(y))
        s <- s + 0.5 * lambda * (1- alpha) * sum((coef * xsd)^2) + lambda * alpha * sum(abs(coef * xsd))
    }
    ##
    as.numeric(-s)
}

## ----------------------------------------------------------------------

log.likelihood2 <- function(x, y, coef, a0, lambda, alpha, scaling = FALSE)
{
    s <- 0
    for (i in seq(length(y)))
    {
        t <- sum(coef * x[i,]) + a0
        if (y[i] == TRUE)
            s <- s + log(1 + exp(-t))
        else
            s <- s + log(1 + exp(t))
    }
    s <- s / length(y)
    if (!scaling)
    {
        s <- s + 0.5 * lambda * (1 - alpha) * sum(coef * coef) + lambda * alpha * sum(abs(coef))
    }
    else
    {
        xsd <- apply(x, 2, sd) * sqrt(1 - 1./length(y))
        s <- s + 0.5 * lambda * (1- alpha) * sum((coef * xsd)^2) + lambda * alpha * sum(abs(coef * xsd))
    }
    as.numeric(-s)
}
