## test sampling methods
library(PivotalR)
db.connect(port = 14526, dbname = "madlib")

x <- db.data.frame("madlibtestdata.dt_abalone")

y <- as.db.data.frame(x, nrow = 20)

lk(y, "all")

w <- sample(y, size = 10, replace = FALSE)

lk(w, "all")

v <- sample(y, size = 30, replace = TRUE)

u <- lk(v, "all")

table(u$id)

system.time(sample(x, size = 2000, replace = TRUE))

a <- sample(x, size = 20000, replace = TRUE)

dim(a)
