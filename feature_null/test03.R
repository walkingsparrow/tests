library(PivotalR)

db.connect(port = 14526, dbname = "madlib")

x <- lookat(db.data.frame("madlibtestdata.log_wpbc"), "all")

dim(x)

x[1:10,]

