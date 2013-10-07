library(PivotalR)

db.connect(host = "dca1-mdw1.dan.dh.greenplum.com", user = "gpadmin",
          password = "changeme", dbname = "dstraining")

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

dat <- db.data.frame("pca_mat_2000_1000")

q <- pca(dat[,-1])

q$val[1:10]

system.time(pca(dat[,-1]))

r <- prcomp(lookat(dat, "all")[,-1])

r$sdev[1:10]
