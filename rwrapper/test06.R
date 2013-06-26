## test array operations
library(PivotalR)

db.connect(port = 14526, dbname = "madlib")

x <- db.data.frame("madlibtestdata.lin_ornstein_wi")

lookat(x, 10)

content(x$x)

content(x$y)

content(x$x$x)

content(x$x[,2])

z <- x$x

y <- x$x[1]

content(z[,2:3])

content(z[5])

content(unique(x$y))

content(unique(x$x[1]))
