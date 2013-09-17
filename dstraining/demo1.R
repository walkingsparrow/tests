
library(PivotalR)

db.connect(port = 14526, dbname = "madlib")

## connect to HAWQ
db.connect(port = 18526, dbname = "madlib") 

## connect to DCA
db.connect(host = "dca1-mdw1.dan.dh.greenplum.com", user = "gpadmin",
           password = "changeme", dbname = "dstraining") 

db.list() # list connections

db.objects() # list all tables in connection 1

db.objects("madlibtestdata.dt") # search table in connection 1

## wrapper of a table in connection 1
x <- db.data.frame("madlibtestdata.dt_abalone")

x

## wrapper of a table in connection 2
y <- db.data.frame("madlibtestdata.dt_abalone", conn.id = 2)

y

dim(x)

names(x) # column names

x$rings

content(x$rings)

lookat(x$rings, 10)

lookat(mean(x$rings)) # mean value of a column

## wrapper of MADlib summary
madlib.summary(y)

lookat(x, 10) # look at a sample of table

lookat(sort(x, FALSE, x$id), 10) # ordered by id

lookat(sort(x, FALSE, NULL), 20) # look at a sample ordered randomly

## ----------------------------------------------------------------------
## ----------------------------------------------------------------------
## linear regression Examples --------------------------------

## fit one different model to each group of data with the same sex
fit <- madlib.lm(rings ~ . - id | sex, data = y)

fit # view the result

length(fit)

fit[[1]]

groups(fit)

groups(fit[[1]])

## apply the model onto data in another database
lookat(mean((x$rings - predict(fit, x))^2)) # mean square error

ap <- cbind(x$rings, predict(fit, x)) # combine two columns

plot(lookat(sort(ap, FALSE, NULL), 100)) # plot a random sample

ap <- cbind(x$rings[x$sex == "I"], predict(fit[[1]], x[x$sex == "I",]))

plot(lookat(sort(ap, FALSE, NULL), 100)) # plot a random sample

## ----------------------------------------------------------------------
## Pivoting: categorial variable

v <- x

v$sex <- as.factor(v$sex) # specify which column to pivot

v

names(v)

f <- madlib.lm(rings ~ . - id, data = v)

f

lookat(mean((v$rings - predict(f, v))^2)) # mean square error

## ----------------------------------------------------------------------
## generic bagging

fit <- generic.bagging(function(data) {
                           madlib.lm(rings ~ . - id - sex, data = data)
                       },
                       data = y, nbags = 10, fraction = 0.85)

pred <- predict(fit, newdata = x) # make prediction

lookat(mean((x$rings - pred)^2))

## ---------------------------------------------------------------------
## cross-validation
## no transaction lock number limitation

err <- generic.cv(function(data) {
                      madlib.lm(rings ~ . - id - sex, data = data)
                  },
                  predict,
                  function(predicted, data) {
                      lookat(mean((data$rings - predicted)^2))
                  }, data = y)

err

## ----------------------------------------------------------------------
## logistic regression

g <- madlib.glm(rings < 10 ~ . - id - sex, data = x,
                family = "binomial")

g

## accuracy
lookat(mean(((x$rings<10) == predict(g, x))))

## ----------------------------------------------------------------------
## array column support

z <- db.data.frame("madlibtestdata.lin_auto_mpg_oi")

lookat(z, 10)

madlib.lm(y ~ x, data = z)

madlib.lm(y ~ x - `x[1]`, data = z) # `x[1]` is a valid R variable name

## ----------------------------------------------------------------------
## deal with NULL values in the table

delete("null_data", conn.id = 1)
w <- as.db.data.frame(null.data, "null_data", conn.id = 1)

dim(w)

lookat(w, 10)

db.objects("null", conn.id = 2)

madlib.lm(sf_mrtg_pct_assets ~ ., data = w) # will fail 

for (i in 1:10) w <- w[!is.na(w[i]),] # filter NULL values

w[is.na(w)] <- 20

dim(w)

madlib.lm(sf_mrtg_pct_assets ~ ., data = w)

## ----------------------------------------------------------------------
## ----------------------------------------------------------------------
## ----------------------------------------------------------------------
## quick prototype linear regression

## Comparison:

## normal R script, computation runs in memory
r.linregr <- function (x, y)
{
    a <- crossprod(x)
    b <- crossprod(x, y)
    solve(a) %*% b
}

dat <- lookat(x, "all")

r.linregr(as.matrix(cbind(1, dat[,-c(1,2,10)])), dat$rings)

## ------------------------------------------------
## PivotalR script, computation runs in database
linregr <- function (x, y)
{
    a <- crossprod(x)
    b <- crossprod(x, y)
    solve(lookat(a, "all")) %*% lookat(b, "all")
}

linregr(db.array(1, x[,-c(1,2,10)]), x$rings)

## ----------------------------------------------------------------------
## ----------------------------------------------------------------------
## compute all eigenvectors in parallel
## can be used for tables with features < 1000

pca <- function (x, center = TRUE, scale = FALSE)
{
    y <- scale(x, center = center, scale = scale) # centering and scaling
    z <- as.db.data.frame(y, verbose = FALSE) # create an intermediate table to save computation
    m <- lookat(crossprod(z)) # one scan of the table to compute Z^T * Z
    d <- delete(z) # delete the intermediate table
    res <- eigen(m) # only this computation is in R
    n <- attr(y, "row.number") # save the computation to count rows
     
    ## return the result
    list(val = sqrt(res$values/(n-1)), # eigenvalues
         vec = res$vectors, # columns of this matrix are eigenvectors
         center = attr(y, "scaled:center"),
         scale = attr(y, "scaled:scale"))
}

dat <- db.data.frame("madlibtestdata.pca_mat_600_100", conn.id = 2)

q <- pca(dat[,-1])

q$val

q$center
