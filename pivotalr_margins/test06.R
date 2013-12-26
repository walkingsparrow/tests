library(PivotalR)
db.connect(port = 16526, dbname = "madlib")
options(width = 100)

dat <- db.data.frame("madlibtestdata.dt_abalone")

## ----------------------------------------------------------------------

fit <- madlib.lm(rings ~ length + I(diameter*height) + log(1+shell) | sex, data = dat)

fit

margins(fit, ~ Vars(fit) + Terms())

## ----------------------------------------------------------------------

fit <- madlib.lm(rings ~ . - id + factor(sex), data = dat)

fit

dat$sex <- as.factor(dat$sex)

dat$sex <- relevel(dat$sex, ref = "M")

madlib.lm(rings ~ . - id, data = dat)



margins(fit, ~ ., at.mean = FALSE)
