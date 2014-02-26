library(PivotalR)
db.connect(port = 5433, dbname = "madlib")

library(rpart)

names(kyphosis)
names(kyphosis) <- c("kyphosis", "age", "number", "start")

db.q("create schema madlibtestdata")
delete("madlibtestdata.kyphosis")
as.db.data.frame(kyphosis, "madlibtestdata.kyphosis")

fit <- rpart(kyphosis ~ age + number + start, data = kyphosis, parms = list(split = "information"),
             control = list(maxdepth = 4, minbucket = 1, minsplit = 2))


fit

mean(kyphosis$kyphosis == predict(fit, type = "class"))

names(fit)

plotcp(fit)

printcp(fit)

info <- function(p) sum(ifelse(p == 0, 0, -p * log(p)))

info(c(0.79010000, 0.20990000))

46/81 * info(c(0.95651586, 0.04348414)) + 35/81 * info(c(0.57139393, 0.42860607))

info(c(0.57139393, 0.42860607))

10/35 * info(c(0.89998727, 0.10001273)) + 25/35 * info(c(0.43996515, 0.56003485))

10/35 * info(c(0.9, 0.1)) + 25/35 * info(c(0.44, 0.56))

info(c(0.43996515, 0.56003485))

12/25 * info(c(0.58329895, 0.41670105)) + 13/25 * info(c(0.30766218, 0.69233782))

22/25 * (2/22 * info(c(1,0)) + 20/22 * info(c(0.3, 0.7))) + 3/25 * info(c(1,0))
