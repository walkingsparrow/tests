library(PivotalR)

db.connect(port = 14526, dbname = "madlib")

x <- db.data.frame("abalone")

cv <- generic.cv(train = function(data) {madlib.lm(rings ~ . - id - sex, data = data)},
                 predict = predict,
                 metric = function(predicted, data) {lookat(mean((data$rings - predicted)^2))},
                 data = x, k = 10)

cv

## ------------------------------------------------------------------------

bg <- generic.bagging(train = function(data) {madlib.lm(rings ~ . - id - sex, data = data)},
                      data = x, nbags = 10, fraction = 0.85)

pred <- predict(bg, newdata = x) # make prediction

lookat(mean((x$rings - pred)^2)) # mean squared error


