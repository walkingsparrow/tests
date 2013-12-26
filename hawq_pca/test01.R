## generate data set for PCA performance tests

library(PivotalR)
db.connect(port = 14526, dbname = "madlib")

db.connect(port = 5433, dbname = "madlib")

x <- db.data.frame("madlibtestdata.pca_mat_600_100", 2)

y <- lookat(sort(x, F, x$row_id), "all")

y <- as.data.frame(cbind(id = 1:1000-1, matrix(rnorm(1000000), 1000)))

dim(y)

w <- as.db.data.frame(y)

v <- w$id
v$val <- db.array(w[,-1])
names(v) <- c("row_id", "row_vec")

delete("pca_mat_1000_1000")
as.db.data.frame(v, "pca_mat_1000_1000", field.types = list(row_id = "integer", row_vec = "double precision[]"))

dat <- as.matrix(y[,-1])

## dat <- scale(dat, center = TRUE, scale = FALSE)

r <- prcomp(y, center = TRUE, scale. = FALSE)

pred <- predict(r, dat)

## ----------------------------------------------------------------------

library(PivotalR)
db.connect(port = 14526, dbname = "madlib")

i <- sample(1:100000-1, 1000)
j <- sample(1:100000-1, 1000)
v <- rnorm(1000)

as.db.data.frame(data.frame(rid = i, cid = j, val = v), "pca_sparse", field.types = list(rid = "integer", cid = "integer", val = "double precision"))
