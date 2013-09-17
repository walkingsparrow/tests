library(PivotalR)

db.connect(port = 14526, dbname = "madlib")

x <- db.data.frame("abalone")

y <- db.data.frame("abalone_arr")

content(unique(x))

content(unique(y$arr))

content(by(x, NULL, unique))

content(apply(x, 1, unique))

lookat(crossprod(y$arr))

lookat(crossprod(x[,-c(1,2)]))
