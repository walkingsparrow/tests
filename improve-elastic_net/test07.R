library(PivotalR)
db.connect(port = 14526, dbname = "madlib")

SAheart <- read.csv("SAHeart_RawData.csv", head=TRUE, sep=",")
SAheart$adiposity <- NULL
SAheart$typea <- NULL
 
X <- scale(subset(SAheart, select=-c(chd)));
y <- SAheart$chd
SAheart_db <- data.frame(y, X)
colnames(SAheart_db)[1] <- "chd"

delete("SAheart_db")
SAheart_db_ptr <- as.db.data.frame(SAheart_db, "SAheart_db")

mlenfit <- madlib.elnet(chd ~ ., data=SAheart_db_ptr, family=c("logistic"), alpha=1, lambda=0.0637, standardize=FALSE, method=c("fista"))

mlenfit

pred <- predict(mlenfit, SAheart_db_ptr)

lk(pred, 10)

lk(mean((SAheart_db_ptr$chd - as.integer(pred))^2))

lk(mean(as.logical(SAheart_db_ptr$chd) != pred))

lk(mean((SAheart_db_ptr$chd - TRUE)^2))

## ----------------------------------------------------------------------

cvfit_pivotal <- generic.cv(
    train = function(data, alpha, lambda) {madlib.elnet(chd ~ ., data=data, family=c("logistic"), alpha=alpha, lambda=lambda, standardize=FALSE)},
    predict = predict,
    metric = function(predicted, actual) { lk(mean((actual$chd-predicted)^2)) },
    data = SAheart_db_ptr,
    params = list(alpha=1, lambda=seq(0,0.1,0.03)), k = 3, find.min=TRUE)

train = function(data, alpha, lambda) {madlib.elnet(chd ~ ., data=data, family=c("logistic"), alpha=alpha, lambda=lambda, standardize=FALSE)}

f <- do.call(train, list(data=SAheart_db_ptr, alpha = 1, lambda=0.05))

