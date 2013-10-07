library(PivotalR)

db.connect(port = 14526, dbname = "madlib")

x <- db.data.frame("madlibtestdata.dt_abalone")

X <- db.array(1, x[,-c(1,2,10)])

a <- crossprod(X)

b <- crossprod(X, x$rings)

lookat(a)

lookat(b)

solve(lookat(a)) %*% lookat(b)

madlib.lm(rings ~ . - id - sex, data = x)

w <- as.matrix(cbind(1, abalone[,-c(1,2,10)]))
v <- abalone$rings

t(w) %*% w

t(w) %*% v

solve(t(w) %*% w) %*% (t(w) %*% v)

## ----------------------------------------------------------------------

pca <- function (x, center = TRUE, scale = FALSE)
{
    y <- scale(x, center = center, scale = scale) # centering and scaling
    z <- as.db.data.frame(y, verbose = FALSE) # create an intermediate table to save computation
    m <- lookat(crossprod(z)) # one scan of the table to compute Z^T * Z
    d <- delete(z) # delete the intermediate table
    res <- eigen(m) # only this computation is in R
    n <- attr(y, "row.number") # save the computation to count rows
     
    ## return the result
    list(val = sqrt(res$values/(n-1)), # eigenvalues
         vec = res$vectors, # columns of this matrix are eigenvectors
         center = attr(y, "scaled:center"),
         scale = attr(y, "scaled:scale"))
}

dat <- db.data.frame("madlibtestdata.pca_mat_200_200")

q <- pca(dat[,-1])

q$val

r <- prcomp(lookat(dat, "all")[,-1])

r$sdev

system.time(pca(dat[,-1]))

