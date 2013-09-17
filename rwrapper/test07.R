## Test the branch array_support
## It contains unqiue, crossprod, by, extraction, ops

library(PivotalR)

db.connect(port = 14526, dbname = "madlib")

x <- db.data.frame("abalone")

dim(x)

names(x)

## ------------------------------------------------------------------------

lookat(unique(x$sex))

y <- x

y$arr <- rowAgg(1, x$length, x$diameter)

content(y)

lookat(y, 10)

lookat(y$arr, 10)

content(y$arr[2])

z <- db.data.frame("abalone_arr")

lookat(z, 10)

content(z$arr[2])

content(z$arr[1:2])

content(z$arr[,1:2])

lookat(unique(x$sex))

content(mean(z$length))

content(mean(z$arr))

content(rowAgg(z$arr[2], z$arr[3], z$length))

content(rowAgg(z$arr, z$length))

content(rowAgg(z[-2]))

content(mean(z))

lookat(z, 10)

a <- lookat(z, 10, array = TRUE)

names(a)

## ------------------------------------------------------------------------

library(PivotalR)
db.connect(port = 14526, dbname = "madlib")

z <- db.data.frame("abalone_arr")

content(sum(z))

cat(content(mean(z)), "\n")

content(z$arr[[2]])

content(z$arr)

z$arr <- 1

y <- z

y$arr[2] <- y$id

content(y)

y$arr <- y$id

y[2] <- y$id

content(y)

y[2] <- 'a'

setGeneric("[<-")

setClass("data.frame1")

setMethod("[<-",
          signature (x = "data.frame1"),
          function (x, i, j, value) {
              nA <- nargs()
              print(nA)
              x
          })

a <- data.frame(a = 1:4, b = 2:5)

a[1] <- 9

v <- a

class(v) <- "data.frame1"

v[1] <- 9

## ------------------------------------------------------------------------

library(PivotalR)
db.connect(port = 14526, dbname = "madlib")

z <- db.data.frame("abalone_arr")

p <- PivotalR:::.expand.array(z)

q <- PivotalR:::.analyze.formula(rings ~ . - `arr[1]`, data  = z)

q <- PivotalR:::.analyze.formula(rings ~ arr - `arr[1]`, data  = z)

names(q)

q$dep.str

q$ind.str

q$ind.vars



