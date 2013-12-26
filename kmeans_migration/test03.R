## generate data set for kmeans

require(graphics)

## a 2-dimensional example
n <- 100000
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

as.db.data.frame(w, "madlibtestdata.km_rgenerated3")

## ----------------------------------------------------------------------

dat <- lk("madlibtestdata.km_rgenerated3", -1)

## ----------------------------------------------------------------------

simple.silhouette <- function()
