
library(PivotalR)

help.start() # get the help

## create multiple connections to different databases
db.connect(port = 14526, dbname = "madlib") # connection 1, use default values for the parameters

db.list() # list the info for all the connections

dbms()

madlib()

## create a table and the R object pointing to the table
## using the example data that comes with this package
x <- db.data.frame("abalone")

x

class(x)

dim(x) # dimension of the data table

names(x) # column names of the data table

summary(x) # look at a summary for each column

preview(x, 20) # look at a sample of the data

preview(sort(x, FALSE, x$id), 20) # look at a sample sorted by id column

preview(sort(x, FALSE, NULL), 20) # look at a sample ordered randomly 

## linear regression Examples --------------------------------------

## linear fit
fit0 <- madlib.lm(rings ~ . - id - sex, data = x)

fit0 # view the result

pred <- predict(fit0, x)

class(pred)

ans <- x$rings # real values

preview((ans - pred)^2, 10)

preview(mean((ans - pred)^2)) # mean squared error

## fit one different model to each group of data with the same sex
fit1 <- madlib.lm(rings ~ . - id | sex, data = x)

fit1

preview(mean((x$rings - predict(fit1, x))^2)) # mean squared error

## plot the predicted values v.s. the true values
ap <- x$rings # true values

ap$pred <- pred # add a column which is the predicted values

## If the data set is very big, you do not want to load all the 
## data points into R and plot. We can just plot a random sample.

random.sample <- preview(sort(ap, FALSE, NULL), 1000) # sort randomly

plot(random.sample)
lines(random.sample$rings, random.sample$rings, col = 'red', lwd = 2)

## ------------------------------------------------------------------------
## fit a single model to all data treating sex as a categorial variable

y <- x # make a copy, y is now a db.data.frame object

y

class(y)

y$sex <- as.factor(y$sex) # y becomes a db.Rquery object now

y

class(y)

z <- as.db.data.frame(y, "dummy")

names(z)

fit2 <- madlib.lm(rings ~ . - id, data = y)

fit2 # view the result

## logistic regression Examples ----------------------------------------

## fit one different model to each group of data with the same sex
fit3 <- madlib.glm(rings < 10 ~ . - id | sex, data = x, family = "binomial")

fit3 # view the result

## ---------------------------------------------------------------------
## fit a single model to all data treating sex as a categorial variable

y <- x # make a copy, y is now a db.data.frame object

y$sex <- as.factor(y$sex) # y becomes a db.Rquery object now

fit4 <- madlib.glm(rings < 10 ~ . - id, data = y, family = "binomial")

fit4 # view the result

## Group by Examples ---------------------------------------------------

## mean value of each column except the "id" column
preview(by(x[,-1], x$sex, mean))

## standard deviation of each column except the "id" column
preview(by(x[,-1], x$sex, sd))

## Merge Examples ----------------------------------

## create two objects with different rows and columns
key(x) <- "id"

y <- x[1:200, 1:6]

z <- x[101:400, c(1,2,4,5)]

m <- merge(y, z, by = c("id", "sex"))

preview(m, 20)

## operator Examples --------

y <- x$length + x$height + 2.3

z <- x$length * x$height / 3

preview(y < z, 20)

## ------------------------------------------------------------------------
## Deal with NULL values

x <- db.data.frame("null_lower")

dim(x)

names(x)

## ERROR, because of NULL values
fit <- madlib.lm(sf_mrtg_pct_assets ~ ris_asset + lncrcd + lnauto + lnconoth + lnconrp + intmsrfv + lnrenr1a + lnrenr2a + lnrenr3a, data = x)

## select columns
y <- x[,c("sf_mrtg_pct_assets","ris_asset", "lncrcd","lnauto","lnconoth","lnconrp","intmsrfv","lnrenr1a","lnrenr2a","lnrenr3a")]

dim(y)

## remove NULL values
for (i in 1:10) y <- y[!is.na(y[i]),]

dim(y)

fit <- madlib.lm(sf_mrtg_pct_assets ~ ., data = y)

fit

x[is.na(x)] <- 45

## ---------- The End --------------
