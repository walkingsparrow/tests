library(PivotalR)
db.connect(port = 16526, dbname = "madlib")
options(width = 120)

dat <- db.data.frame("madlibtestdata.dt_abalone")

fit <- madlib.lm(rings ~ . - id, data = dat)

fit

margins(fit)

fit <- madlib.lm(rings ~ length + diameter + diameter:sex, data = dat)

fit

margins(fit)

fit <- madlib.lm(rings ~ length + diameter:sex, data = dat)

fit

margins(fit)

fit <- madlib.glm(rings<10 ~ . - id, data = dat, family = "logistic")

fit

margins(fit)

fit <- madlib.glm(rings<10 ~ length + diameter + diameter:sex, data = dat, family = "logistic")

fit

margins(fit)

fit <- madlib.glm(rings<10 ~ length + diameter:sex, data = dat, family = "logistic")

fit

margins(fit, ~ sex.I)

## ----------------------------------------------------------------------

dat <- db.data.frame("madlibtestdata.lin_auto_mpg_wi")

fit <- madlib.lm(y ~ x[-1], data = dat)

fit

margins(fit)

fit <- madlib.lm(y ~ x[2] + x[3]*x[4], data = dat)

fit

margins(fit, ~ x[2:4], at.mean = TRUE)

## ----------------------------------------------------------------------

d <- lk(dat, -1)

d$cat <- sample(1:5, nrow(d), replace = TRUE)

dim(d)

dat <- as.db.data.frame(d)

fit <- madlib.glm(rings<10 ~ length + diameter:factor(cat), data = dat, family = "logistic")

fit

margins(fit)

## ----------------------------------------------------------------------

delete("abalone")
dat <- as.db.data.frame(abalone, "abalone")

fit <- madlib.lm(rings ~ length + diameter*sex, data = dat)
margins(fit)
margins(fit, at.mean = TRUE)
margins(fit, factor.continuous = TRUE)

fit <- madlib.glm(rings < 10 ~ length + diameter*sex, data = dat, family = "logistic")
margins(fit, ~ length + sex)
margins(fit, ~ length + sex.M, at.mean = TRUE)
margins(fit, ~ length + sex.I, factor.continuous = TRUE)

## create a data table that has two columns
## one of them is an array column
dat1 <- cbind(db.array(dat[,-c(1,2,10)]), dat[,10])
names(dat1) <- c("x", "y")
dat1 <- as.db.data.frame(dat1, "abalone_array")

fit <- madlib.glm(y < 10 ~ x[-1], data = dat1, family = "logistic")
margins(fit, ~ x[2:5])

madlib.lm(rings ~ . - id - sex, data = dat)
