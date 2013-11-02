library(PivotalR)
db.connect(port = 14526, dbname = "madlib")

x <- db.data.frame("madlibtestdata.lin_auto_mpg_wi_cl1")

dat <- lk(x, "all")

dat[1:10,]
