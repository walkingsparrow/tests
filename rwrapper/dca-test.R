
library(PivotalR)

db.connect(dbname="fdic", user="gpadmin", host="10.110.122.107", password = "changeme", madlib="madlib_v05")

x <- db.data.frame("census1", key = "h_serialno")

names(x)

dim(x)

x[1:2, 1]

content(x[1:2,1])

preview(x[1:2,1])
