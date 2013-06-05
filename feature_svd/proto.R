## ------------------------------------------------------------------------
## prototype R script for BPRO algorithm
## ------------------------------------------------------------------------

## BPRO SVD prototype

## normalization of a vector
normalize <- function (v)
{
    len <- sqrt(sum(v*v))
    if (len != 0)
        list(mod = len, vec = v/len)
    else
        list(mod = 0, vec = v)
}

## A : The matrix to be decomposed
## k : How many eigenvalues to keep
bpro <- function (A, k)
{
    ## extract some info
    m <- nrow(A)
    n <- ncol(A)

    ## initialize the data structure
    beta <- rep(0, k+1)
    alpha <- rep(0, k)
    u <- array(0, dim = c(k + 1, m))
    v <- array(0, dim = c(k + 1, n))
    
    ## Choose a random vector as the starting point
    p <- rnorm(m, 0, 1)
    norm <- normalize(p)
    u[1,] <- norm$vec
    beta[1] <- norm$mod
    v[1,] <- rep(0, n)

    ## Lanzcos iterations
    for (j in seq_len(k))
    {
        r <- t(A) %*% u[j,] - beta[j] * v[j,]
        for (i in seq_len(j-1)) r <- r - sum(r * v[i+1,]) * v[i+1,]
        norm <- normalize(r)
        alpha[j] <- norm$mod
        v[j+1,] <- norm$vec
        ##
        p <- A %*% v[j+1,] - alpha[j] * u[j,]
        for (i in seq_len(j)) p <- p - sum(p * u[i,]) * u[i,]
        norm <- normalize(p)
        beta[j+1] <- norm$mod
        u[j+1,] <- norm$vec        
    }

    list(u = u, v = v[2:(k+1),], alpha = alpha, beta = beta)
}

a = matrix(1:6, nrow = 3)

a

s <- svd(a)

s

s$u %*% diag(s$d) %*% t(s$v)

p <- bpro(a, 2)

p
