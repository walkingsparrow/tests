library(PivotalR)
library(rpart)


abalone$r <- abalone$rings < 10

fit <- rpart(r ~ . - id - rings, data = abalone, method = 'c',
             parms = list(split = "information"),
             control = list(maxdepth = 7, minbucket = 1, minsplit = 2, cp = 0.001))

fit

plot(fit)

with(abalone, mean(r == predict(fit, type = 'c')))

tr <- sample(1:nrow(abalone), 2088)
te <- setdiff(1:nrow(abalone), tr)
train <- abalone[tr, ]
test <- abalone[te, ]

fit <- rpart(r ~ . - id - rings, data = train, method = 'c',
             parms = list(split = "information"),
             control = list(maxdepth = 7, minbucket = 1, minsplit = 2, cp = 0.001))

fit

mean(test$r == predict(fit, newdata = test, type = 'c'))

db.connect(port = 5433, dbname = "madlib")

as.db.data.frame(train, "dt_train")
as.db.data.frame(test, "dt_test")
