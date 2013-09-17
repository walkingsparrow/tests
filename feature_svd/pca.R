library(PivotalR)
db.connect(port = 14526, dbname = "madlib")

dat <- db.data.frame("madlibtestdata.pca_mat_200_200")

## a <- array(rnorm(1000*2000), dim = c(2000, 1000))

## dat <- as.db.data.frame(as.data.frame(a))

## ----------------------------------------------------------------------

## mat <- lookat(sort(dat, FALSE, dat$row_id), "all")[,-c(1)]

mat <- lookat(dat, "all")

dim(mat)

p <- prcomp(mat)

names(p)

p$sdev

p$center

## ------------------------------------------------------------------------

pca <- function (x, center = TRUE, scale = FALSE)
{
    ## computation in database in parallel
    y <- scale(x, center = center, scale = scale)
    z <- as.db.data.frame(y, verbose = FALSE)
    m <- lookat(crossprod(z)) # one scan of the table
    d <- delete(z)
    res <- eigen(m) # only this computation is in R
    n <- attr(y, "row.number")
    list(val = sqrt(res$values/(n-1)),
         vec = res$vectors,
         center = attr(y, "scaled:center"),
         scale = attr(y, "scaled:scale"))
}

q <- pca(dat[,-1])

q$val

q$center

system.time(pca(dat[,-1]))

## ------------------------------------------------------------------------

center <- TRUE
scale <- FALSE
y <- scale(dat[,-1], center = center, scale = scale)
z <- as.db.data.frame(y, verbose = FALSE)
content(crossprod(z))
m <- lookat(crossprod(z)) # one scan of the table

w <- crossprod(z)
m1 <- PivotalR:::.db.getQuery(paste0("select unnest(", names(w)[1], ") as v from (", content(w), ") s"))
delete(z)
res <- eigen(m) # only this computation is in R

## ------------------------------------------------------------------------

a <- paste0("a", 1:1000)
b <- paste0("b", 1:1000)

com1 <- function (a, b, up = FALSE)
{
    expr <- ""
    l <- length(b)
    for (j in seq(a)) {
        if (up) m <- j
        else m <- l
        expr <- paste(expr, paste0("sum(", a[seq(m)], " * ", b[j], ")",
                                   collapse = ", "), sep = "")
        if (j != length(a)) expr <- paste0(expr, ", ")
    }
    expr
}

com2 <- function (a, b, up = FALSE)
{
    expr <- outer(a, b, function(x, y){paste0("sum(", x, " * ", y, ")")})
    if (up) expr <- expr[upper.tri(expr, diag = TRUE)]
    expr <- paste0(expr, collapse = ", ")
    expr
}

r1 <- com1(a, b, TRUE)
r2 <- com2(a, b, TRUE)

system.time(com1(a, b))

system.time(com2(a, b))

s <- paste0("{", paste0(rnorm(10000), collapse = ", "), "}")

system.time(arraydb.to.arrayr(s, "double"))

system.time(as.numeric(strsplit(gsub("(\\{|\\})", "", s), ",")[[1]]))


## ------------------------------------------------------------------------

x <- as.db.data.frame(abalone) # use default connection 1

fit <- madlib.lm(rings ~ . - id - sex, data = x)

## create a db.Rquery object that has two columns
z <- cbind(x$rings, predict(fit, x)) 

## plot prediction v.s. real value
plot(lookat(z, 100))
