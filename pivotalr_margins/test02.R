library(PivotalR)
db.connect(port = 5433, dbname = "madlib")
options(width = 100)

dat <- db.data.frame("madlibtestdata.dt_abalone")

fit <- madlib.lm(rings ~ length + diameter, data = dat)

fit

mar <- margins(fit, ~ ., at.mean = FALSE)

mar

fit <- madlib.lm(rings ~ length + diameter*log(height+1), data = dat)

fit

mar <- margins(fit, ~ . + diameter + height, at.mean = FALSE)

mar

mar <- margins(fit, ~ . + diameter + height, at.mean = TRUE)

mar

## ----------------------------------------------------------------------

fit <- madlib.glm(rings<10 ~ length + diameter*log(height+1), data = dat, family = "logistic")

fit

system.time({mar <- margins(fit, ~ . + diameter + height, at.mean = FALSE)})

mar

system.time({mar <- margins(fit, ~ . + diameter + height, at.mean = TRUE)})

mar

## ----------------------------------------------------------------------

fit <- madlib.glm(rings<10 ~ . - id - sex, data = dat, family = "logistic")

fit

system.time({mar <- margins(fit, ~ . + diameter, at.mean = FALSE)})

mar

system.time({mar <- margins(fit, ~ . + diameter + height, at.mean = TRUE)})

mar

## ----------------------------------------------------------------------

dat1 <- db.data.frame("madlibtestdata.lin_auto_mpg_wi")

fit <- madlib.lm(y ~ x[2:4] + I(x[5]*x[6]), data = dat1)

fit

margins(fit, ~ . + x[5] + x[6])

margins(fit, ~ . + x[5:6])

gsub("([^\\[\\]]*)\\[[^\\[\\]]*\\]", "\\1", "x[2:3]", perl = T)

gsub("[^\\[\\]]*\\[([^\\[\\]]*)\\]", "\\1", "x[6]", perl = T)
