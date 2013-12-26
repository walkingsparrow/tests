library(PivotalR)
db.connect(port = 14526, dbname = "madlib")

dat <- db.data.frame("madlibtestdata.dt_abalone")

z <- PivotalR:::.approx.cut.data(dat, 10)

length(z)

dim(dat)

dim(z$valid[[2]])
