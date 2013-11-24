library(PivotalR)
db.connect(port = 14526, dbname = "madlib")

dat <- db.data.frame("madlibtestdata.dt_abalone")

by(dat, dat$sex, function(x) madlib.lm(rings ~ . - id - sex, data = x))

madlib.lm(rings ~ . - id | sex, data = dat)
