library(R.matlab)

imgs <- readMat("../IMAGES.mat")[[1]]

dim(imgs)

image(t(imgs[512:1,,5]))

# ------------------------------------------------------------------------

sample.imgs <- function ()
{
    library(R.matlab)
    imgs <- readMat("../IMAGES.mat")[[1]]
    patch.size <- 8
    num.patches <- 10000
    patches <- array(0, dim = c(patch.size, patch.size, num.patches))

    img.idx <- sample(seq(dim(imgs)[3]), num.patches, replace = TRUE)
    x.idx <- sample(seq(0, dim(imgs)[1]-patch.size), num.patches,
                    replace = TRUE)
    y.idx <- sample(seq(0, dim(imgs)[2]-patch.size), num.patches,
                    replace = TRUE)

    for (i in seq_len(num.patches))
        patches[,,i] <- imgs[x.idx[i]+seq(patch.size),
                             y.idx[i]+seq(patch.size),
                             img.idx[i]]
    normalize.data(patches)
}

## ------------------------------------------------------------------------

normalize.data <- function (patches)
{
    patches <- patches - mean(patches)
    pstd <- 3 * sd(patches)
    ## patches <- max(min(patches, pstd), -pstd) / pstd
    patches[patches > pstd] <- pstd
    patches[patches < -pstd] <- -pstd
    patches <- (patches/pstd + 1) * 0.4 + 0.1
}

## ------------------------------------------------------------------------

sm <- sample.imgs()

dim(sm)

system.time(sample.imgs())

max(sm)

min(sm)
