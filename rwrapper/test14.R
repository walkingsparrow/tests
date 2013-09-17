library(PivotalR)

## connect to HAWQ
db.connect(port = 18526, dbname = "madlib")

db.connect(host = "dca1-mdw1.dan.dh.greenplum.com", user = "gpadmin",
           password = "changeme", dbname = "dstraining") 

x <- db.data.frame("madlibtestdata.dt_abalone", conn.id = 2)

f <- madlib.lm(rings ~ . - id | sex, data = x)

f[[1]]

groups(f[[1]])

