library(PivotalR)

db.connect(port = 14526, dbname = "madlib")

x <- db.data.frame("madlibtestdata.dt_abalone")

fit <- madlib.glm(rings<10 ~ . - id | sex, data = x, family = "binomial")

fit

AIC(fit, k = 5)

extractAIC(fit, k=5)

## ----------------------------------------------------------------------

y <- lookat(x[x$sex == "F",], "all")

g <- glm(rings < 10 ~ length + diameter + height + whole + shucked + viscera + shell, data = y, family = "binomial")

summary(g)

AIC(g, k = 5)


## ----------------------------------------------------------------------

madlib.glm(rings ~ . - id | sex, data = x)

madlib.lm(rings ~ . - id - sex, data = x)

## ----------------------------------------------------------------------

as.data.frame(x, nrows=10)

as.data.frame(x[x$sex=="F",], 10)

## ----------------------------------------------------------------------

f <- madlib.lm(rings ~ . - id - sex, data = x)

AIC(f, k=5)

logLik(f)

y <- lookat(x, "all")

g <- lm(rings ~ . - id - sex, data = y)

AIC(g, k=5)

logLik(g)

## ----------------------------------------------------------------------

f <- madlib.glm(rings<10 ~ . - id - sex, data = x, family = "binomial")

AIC(f, k=5)

logLik(f)

## y <- lookat(x, "all")

g <- glm(rings<10 ~ . - id - sex, data = y, family = "binomial")

AIC(g, k=5)

logLik(g)

## ----------------------------------------------------------------------

as.environment(x)

z <- with(x, rings+1)

content(z)

f <- madlib.lm(rings ~ length + as.factor(sex), data = x)

f

content(predict(f, x))
