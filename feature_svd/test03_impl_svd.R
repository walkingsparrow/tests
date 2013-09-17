## implement SVD Lanczos using R

norm.vec <- function (x) {
    sqrt(sum(x^2))
}

reorth <- function (mat) {
    n <- ncol(mat)
    q <- mat[,n]
    for (i in seq_len(n-1)) {
        q <- q - sum(mat[,i] * q) * mat[,i] / sum(mat[,i]^2)
    }
    mat[,n] <- q
    mat
}

lanczos <- function (mat, iter)
{
    m <- nrow(mat)
    n <- ncol(mat)
    P <- array(0, dim = c(m, iter))
    Q <- array(0, dim = c(n, iter + 1))
    a <- rep(0, iter)
    b <- rep(0, iter + 1)

    q1 <- rnorm(n)
    ## q1 <- c(1, rep(0, n-1))
    Q[,1] <- q1 / norm.vec(q1)

    for (i in 1:iter) {
        if (i == 1)
            P[,i] <- mat %*% Q[,1]
        else
            P[,i] <- mat %*% Q[,i] - b[i] * P[,i-1]
        ## if (i == 1) print(P[1:3,1])
        a[i] <- norm.vec(P[,i])
        P[,i] <- P[,i] / a[i]
        Q[,i+1] <- t(mat) %*% P[,i] - a[i] * Q[,i]
    
        Q[,1:(i+1)] <- reorth(Q[,1:(i+1)])
        b[i+1] <- norm.vec(Q[,i+1])
        Q[,i+1] <- Q[,i+1] / b[i+1]

        ## if (i == 1) {
        ##     print(P[1:20,1])
        ##     print(Q[,2])
        ## }
    }
    
    fP <- P
    fQ <- Q[,1:iter]

    B <- diag(a)
    for (i in 2:iter) B[i-1,i] <- b[i]

    r <- svd(B)
    U <- fP %*% r$u
    V <- fQ %*% r$v
    s <- r$d

    list(u = U, v = V, s = s)
}

## ------------------------------------------------------------------------

mat <- array(rnorm(400), dim = c(20, 20))

mat <- t(mat) %*% mat

r <- svd(mat)

r$d

s <- lanczos(mat, 20)

s$s

## ------------------------------------------------------------------------

library(PivotalR)

db.connect(port = 14526, dbname = "madlib")

x <- db.data.frame("madlibtestdata.pca_mat_600_100")

y <- lookat(sort(x, FALSE, x$row_id), "all")

r <- svd(y[,-1])

r$d[1:20]

s <- lanczos(as.matrix(y[,-1]), 30)

s$s
