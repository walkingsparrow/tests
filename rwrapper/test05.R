library(PivotalR)

db.connect(port = 14526, dbname = "madlib")

x <- db.data.frame("abalone")

z <- rowAgg(1, x[-2]+1)

content(x[-2] + 1)

content(z)

x <- db.data.frame("mleft")

y <- db.data.frame("mright")

lookat(x)

lookat(y)

content(rowAgg(1,x[1], x[2]))

z <- crossprod(rowAgg[1,x[1], x[2]], x)

content(rowAgg(1, x$length, x$height))

content(crossprod(rowAgg(1, x$length, x$height), x$diameter))

content(z)

lookat(z)

preview(z)

arraydb.to.arrayr("(1),(2+1),(3-2)", "double")

s <- "(1),(2+1),(3-2)"

elm <- regmatches(s, gregexpr("\\([^(\\),)]*\\)", s, perl=T))[[1]]

elm
