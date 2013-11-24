library(PivotalR)
db.connect(port = 5433, dbname = "madlib")

w <- db.data.frame("madlibtestdata.lin_auto_mpg_wi")

z <- grepl("^sele", w)

content(is.na(w$x))

z <- is.na(w$x)

z <- NULL
z <- c(z, w$x)
z <- c(z, w$y)
z <- c(z, w$x[1])
