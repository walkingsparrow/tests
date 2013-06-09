library(PivotalR)

db.connect(port = 14526, dbname = "madlib")

x <- db.data.frame("abalone")

x$sex <- as.factor(x$sex)

x@.factor.suffix

fit <- madlib.lm(rings ~ . - id, data = x)

fit

pred <- predict(fit, x)

content(pred)

preview(pred, 10)

preview(mean((x$rings - pred)^2))

## ------------------------------------------------------------------------

fit <- madlib.lm(rings ~ . - id - sex, data = x, hetero = TRUE)

y <- preview(x, 5000)

rfit <- lm(rings ~ . - id - sex, data = y)

fit

summary(rfit)

s <- summary(rfit)

## ------------------------------------------------------------------------

x <- db.data.frame("madlibtestdata.lin_auto_mpg_oi")

x1 <- db.data.frame("madlibtestdata.lin_auto_mpg_wi")

dim(x)

preview(x, 10)

preview(x1, 10)

fit <- madlib.lm(y ~ x - 1, data = x1, hetero = TRUE)

fit

y <- preview(x, 500)

v <- arraydb.to.arrayr(y$x, "double")

z <- as.data.frame(cbind(v, y$y))

rfit <- lm(V8 ~ ., data = z)

summary(rfit)

## ------------------------------------------------------------------------

library(PivotalR)

db.connect(port = 14526, dbname = "madlib")

delete("tt3")

db.existsObject("tt3")

db.existsObject("public.tt3")

db.existsObject("tt5")

delete("tt3", cascade = TRUE)

## ------------------------------------------------------------------------

x <- db.data.frame("abalone")

x$sex <- as.factor(x$sex)

is.factor(x$sex)

is.factor(x$rings)

is.factor(x)
