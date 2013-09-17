
library(PivotalR)
db.connect(port = 14526, dbname = "madlib")

x <- db.data.frame("madlibtestdata.pca_mat_600_100")

y <- lookat(sort(x, F, x$row_id), "all")

dat <- as.matrix(y[,-1])

## dat <- scale(dat, center = TRUE, scale = FALSE)

r <- prcomp(dat, center = TRUE, scale. = FALSE)

pred <- predict(r, dat)

f <- t(pred) %*% pred

(r$sdev)[1:100]

s <- svd(scale(dat, center = TRUE, scale = FALSE))

s$d

as.vector(r$rotation[,1])

v <- scale(dat, center = TRUE, scale = FALSE)

s1 <- svd(t(v) %*% v)

s1$d
