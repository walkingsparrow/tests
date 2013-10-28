library(PivotalR)

db.connect(port = 14526, dbname = "madlib")

dat <- db.data.frame("madlibtestdata.dt_abalone")

f <- madlib.lm(rings ~ . - id + as.factor(sex), data = dat)

lk(mean((dat$rings - predict(f, dat))^2))

f <- madlib.glm(rings < 10 ~ . - id + as.factor(sex), data = dat, family = "binomial")

lk(mean(((dat$rings<10) == predict(f, dat))))

f <- madlib.glm(as.integer(rings < 10) ~ . - id + as.factor(sex), data = dat)

lk(mean((as.integer(dat$rings<10) - predict(f, dat))^2))

f <- madlib.glm(rings < 10 ~ . - id + as.factor(sex), data = dat)

lk(mean((dat$rings - predict(f, dat))^2))

dat <- db.data.frame("madlibtestdata.lin_auto_mpg_oi")

f <- madlib.lm(y ~ ., data = dat)

lk(mean((dat$y - predict(f, dat))^2))

f <- madlib.lm(y ~ x, data = dat)

lk(mean((dat$y - predict(f, dat))^2))

f <- madlib.lm(y ~ . - x[1], data = dat)

lk(mean((dat$y - predict(f, dat))^2))

f <- madlib.lm(y ~ x - x[c(1:2,5)], data = dat)

lk(mean((dat$y - predict(f, dat))^2))
