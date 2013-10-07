library(PivotalR)

db.connect(port = 14526, dbname = "madlib")

x <- db.data.frame("bank")

names(x)

tmp <- x[x$job == "admin.",]

dim(tmp)

userJob <- lookat(tmp, 1000)

delete("userJob")

z <- as.db.data.frame(userJob, "userJob", is.temp = TRUE)

z

as.db.data.frame(tmp, "userJob2", is.temp = TRUE)

as.db.data.frame(userJob, "madlibtestdata.userJob")

y <- db.data.frame("madlibtestdata.dt_abalone")

content(y)

y



