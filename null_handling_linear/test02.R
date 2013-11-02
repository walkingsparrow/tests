library(PivotalR)
db.connect(port = 14526, dbname = "madlib")

dat <- lk("madlibtestdata.fdic_part_null_double_wi", "all")

f <- glm(z1 ~ . - y - z2 - `x[1]`, data = dat, family = binomial, control = list(maxit=1000))

summary(f)
