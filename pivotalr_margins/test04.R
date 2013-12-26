library(PivotalR)
db.connect(port = 5433, dbname = "madlib")
options(width = 100)

dat <- db.data.frame("madlibtestdata.dt_abalone")

fit <- madlib.lm(rings ~ length + diameter:shell, data = dat)

fit

mar <- margins(fit, ~ diameter, at.mean = FALSE)

mar

mar <- margins(fit, ~ diameter, at.mean = TRUE)

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

system.time({mar <- margins(fit, ~ ., at.mean = FALSE)})

mar

system.time({mar <- margins(fit, ~ . + diameter + height, at.mean = TRUE)})

mar

## ----------------------------------------------------------------------

dat1 <- db.data.frame("madlibtestdata.lin_auto_mpg_wi")

fit <- madlib.lm(y ~ x[2:4] + I(x[5]*x[6]), data = dat1)

fit

margins(fit, ~ . + x[5] + x[6])

margins(fit, ~ . + x[5:6])

## ----------------------------------------------------------------------

library(PivotalR)
db.connect(port = 5433, dbname = "madlib")
options(width = 100)

dat <- db.data.frame("madlibtestdata.dt_abalone")

fit <- madlib.glm(rings < 10 ~ length + diameter + shell, data = dat, family = "binomial")

fit

mar <- margins(fit, ~ ., at.mean = FALSE)

mar

margins(fit, ~ ., at.mean = TRUE)

## ----------------------------------------------------------------------

dat <- db.data.frame("madlibtestdata.lin_auto_mpg_wi")

fit <- madlib.lm(y ~ x[2:5] + x[6]:x[7]:x[8], data = dat)

fit

margins(fit, ~ . + x[6] + x[7], at.mean = FALSE)

margins(fit, ~ . + x[6] + x[7], at.mean = TRUE)

avgs <- lk(mean(dat))

n <- ncol(avgs)
print(n)
i <- 1
a <- as.list(avgs[,i])
print(a)
print(length(avgs[,i]))
print(paste(names(avgs)[i], "[", seq_len(length(avgs[,i])), "]", sep = ""))
names(a) <- paste(names(avgs)[i], "[", seq_len(length(avgs[,i])), "]", sep = "")
avgs <- c(avgs, a)


avgs

avgs <- expand.avgs(avgs)

## ----------------------------------------------------------------------

dat <- db.data.frame("madlibtestdata.dt_abalone")

fit <- madlib.lm(rings ~ . - id + factor(sex), data = dat)

fit

pred <- predict(fit, dat)

content(pred)
