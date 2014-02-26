library(PivotalR)
db.connect(port = 16526, dbname = "madlib")

x <- db.data.frame("madlibtestdata.dt_abalone")

err <- generic.cv(
    function(data) {
        madlib.lm(rings ~ . , data = data)
    },
    predict,
    function(predicted, data) {
        lookat(mean((data$rings - predicted)^2))
    }, data = x)

err

fit <- generic.bagging(
    function(data) {
        madlib.lm(rings ~ . - id - sex, data = data)
    }, data = x, nbags = 25, fraction = 0.7)

data.use <- sample(x, 100, replace = TRUE)

data.use@.dim

dim(data.use)

names(data.use)

class(data.use)

lk(data.use, 10)

madlib.lm(rings ~ . - id - sex, data = data.use)

ncol(data.use)

dim(x)

x@.dim

## ----------------------------------------------------------------------

x <- matrix(rnorm(100*20),100,20)
y <- rnorm(100, 0.1, 2)

dat <- data.frame(x, y)

delete("eldata")
z <- as.db.data.frame(dat, "eldata")

g <- generic.cv(
    train = function (data, alpha, lambda) {
        madlib.elnet(y ~ ., data = data, family = "gaussian",
                     alpha = alpha, lambda = lambda,
                     control = list(random.stepsize=TRUE))
    },
    predict = predict,
    metric = function (predicted, data) {
        lk(mean((data$y - predicted)^2))
    },
    data = z,
    params = list(alpha=1, lambda=seq(0,0.2,0.1)),
    k = 5, find.min = TRUE)

plot(g$params$lambda, g$metric$avg, type = 'b')

g$best

madlib.elnet(V21 ~ ., data = z, family = "gaussian",
             alpha = 1, lambda = 0.1)

names(z)
