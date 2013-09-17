library(PivotalR)

args <- c(10000, 100)

dim_x <- as.integer(args[1])
dim_y <- as.integer(args[2])
k <- min(args[1], args[2])

m <- matrix(rexp(dim_x * k, .1), dim_x)
u <- qr.Q(qr(m))

n <- matrix(rexp(dim_y * k, .1), dim_y)
v <- qr.Q(qr(n))

s <- diag(sort(rexp(k, .1), decreasing = TRUE), k, k)

x <- u %*% s %*% t(v)

## ------------------------------------------------------------------------

db.connect(port = 5432, dbname = "madlib_test")

x <- db.data.frame("scale_10000_1600")
y <- lookat(sort(x, FALSE, x$row_id), "all")
z <- as.matrix(y[,-1])
dim(z)

system.time(svd(z))

r <- svd(z)

mean((z - r$u %*% diag(r$d) %*% t(r$v))^2)

## ------------------------------------------------------------------------

s <- c(1,2,4,8)
r <- c(0.71, 1.8, 6.17, 24.18)
m <- c(35.17, 58.5, 83.6, 182.1)

## ------------------------------------------------------------------------

library(PivotalR)

db.connect(port = 5432, dbname = "madlib_test")

dims <- matrix(c(10000, 3200, 10000, 6400, 20000, 6400, 40000, 6400, 80000, 6400, 160000, 6400), )

for (i in c(3200, 6400))
