library(PivotalR) # load the package

## get the help in web browser
help.start()

## get the help for the package
help("PivotalR-package")

## get the help for one method
help("preview,db.Rquery-method")

## get help for a function
help(madlib.lm)

## create multiple connections to different databases
db.connect(port = 14526, dbname = "madlib") # connection 1, use default values for the parameters

db.connect(dbname = "test", user = "qianh1", password = "", host = "remote.machine.com", madlib = "madlib07", port = 5432) # connection 2

db.list() # list the info for all the connections

## list all tables/views that has "ornst" in the name
db.objects("ornst")

## list all tables/views
db.objects(conn.id = 1)

## create a table and the R object pointing to the table
## using the example data that comes with this package
delete("abalone")
x <- as.db.data.frame(abalone, "abalone")

## OR if the table already exists, you can create the wrapper directly
x <- db.data.frame("abalone")

dim(x) # dimension of the data table

names(x) # column names of the data table

madlib.summary(x) # look at a summary for each column

preview(x, 20) # look at a sample of the data

preview(sort(x, decreasing = FALSE, x$id), 20) # look at a sample sorted by id column

preview(sort(x, FALSE, NULL), 20) # look at a sample ordered randomly 

## linear regression Examples --------

## fit one different model to each group of data with the same sex
fit1 <- madlib.lm(rings ~ . - id | sex, data = x)

fit1 # view the result

preview(mean((x$rings - predict(fit1, x))^2)) # mean square error

## plot the predicted values v.s. the true values
ap <- x$rings # true values
ap$pred <- predict(fit1, x) # add a column which is the predicted values

## If the data set is very big, you do not want to load all the 
## data points into R and plot. We can just plot a random sample.
random.sample <- preview(sort(ap, FALSE, "random"), 1000) # sort randomly

plot(random.sample)

## fit a single model to all data treating sex as a categorial variable
y <- x # make a copy, y is now a db.data.frame object
y$sex <- as.factor(y$sex) # y becomes a db.Rquery object now
fit2 <- madlib.lm(rings ~ . - id, data = y)

fit2 # view the result

preview(mean((y$rings - predict(fit2, y))^2)) # mean square error

## logistic regression Examples --------

## fit one different model to each group of data with the same sex
fit3 <- madlib.glm(rings < 10 ~ . - id | sex, data = x, family = "binomial")

fit3 # view the result

## the percentage of correct prediction
preview(mean((x$rings < 10) == predict(fit3, x)))

## fit a single model to all data treating sex as a categorial variable
y <- x # make a copy, y is now a db.data.frame object
y$sex <- as.factor(y$sex) # y becomes a db.Rquery object now
fit4 <- madlib.glm(rings < 10 ~ . - id, data = y, family = "binomial")

fit4 # view the result

## the percentage of correct prediction
preview(mean((y$rings < 10) == predict(fit4, y)))

## Group by Examples --------

## mean value of each column except the "id" column
preview(by(x[,-1], x$sex, mean))

## standard deviation of each column except the "id" column
preview(by(x[,-1], x$sex, sd))

## Merge Examples --------

## create two objects with different rows and columns
key(x) <- "id"
y <- x[1:20, 1:6]
z <- x[11:30, c(1,2,4,5)]

m <- merge(y, z, by = c("id", "sex"))

preview(sort(m, FALSE, m$id), "all")

m <- merge(y, z, by = c("id", "sex"), all.x = TRUE)

preview(sort(m, FALSE, m$id), "all")

## operator Examples --------

y <- x$length + x$height + 2.3
z <- x$length * x$height / 3

preview(y < z, 20)

## ------------------------------------------------------------------------
## Deal with NULL values

## a table that contains NULL values
x <- db.data.frame("fdic_lower")

dim(x)

names(x)

## ERROR, because of NULL values
fit <- madlib.lm(sf_mrtg_pct_assets ~ ris_asset + lncrcd + lnauto + lnconoth + lnconrp + intmsrfv + lnrenr1a + lnrenr2a + lnrenr3a, data = x)

## We want to remove NULL values

## select columns
y <- x[,c("sf_mrtg_pct_assets","ris_asset", "lncrcd","lnauto","lnconoth","lnconrp","intmsrfv","lnrenr1a","lnrenr2a","lnrenr3a")]

dim(y)

## remove NULL values
for (i in 1:10) y <- y[!is.na(y[i]),]

content(y)

dim(y)

fit <- madlib.lm(sf_mrtg_pct_assets ~ ., data = y)

fit

## Or we can replace all NULL values
x[is.na(x)] <- 0


