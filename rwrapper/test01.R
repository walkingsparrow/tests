library(PivotalR)

db.connect(port = 14526, dbname = "madlib")

db.objects("orn")

to.delete <- db.objects("madlib_temp")
for (tbl.name in to.delete) delete(tbl.name)

db.objects("madlib_temp")

## ------------------------------------------------------------------------

x <- db.data.frame("abalone")

delete("abalone4")
x1 <- as.db.data.frame(x, "abalone4")

y <- as.db.data.frame(abalone, "abalone3")
