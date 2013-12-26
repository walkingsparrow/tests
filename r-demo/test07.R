library(PivotalR)
db.connect(port = 14526, dbname = "madlib")

dat <- db.data.frame("madlibtestdata.dt_abalone")

madlib.lm(rings ~ . - id | sex + (id < 2000), data = dat)

madlib.glm(rings < 10 ~ . - id | sex + (id < 2000), data = dat, family = "binomial")

madlib.lm(rings ~ . - id | sex, data = dat)

by(dat, dat$sex, function(x) madlib.lm(rings ~ . - id - sex, data = x))

## ----------------------------------------------------------------------

dat <- db.data.frame("madlibtestdata.lin_auto_mpg_wi")

lk(dat, 10)

madlib.lm(y ~ ., data = dat)

madlib.lm(y ~ x, data = dat)

madlib.lm(y ~ x + sin(y) - x[1:2], data = dat)

madlib.lm(y ~ . - x[1:2], data = dat)

fit <- madlib.lm(y ~ . - x[1:2] | sin(y)<0, data = dat)
