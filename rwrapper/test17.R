library(PivotalR)

db.connect(port = 14526, dbname = "madlib")

x <- db.data.frame("madlibtestdata.dt_abalone")

x$sex <- as.factor(x$sex)

f <- madlib.lm(rings ~ . - id, data = x)

f

coef(f)

y <- db.data.frame("madlibtestdata.bank")

g <- madlib.lm(balance ~ age + as.factor(job) + as.factor(marital), data = y)

g

coef(g)

lookat(mean((y$balance - predict(g, y))^2))

g <- madlib.glm(I(housing == 'yes') ~ age + as.factor(job) + as.factor(marital), data = y, family = "binomial")

g

coef(g)

g <- madlib.glm(I(housing == 'yes') ~ age, data = y, family = "binomial")

g

coef(g)

## ----------------------------------------------------------------------


