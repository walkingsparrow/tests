library(PivotalR)

library(Matrix)

db.connect(port = 14526, dbname = "madlib")

x <- db.data.frame("res_example")
## x <- db.data.frame("mat")

y <- lookat(sort(x, FALSE, x[,]), "all")
y[is.na(y$value),]
y <- na.omit(y)

sparse.x <- sparseMatrix(i = x[['row_id']], j = x[['col_id']],
                         x = x[['value']], dims = c(64067,24), index1 = FALSE)

dense.x <- as.matrix(sparse.x)

r <- svd(dense.x)

r$d

mean((dense.x - r$u %*% diag(r$d) %*% t(r$v))^2)

eigen(dense.x)

r$u[1:10,1:10]

## ------------------------------------------------------------------------

x <- db.data.frame("pca_mat_600_100")
## x <- db.data.frame("mat")

y <- lookat(sort(x, FALSE, x$row_id), "all")

m <- as.matrix(y[,-1])

r <- svd(m, 10, 10)

r$d[1:10]

mean((y - r$u %*% diag(r$d) %*% t(r$v))^2)

eigen(dense.x)

r$u[1:10,1:10]



## ------------------------------------------------------------------------




dim(x)

names(x)

dat <- lookat(sort(x, FALSE, x$row_id), "all")

dim(dat)

names(dat)

dat[1:10, 1:11]

m <- as.matrix(dat[,-1])

dim(m)

m

k <- 10
r <- svd(m, k, k)

r$u[1:10,]

r$d[1:10]

mean((m - r$u %*% diag(r$d[1:k]) %*% t(r$v))^2)

r$d[1:10]

m1 <- t(m) %*% m

r <- svd(m1)

mean((m1 - r$u %*% diag(r$d) %*% t(r$v))^2)

r$d[1:10]

## r1 <- svd(m)

## r$d

## r1$d

## dim(r$u)

## dim(r1$u)

## r$u - r1$u[,1:10]

## for (tbl in db.objects("*__madlib_temp_*")) delete(tbl)

## -----------------------------------------------------------------------
hilbert <- function(n) { i <- 1:n; 1 / outer(i - 1, i, "+") }

X <- hilbert(100)[, 1:100]

dim(X)

s <- svd(X, 10, 10)

max(abs(X - s$u %*% diag(s$d) %*% t(s$v)))

Y <- as.data.frame(X)
Y$row_id <- as.integer(1:100 - 1)

names(Y)

delete("r_m")
y <- as.db.data.frame(Y, "r_m")

names(y)

z <- y$row_id
z$row_vec <- rowAgg(y[,-101])

names(z)

delete("s_m")
q <- as.db.data.frame(z, "s_m")

s$d[1:10]

mean((X - s$u %*% diag(s$d[1:10]) %*% t(s$v))^2)

## ------------------------------------------------------------------------
args <- c(100, 100)

dim_x <- as.integer(args[1])
dim_y <- as.integer(args[2])
k <- min(args[1], args[2])

m <- matrix(rexp(dim_x * dim_x, .1), dim_x)
u <- qr.Q(qr(m))

n <- matrix(rexp(dim_y * dim_y, .1), dim_y)
v <- qr.Q(qr(n))

s <- diag(sort(rexp(k, .1), decreasing = TRUE), dim_x, dim_y)

x <- u %*% s %*% t(v) 

dim(x)

r <- svd(x, 10, 10)

r$d


Y <- as.data.frame(x)
Y$row_id <- as.integer(1:100 - 1)
delete("r_m")
y <- as.db.data.frame(Y, "r_m")

z <- y$row_id
z$row_vec <- rowAgg(y[,-101])

names(z)

delete("s_m")
q <- as.db.data.frame(z, "s_m")

