library(PivotalR)

db.connect(port = 14526, dbname = "madlib")

x <- db.data.frame("madlibtestdata.fdic")

y <- cbind(x[43] < 15, db.array(x[c("ris_asset", "lncrcd", "lnauto", "lnconoth", "lnconrp", "intmsrfv", "lnrenr1a", "lnrenr2a", "lnrenr3a")]), x[45] < 500, x[43] < 10)
names(y) <- c("y", "x", "z1", "z2")

delete("fdic_part_null_grp")

a <- as.db.data.frame(y, "fdic_part_null_grp")

y <- y[!is.na(y$z1) & !is.na(y$z2),]

delete("madlibtestdata.fdic_part_null_grp2")
a <- as.db.data.frame(y, "madlibtestdata.fdic_part_null_grp2", field.types=list(z1="boolean", y="boolean", x="double precision[]", z2="boolean"))

## ----------------------------------------------------------------------

y <- db.data.frame("madlibtestdata.log_wpbc")

x <- lookat(y, "all")

dim(x)

x[1:10,]

fit <- glm(y ~ . - 1, data = x, family = "binomial", control = list(maxit=300, epsilon = 1e-10))

summary(fit)

kappa(fit, exact = TRUE)

madlib.glm(y ~ . - 1, data = y, family = "binomial")

## ----------------------------------------------------------------------

db.existsObject("fdic_part_null_grp")
