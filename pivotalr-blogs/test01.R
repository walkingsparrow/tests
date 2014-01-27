library(PivotalR)
db.connect(port = 5433, dbname = "madlib")

dat <- as.db.data.frame(abalone)

madlib.lm(rings ~ length + diameter, data = dat)

madlib.lm(rings ~ length + diameter | sex + (id < 2000), data = dat)

names(dat[,c("length", "diameter", "rings")])

by(dat[,c("length", "diameter", "rings")], c(dat$sex, dat$id < 2000),
   function(x) madlib.lm(rings ~ length + diameter, data = x))

my.linear <- function(x, y) {
    a <- crossprod(x)
    b <- crossprod(x, y)
    solve (lookat (a)) %*% lookat(b)
}

by(dat[,c("length", "diameter", "rings")], c(dat$sex, dat$id < 2000),
   function(x) my.linear(x[,1:2], x$rings))

x <- base::cbind(a = 1:3, b = 2:4)

x

typeof(x)

is.data.frame(x)

cbind(a = 1:3, b = 2:4)

z <- cbind(1:3, 2:4)

base::cbind(1:3, 2:4)

do.call(base::cbind, list(NULL, a = 1:3, b = 2:4))

cbind(a = 1:3, x = 3:5)

cbind(x = 3:5, a = 1:3)

base::cbind(a = 1:3, x = 3:5)

base::cbind(x = 3:5, a = 1:3)

test <- function(x, ...) {
    call <- match.call(expand.dots = TRUE)
    call
}

cl <- test(a = 1:3, x = 3:5)

names(cl)

cl <- test(x = 1:3, a = 3:5)

names(cl)

PivotalR:::.unique.string()
