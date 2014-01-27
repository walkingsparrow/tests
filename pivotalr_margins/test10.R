library(PivotalR)
db.connect(port = 5433, dbname = "madlib")

dat <- db.data.frame("madlibtestdata.dt_abalone")

fit <- madlib.lm(rings ~ diameter:sex, data = dat)

fit

margins(fit)



## ----------------------------------------------------------------------

fit <- madlib.glm(rings < 10 ~ . - id | sex, data = dat, family = "logistic")

nfit

lk(predict(fit, dat[,], type = "prob"), 10)

content(predict(fit, dat[,], type = "prob"))

margins(fit)

fit <- madlib.glm(rings < 10 ~ length + diameter*sex, data = dat, family = "logistic")

fit

m <- margins(fit, ~ length + sex.M)

m

is.data.frame(m)


dat1 <- cbind(db.array(dat[,-c(2,10)]), dat[,10])
names(dat1) <- c("x", "y")

dat2 <- as.db.data.frame(dat1)

fit <- madlib.lm(y ~ x[-1], data = dat1)

vcov(fit)

lk(resid(fit), 10)

lk(predict(fit, dat1), 10)

margins(fit, ~ x[2:5])

fit1 <- madlib.lm(rings ~ . - id - sex, data = dat[,])

fit1

lk(predict(fit1, dat[,]),10)

content(predict(fit1, dat[,]))
