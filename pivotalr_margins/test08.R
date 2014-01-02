library(PivotalR)
db.connect(port = 5433, dbname = "madlib")

dat <- db.data.frame("madlibtestdata.dt_abalone")

fit <- madlib.glm(rings<10 ~ length + diameter + I(length^2*diameter) + length:height:shell + length*log(2+sin(2*diameter)), data = dat, family = "logistic")

fit

margins(fit)

margins(fit, at.mean = TRUE)

## ----------------------------------------------------------------------

fit <- madlib.glm(rings<10 ~ length + diameter + height + whole + shucked + viscera + shell + length:diameter + diameter:height + height:whole + whole:shucked + shucked:viscera + viscera:shell + length:diameter:height + diameter:height:whole + height:whole:shucked + whole:shucked:viscera + shucked:viscera:shell, data = dat, family = "logistic")

fit

system.time({a <- margins(fit)})

a

fit <- madlib.lm(rings ~ length + diameter + height + whole + shucked + viscera + shell + length:diameter + diameter:height + height:whole + whole:shucked + shucked:viscera + viscera:shell + length:diameter:height + diameter:height:whole + height:whole:shucked + whole:shucked:viscera + shucked:viscera:shell, data = dat)

fit

system.time({a <- margins(fit)})

a

fit <- madlib.glm(rings<10 ~ length + length:diameter + diameter:height + length:diameter:height + diameter:height:whole, data = dat, family = "logistic")

fit

margins(fit)

## ----------------------------------------------------------------------

fit <- madlib.glm(rings ~ length + diameter:sex, data = dat, family = "linear")

fit <- madlib.glm(rings < 10 ~ . - id, data = dat, family = "logistic")

fit

margins(fit, factor.continuous = TRUE)

margins(fit, factor.continuous = FALSE)

fit <- madlib.glm(rings < 10 ~ length + sex, data = dat, family = "logistic")

fit

margins(fit, factor.continuous = TRUE)

margins(fit, factor.continuous = FALSE)

