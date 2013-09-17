library(PivotalR)

db.connect(port = 14526, dbname = "madlib")

x <- db.data.frame("madlibtestdata.lin_auto_mpg_oi")

y <- lookat(x, "all")

center <- T
scale <- T

s <- scale(x, center, scale)

attr(s, "scaled:center")

attr(s, "scaled:scale")

content(s)

r <- scale(y, center, scale)

attr(r, "scaled:center")

attr(r, "scaled:scale")

## ------------------------------------------------------------------------

center <- 1:8
scale <- T

s <- scale(x, center, scale)

attr(s, "scaled:center")

attr(s, "scaled:scale")

content(s)

r <- scale(y, center, scale)

attr(r, "scaled:center")

attr(r, "scaled:scale")
