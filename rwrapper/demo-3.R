library(PivotalR)

db.connect(port = 5433)

db.list()

## ------------------------------------------------------------------------

x <- db.data.frame("ornstein", key = "key")

dim(x)

names(x)

## ------------------------------------------------------------------------

y <- x

content(y[,1])

y[,1] <- y$sector

content(y)

## ------------------------------------------------------------------------

y <- x

names(y)

content(y[,1:2])

y[,1:2] <- y[,2:3]

content(y)

## ------------------------------------------------------------------------

y <- x

names(y)

content(y[,1:2])

content(y[,2:3] + 2)

y[,1:2] <- (y[,2:3] + 2) * 3

content(y)

preview(y[,2:3] + 2)

## ------------------------------------------------------------------------

y <- x

names(y)

content(y[,1:2] + y[,2:3])

preview(y[,1:2] + y[,2:3])

## ------------------------------------------------------------------------

y <- x

names(y)

content(y[y$nation < 3, 1:2])

content(y[y$nation < 3, 1:2] + y[y$nation<3, 2:3] + 2.3)

z <- y[y$nation < 3, 1:2] + y[y$nation<3, 2:3] + 2.3

z@.where

z1 <- y$nation < 3

z1@.expr

PivotalR:::.strip(z@.where) == PivotalR:::.strip(z1@.expr)

y[y$nation < 3, 1:2] <- y[y$nation < 3, 1:2] + y[y$nation<3, 2:3] + 2.3

content(y)

## ------------------------------------------------------------------------

y <- x

names(y)

z <- y[y$nation<3,]

content(z)

z[z$assets < 30, 1:2] <- z[z$assets < 30, 1:2] + z[z$assets<30, 2:3] + 2.3

content(z)

content(z$nation)

content(z$assets)

z$nation <- z$interlocks + 1

content(z)

content(z[1:2])

## ------------------------------------------------------------------------

y <- x

z <- x

v <- merge(y, z, by = "nation")

content(v)

v <- merge(y, z, by = c("nation", "sector"))

content(v)

## ------------------------------------------------------------------------

y <- x

z <- sort(y, by = "assets")

content(z)

content(z$nation + 1 + 2.3)

content(sort(y[y$nation<3 | y$assets<10000,-c(1,3)], by = "sector") * 2)

## ------------------------------------------------------------------------

y <- x

content(colMeans(y))

content(length(y$nation))

content(by(y, y$nation, mean))

content(by(y[,1:3], NULL, sum))

preview(by(y[,1:3], NULL, sum))

preview(by(y[,1:3], NULL, mean))

preview(by(y[,1:3], NULL, sd))

preview(by(y[,1:3], NULL, var))

## ------------------------------------------------------------------------

y <- x

content(is.na(y))

content(y[is.na(y$nation),])

y[is.na(y$nation),"nation"] <- 3

content(y)

## ------------------------------------------------------------------------

y <- x

z <- y[is.na(y)]

content(y[is.na(y)])

y[is.na(y)] <- 3

y[y$nation<3,"nation"] <- 3

content(y)

## ------------------------------------------------------------------------
## ------------------------------------------------------------------------

setGeneric("test", signature = "x", function(x, ...) standardGeneric("test"))

setMethod (
    "test",
    signature(x = "db.obj"),
    function (x, by = character(0), decreasing = FALSE, ...)
    {
        print(by)
        if (identical(by, character(0)) && !identical(x@.key, character(0)))
            by <- x@.key
        print(by)
    })

test(y)
