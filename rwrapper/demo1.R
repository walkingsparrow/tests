library(PivotalR)

db.connect(port = 5433)

db.connect(port = 5433)

## db.connect(port = 14526)

db.list()

conn.eql(1, 2)

x <- db.data.frame("madlibtestdata.lin_ornstein")

x

names(x)

dim(x)

preview(x, 10)

## ------------------------------------------------------------------------

z <- x$assets

content(x)

content(z)

x$sector

content(x$sector)

y <- x

y == x

x$assets <- x$sector

x

content(x)

y == x

## preview(x, 10)

preview(x, 10, FALSE)

## ------------------------------------------------------------------------

z <- x[[1]]

z

content(z)

x$sector <- x$nation

content(x)

preview(x, 10, FALSE)

x[[2]]

content(x[[4]])

x[["nation"]]

content(x[["nation"]])

content(x[[TRUE]])

## ------------------------------------------------------------------------

content(x[TRUE])

content(x[c(1,2,3)])

content(x[1])

content(x[1,1])

content(x[,])

content(x[,1:3])
