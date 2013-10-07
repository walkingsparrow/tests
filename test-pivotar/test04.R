library(PivotalR)

db.connect(port = 14526, dbname = "madlib")

x <- db.data.frame("madlibtestdata.log_wpbc_null")

lookat(x, 10)

preview(x, 10)
