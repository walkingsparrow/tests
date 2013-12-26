

library(PivotalR)
library("glmnet")

db.connect(port = 14526, dbname = "madlib")

db.connect(port = 5433, dbname = "madlib")

setwd("~/workspace/rwrapper/insurance_demo")

source("getData.R")

ticcompl <- getData()

## as.db.data.frame(ticcompl, "ticcompl")

tmp <- ticcompl
names(tmp) <- tolower(names(tmp))
as.db.data.frame(tmp, "ticcompl_l")

dim(ticcompl)

sampleSize <- 4000 # nrow(ticcompl)

dataset <- ticcompl[sample(nrow(ticcompl), sampleSize),]
  
traindataset <- ticcompl[sample(nrow(ticcompl), sampleSize),]

predictLogisticRegression <- function() {
    glmmodel <- trainLogisticRegression()
    Xtest <- model.matrix(CARAVAN ~ . , data=dataset())
    predictions <- predict(glmmodel,Xtest,type='response')
    predictions <- as.vector(predictions)
    predictions <- ifelse(predictions < input$classCutoffLR,FALSE,TRUE)
    return(list(predictions,glmmodel))
}

trainLogisticRegression <- function() {
    trainData <- traindataset
    posPrior <- length(which(trainData$CARAVAN == 1))/length(trainData$CARAVAN)
    negPrior <- length(which(trainData$CARAVAN == 0))/length(trainData$CARAVAN)
    weightvec <- ifelse(trainData[,86] == 0,posPrior,negPrior)
    X <- model.matrix(CARAVAN ~ . , data=trainData)
    glmmodel <- cv.glmnet(x=X,y=trainData[,86],family="binomial",nfolds=3,weights=weightvec)
    return(glmmodel)
}

dat <- db.data.frame("ticcompl_l")

dim(dat)

names(dat)

gf <- trainLogisticRegression()

plot(gf)

gf$lambda.1se

gf$lambda.min

fit <- madlib.elnet(caravan ~ ., data = dat, family = "binomial", alpha = 1, lambda = 0.03, method = "cd")

fit
