## generate data set for kmeans

## require(graphics)

## a 2-dimensional example
n <- 10000
x <- rbind(matrix(rnorm(n, sd = 0.3), ncol = 2),
           matrix(rnorm(n, mean = 1, sd = 0.3), ncol = 2),
           matrix(c(rnorm(n/2, sd=0.3), rnorm(n/2, mean=1.5, sd=0.3)), ncol=2))
colnames(x) <- c("x", "y")
cl <- kmeans(x, 3)

plot(x, col = cl$cluster)
points(cl$centers, col = 1:3, pch = 8, cex = 2)

dim(x)

library(PivotalR)
db.connect(port = 16526, dbname = "madlib")

y <- as.db.data.frame(as.data.frame(x))

w <- db.array(y)
names(w) <- "point"

delete("kmeans", cascade = TRUE)

as.db.data.frame(w, "madlibtestdata.km_rgenerated3_1e4")

## ## ----------------------------------------------------------------------

library(PivotalR)
db.connect(port = 16526, dbname = "madlib")

dat <- lk("madlibtestdata.km_rgenerated3_1e4", -1)

## dat <- read.csv("km_rgenerated3.csv", header = FALSE)

cl <- kmeans(dat, 3)

plot(dat, col = cl$cluster, cex = 0.1)
points(cl$centers, col = 1:3, pch = 8, cex = 2)


## ----------------------------------------------------------------------

## compute the simple silhouette
## both x and cen are stored row-wised
simple.silhouette <- function(x, cen, dist)
{
    mean(sapply(
        seq_len(nrow(x)),
        function(i) {
            d <- sapply(seq_len(nrow(cen)), function(j) dist(x[i,], cen[j,]))
            or.d <- order(d)
            d1 <- d[or.d[1]]
            d2 <- d[or.d[2]]
            if (d2 == 0) 0 else (d2 - d1)/d2
        }))
}

## ----------------------------------------------------------------------

names(cl)

cl$centers

cl <- kmeans(dat, 3)

simple.silhouette(dat, cl$centers, function(x, y) sqrt(sum((x-y)^2)))

simple.silhouette(dat, cl$centers, function(x, y) sum((x-y)^2))
