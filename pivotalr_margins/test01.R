
library(PivotalR)
db.connect(port = 5433, dbname = "madlib")

dat <- db.data.frame("madlibtestdata.dt_abalone")

madlib.lm(rings ~ length + diameter * as.factor(sex), data = dat)

fit <- madlib.lm(rings ~ length + I(log(height + diameter)), data = dat)

fit

mar <- margins(fit, ~ height + diameter)

mar

## madlib.glm(rings<10 ~ length + diameter, data = dat, family = "binomial")

dat <- db.data.frame("madlibtestdata.lin_auto_mpg_wi")

lk(dat, 10)

fit <- madlib.lm(y ~ x[2:5] + I(x[6]^2), data = dat)

fit

vcov(fit)

mar <- margins(fit, ~ x[6])

mar


fit <- madlib.glm(rings<10 ~ length + diameter, data = dat, family = "binomial")

fit

mar <- margins(fit, ~ .)

mar


