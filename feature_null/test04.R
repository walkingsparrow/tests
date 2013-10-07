library(PivotalR)

db.connect(port = 14526, dbname = "madlib")

x <- db.data.frame("madlibtestdata.fdic")

names(x)

y <- cbind(x[43], db.array(x[c("ris_asset", "lncrcd", "lnauto", "lnconoth", "lnconrp", "intmsrfv", "lnrenr1a", "lnrenr2a", "lnrenr3a")]), x[45] < 500, x[43] < 10)
names(y) <- c("y", "x", "z1", "z2")

delete("madlibtestdata.fdic_part_null_double")
a <- as.db.data.frame(y, "madlibtestdata.fdic_part_null_double")

y <- y[!is.na(y$z1) & !is.na(y$z2) & !is.na(y$y),]


dim(v)

y <- lookat(x, "all")

names(y)

g <- lm(y ~ . - z1 - z2, data = y)

names(g)

length(g$na.action)

length(g$df.residual)

# ------------------------------------------------------------------------

dat <- lookat(a, "all")

f <- lm(y ~ . - z1 - z2, data = dat[dat$z2,])

summary(f)
