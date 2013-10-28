library(PivotalR)

db.connect(port = 14526, dbname = "madlib")

x <- db.data.frame("madlibtestdata.dt_abalone", key = "id")

lk(x, 1)

z <- as.data.frame(x[1:10,])

lk(x$sex, 10)
