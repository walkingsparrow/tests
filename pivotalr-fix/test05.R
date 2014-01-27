library(PivotalR)
db.connect(port = 5433, dbname = "madlib")

dat <- db.data.frame("madlibtestdata.dt_abalone")

cbind(a = 1:2, b = 3:4)

content(cbind(1, dat$id, dat$sex))
