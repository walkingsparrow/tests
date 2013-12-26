library(PivotalR)
db.connect(port = 16526, dbname = "madlib")
options(width = 100)

dat <- db.data.frame("madlibtestdata.dt_abalone")

dat <- as.db.data.frame(abalone[sample(1:nrow(abalone), 1e5, replace=TRUE),], "abalone_big")

dat <- db.data.frame("abalone_big")

fit <- madlib.glm(rings<10 ~ length + diameter + height + whole + shucked + viscera + shell + length:diameter + diameter:height + height:whole + whole:shucked + shucked:viscera + viscera:shell + length:diameter:height + diameter:height:whole + height:whole:shucked + whole:shucked:viscera + shucked:viscera:shell, data = dat, family = "logistic")

fit <- madlib.glm(rings<10 ~ . - id - sex, data = dat, family = "logistic")

fit

system.time({mar <- margins(fit, ~ . + Vars(1:2), at.mean = FALSE)})

mar

system.time({mar <- margins(fit, ~ ., at.mean = TRUE)})

mar

fit <- madlib.lm(rings ~ length + diameter + diameter:height:whole + height:whole:shucked, data = dat)

fit

system.time({mar <- margins(fit, ~ length + diameter + height + whole + shucked + Vars(), at.mean = FALSE)})

mar

system.time({mar <- margins(fit, ~ length + diameter + height + whole + shucked, at.mean = TRUE)})

mar

system.time(v <- vcov(fit))

v

system.time({mar <- margins(fit, ~ ., at.mean = TRUE)})

mar

###----------------------------------------------------------------------

dat <- db.data.frame("madlibtestdata.lin_auto_mpg_wi")

fit <- madlib.lm(y ~ x[2:5] + x[6]:x[7]:x[8], data = dat)

fit

margins(fit, ~ x[2:8], at.mean = FALSE)

margins(fit, ~ x[2:8], at.mean = TRUE)

margins(fit, ~ ., at.mean = FALSE)

margins(fit, ~ x, at.mean = FALSE)
