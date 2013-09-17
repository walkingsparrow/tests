
library(PivotalR)

db.connect(host = "dca1-mdw1.dan.dh.greenplum.com", user = "gpadmin",
           password = "changeme", dbname = "dstraining")

db.connect(port = 18526, dbname = "madlib") # HAWQ

db.list()

db.objects()

db.objects("madlibtestdata.dt")

x <- db.data.frame("madlibtestdata.dt_abalone")

dim(x)

names(x)

madlib.summary(x)

lookat(x, 10)

lookat(sort(x, FALSE, x$id), 10)

lookat(sort(x, FALSE, NULL), 20) # look at a sample ordered randomly

## linear regression Examples --------------------------------

## fit one different model to each group of data with the same sex
fit1 <- madlib.lm(rings ~ . - id | sex, data = x)

fit1 # view the result

lookat(mean((x$rings - predict(fit1, x))^2)) # mean square error

x$sex <- as.factor(x$sex)
f <- madlib.lm(rings ~ . - id, data = x)

f

lookat(mean(x$rings))

g <- madlib.glm(rings < 10 ~ . - id | sex, data = x, family = "binomial")

g

## ------------------------------------------------------------------------
## mean squared error
lookat(mean((x$rings - predict(f, x))^2))

## plot fitted v.s. resid
z <- cbind(x$rings - predict(f, x), predict(f, x))
names(z) <- c("resid", "fitted")

plot(lookat(z, 200))

## ------------------------------------------------------------------------
## quick prototype linear regression

## normal R script, computation runs in R
r.linregr <- function (x, y)
{
    a <- crossprod(x)
    b <- crossprod(x, y)
    solve(a) %*% b
}

dat <- lookat(x, "all")

r.linregr(as.matrix(cbind(1, dat[,-c(1,2,10)])), dat$rings)

## PivotalR script, computation runs in database
linregr <- function (x, y)
{
    a <- crossprod(x)
    b <- crossprod(x, y)
    solve(lookat(a)) %*% lookat(b)
}

linregr(rowAgg(1, x[,-c(1,2,10)]), x$rings)

madlib.lm(rings ~ . - id -sex, data = x)

