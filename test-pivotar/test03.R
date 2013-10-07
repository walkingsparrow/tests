library(PivotalR)

db.connect(port = 14526, dbname = "madlib")

x <- db.data.frame("madlibtestdata.dt_abalone")

names(x)

y <- db.data.frame("madlibtestdata.lin_auto_mpg_oi")

names(y)

lookat(y, 10)

content(y$x)

content(y$x[1])

lookat(y$x, 10)

lookat(y$x[2], 10)

lookat(sort(y$x[2], F, y$y), 10)

content(is.na(y$x[1]))

content(y[!is.na(y$x[2]),])

lookat(sum(y$x[2]))

lookat(sum(y))

dim(y$x)

lookat(y, 1)

lookat(y, 0)

content(y[['x']][1])

y$x[2] <- 1

content(y)

content(y$x[2])

as.db.data.frame(y, "madlibtestdata.\"Ps D1\"")

w <- db.data.frame("madlibtestdata.Ps D1")

w

as.db.data.frame(y, "Ps D2")

db.objects("Ps\\sD")

delete("\"madlibtestdata.lung1\"")

delete("Ps D2", is.temp = F)
