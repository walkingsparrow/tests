
library(PivotalR)
db.connect(port = 16526, dbname = "madlib")

source("~/workspace/madlib_testsuite/tests/kmeans/expected_output/utils.R")

dat <- lk("madlibtestdata.km_abalone", -1)
dat <- dat[[2]]

dist.kmeans <- dist_tanimoto
cent <- normalized_avg
k <- 6

kf <- kccaFamily(dist = dist.kmeans, cent = cent)

res <- kcca(dat, k = k, family = kf) # kmeans computation is here

simple.silhouette(dat, slot(res, "centers"), dist.kmeans)

library(parallel)

cl <- makeCluster(getOption("cl.cores", 5)) # use 5 cores

sil <- parSapply(
    cl,
    1:200, # run 40 times kmeans
    function(i, dist.kmeans, cent, dat, k, simple.silhouette) {
        suppressMessages(library(flexclust)) # load the library on each core
        kf <- kccaFamily(dist = dist.kmeans, cent = cent) # set the dist and average
        res <- kcca(dat, k, family = kf) # kmeans
        simple.silhouette(dat, slot(res, "centers"), dist.kmeans) # metric
    }, dist.kmeans, cent, dat, k, simple.silhouette)

sil1 <- unique(sil)

sil1

hist(sil, 100)

## ----------------------------------------------------------------------

dat <- lk("madlibtestdata.km_rgenerated3_1e4", "all")

dim(dat)

dist.kmeans <- dist_norm1
cent <- normalized_avg
k <- 3

kf <- kccaFamily(dist = dist.kmeans, cent = cent)

res <- kcca(dat, k = k, family = kf) # kmeans computation is here

simple.silhouette(dat, slot(res, "centers"), dist.kmeans)

library(parallel)

cl <- makeCluster(getOption("cl.cores", 5)) # use 5 cores

sil <- parSapply(
    cl,
    1:200, # run 40 times kmeans
    function(i, dist.kmeans, cent, dat, k, simple.silhouette) {
        suppressMessages(library(flexclust)) # load the library on each core
        kf <- kccaFamily(dist = dist.kmeans, cent = cent) # set the dist and average
        res <- kcca(dat, k, family = kf) # kmeans
        simple.silhouette(dat, slot(res, "centers"), dist.kmeans) # metric
    }, dist.kmeans, cent, dat, k, simple.silhouette)

sil1 <- unique(sil)

sil1

hist(sil)
