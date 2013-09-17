library(PivotalR)

db.connect(port = 14526, dbname = "madlib")

x <- db.data.frame("abalone")

fit <- madlib.lm(rings ~ . - sex - id, data = x)

fit

## ------------------------------------------------------------------------

## coefficients

X <- rowAgg(1,x[,-c(1,2,10)])

a <- crossprod(X)

b <- crossprod(X, x$rings)

lookat(a)

lookat(b)

solve(lookat(a)) %*% lookat(b)

## ------------------------------------------------------------------------

sig <- lookat(sd(x$rings - predict(fit, x)))

err <- sqrt(diag(solve(lookat(a)))) * as.numeric(sig) * sqrt((dim(x)[1]-1)/(dim(x)[1] - 8))

err

## ------------------------------------------------------------------------

