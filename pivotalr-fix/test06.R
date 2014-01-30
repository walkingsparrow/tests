library(PivotalR)
db.connect(port = 5433, dbname = "madlib")

dat <- db.data.frame("madlibtestdata.dt_abalone")

b <- by(dat, dat$sex, FUN = function(x) lk(dat[dat$id == max(dat$id),], 1))

b

b <- by(dat, dat$sex, FUN = function(x) lk(sort(dat, TRUE, dat$id), 1))

b

lk(b)

content(b)

dat1 <- db.data.frame("madlibtestdata.tsa_beer_time")

names(dat1)

lk(dat1, 10)

lk(max(dat1$id))
