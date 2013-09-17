library(PivotalR)

library(Matrix)

db.connect(port = 14526, dbname = "madlib")

x <- db.data.frame("madlibtestdata.pca_mat_600_100")
x <- db.data.frame("madlibtestdata.res_example")
x <- db.data.frame("s_m")


y <- lookat(sort(x, FALSE, x$row_id), "all")

r <- svd(y[,-1])

r$d

mean((y[,-1] - r$u %*% diag(r$d) %*% t(r$v))^2)

s <- lanczos(as.matrix(y[,-1]), 24)

s$s

## ------------------------------------------------------------------------

y <- lookat(sort(x, FALSE, x[,]), "all")
y[is.na(y$value),]
y <- na.omit(y)

sparse.x <- sparseMatrix(i = y[['row_id']], j = y[['col_id']], x = y[['value']], dims = c(64067,24), index1 = FALSE)

dense.x <- as.matrix(sparse.x)

r <- svd(dense.x)

r$d

mean((dense.x - r$u %*% diag(r$d) %*% t(r$v))^2)

eigen(dense.x)

r$u[1:10,1:10]

s <- lanczos(dense.x, 24)

s$s

t(s$u) %*% s$u


mean((dense.x - s$u %*% diag(s$s) %*% t(s$v))^2)


## ------------------------------------------------------------------------

m <- array(rnorm(400), dim = c(20, 20))

r <- svd(m)

r$d

e <- eigen(t(m) %*% m)

e$values

Y <- as.data.frame(dense.x)
Y$row_id <- as.integer(1:(dim(Y)[1]) - 1)
delete("r_m")
y <- as.db.data.frame(Y, "r_m")

z <- y$row_id
z$row_vec <- rowAgg(y[,-25])

names(z)

delete("s_m")
q <- as.db.data.frame(z, "s_m")


