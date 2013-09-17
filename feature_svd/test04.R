x <- matrix(rnorm(9), nrow = 3, ncol = 3, byrow = TRUE)

x <- scale(x, center = T, scale = F)

x <- x %*% t(x)

r <- svd(x)

r$d

r$u

r$u %*% t(r$u)

r$v %*% t(r$v)

s <- lanczos(x, 3)

s$s

s$u

s$v

library(PivotalR)

db.connect(port = 14526, dbname = "madlib")

y <- as.data.frame(x)
y$row_id <- 0:2

delete("tmp_y")
z <- as.db.data.frame(y, "tmp_y")

w <- z$row_id
w$row_vec <- rowAgg(z[,-4])

delete("tmp_w")
v <- as.db.data.frame(w, "tmp_w")

## ------------------------------------------------------------------------

library(irlba)

r <- irlba(x, nu = 1, nv = 1, adjust = 1)

## ------------------------------------------------------------------------

m <- matrix(rexp(4 * 4, .1), 4)
u <- qr.Q(qr(m))

n <- matrix(rexp(4 * 4, .1), 4)
v <- qr.Q(qr(n))

s <- c(4,2,2,1)

x <- u %*% diag(s) %*% t(v)

x <- t(x) %*% x

r <- svd(x)

r$d

r$u

library(PivotalR)

db.connect(port = 14526, dbname = "madlib")

y <- as.data.frame(x)
y$row_id <- 0:3

delete("tmp_y")
z <- as.db.data.frame(y, "tmp_y")

w <- z$row_id
w$row_vec <- rowAgg(z[,-5])

delete("tmp_w")
v <- as.db.data.frame(w, "tmp_w")
