library(PivotalR)
library(glmnet)

db.connect(port = 14526, dbname = "madlib")

db.connect(port = 5433, dbname = "madlib")

require(pROC)

numFolds <- 5
alphaVal <- 1

## Load the data to be used
SAheart <- read.csv("SAHeart_RawData.csv", head=TRUE, sep=",")
SAheart$adiposity <- NULL
SAheart$typea <- NULL

## Determine Lasso paths
X_glmnet <- scale(subset(SAheart, select=-c(chd)))
y_glmnet <- SAheart$chd

paths_EN <- glmnet(X_glmnet, y_glmnet, family=c("binomial"), alpha=alphaVal, standardize=FALSE, intercept=TRUE)

plot(paths_EN)

 

# Find optimal lambda with cross-validation
tic_R <- proc.time()[3]
cvfit <- cv.glmnet(X_glmnet, y_glmnet, family=c("binomial"), nfolds=numFolds, alpha=alphaVal, type.measure="mse", standardize=FALSE)
toc_R <- proc.time()[3] - tic_R

betas <- coef(cvfit, s=cvfit$lambda.1se)

betas

plot(cvfit)

print(cvfit$lambda.1se)

## PivotalR ----------------------------------------------------------------------

if (db.existsObject("SAheart_db") == TRUE) {
    print("Data set exists -- reading ...")
    SAheart_db_ptr <- db.data.frame("SAheart_db")
} else {
    print("Data set does not exist -- creating")
    SAheart_db <- data.frame(SAheart$chd, scale(subset(SAheart, select=-c(chd))))
    colnames(SAheart_db)[1] <- "chd"   
    SAheart_db_ptr <- as.db.data.frame(SAheart_db, "SAheart_db")   
}

lambda_vec <- c(sort(cvfit$lambda))

tic_P <- proc.time()[3]
fit1 <- madlib.elnet(chd ~ ., data=SAheart_db_ptr, family="logistic", alpha=1, lambda=0.04, standardize=FALSE, control = list(random.stepsize=TRUE, eta=1.5))
proc.time()[3] - tic_P

tic_P <- proc.time()[3]
fit <- madlib.elnet(chd ~ ., data=SAheart_db_ptr, family="logistic", alpha=1, lambda=0.04, standardize=FALSE, method = "cd")
proc.time()[3] - tic_P

## ----------------------------------------------------------------------

tic_P <- proc.time()[3]

cvfit_pivotal <- generic.cv(
    train = function(data, alpha, lambda) {madlib.elnet(chd ~ ., data=data, family="logistic", alpha=alpha, lambda=lambda, standardize=FALSE, control = list(random.stepsize=TRUE))},
    predict = predict,
    metric = function(predicted, actual) { lk(mean(as.logical(actual$chd) != predicted)) },
    data = SAheart_db_ptr,
    params = list(alpha=alphaVal, lambda=lambda_vec), k=numFolds, find.min=TRUE)

toc_P <- proc.time()[3] - tic_P

plot(cvfit_pivotal$params[,2], cvfit_pivotal$metric$avg, type = 'b')
