library(PivotalR)
db.connect(port = 16526, dbname = "madlib")

dat <- lk("madlibtestdata.km_abalone", -1)

dat[1:10,]

km <- kmeans(dat[,2], 6)

library(flexclust)

km1 <- kcca(dat[,2], 6)

sk <- summary(km1)

s <- Silhouette(km1, data = dat[,2])

s

sl <- c(0.3640527, 0.3695775, 0.4220780, 0.4679753, 0.5799402, 0.4349790)
size <- s@size

sum(sl*size)/sum(size)

## ----------------------------------------------------------------------

library(cluster)

km2 <- as(km1, "kmeans")

silhouette(km2)

silhouette(km)

km0 <- pam(dat[,2], 6)

km0

s <- silhouette(km0)

mean(s[,3])
