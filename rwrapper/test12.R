## testing HAWQ
library(PivotalR)

db.connect(port = 18526, dbname = "madlib")

db.objects()

x <- db.data.frame("madlibtestdata.dt_abalone")

dim(x)

names(x)
