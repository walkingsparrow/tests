## use stepwise model selection
library(PivotalR)
library(glmnet)
library(ggplot2)
db.connect(port = 5433, dbname = "madlib")

setwd("~/workspace/rwrapper/insurance_demo")
source("getData.R")
ticcompl <- getData()

pos <- sum(ticcompl[,86] == 1)
neg <- sum(ticcompl[,86] == 0)

sampleSize <- 20000 # nrow(ticcompl)

dat <- ticcompl[sample(nrow(ticcompl), sampleSize, replace = TRUE, prob = ifelse(ticcompl[,86]==1, neg, pos)),]

delete("ticcompl")
as.db.data.frame(dat, "ticcompl")

dataset <- ticcompl[sample(nrow(ticcompl), sampleSize, replace = TRUE, prob = ifelse(ticcompl[,86]==1, neg, pos)),]
traindataset <- ticcompl[sample(nrow(ticcompl), sampleSize, replace = TRUE, prob = ifelse(ticcompl[,86]==1, neg, pos)),]

predictLogisticRegression <- function(cutoff = 0.5) {
    glmmodel <- trainLogisticRegression()
    Xtest <- model.matrix(CARAVAN ~ . , data=dataset)
    predictions <- predict(glmmodel,Xtest,type='response')
    predictions <- as.vector(predictions)
    predictions <- ifelse(predictions < cutoff, FALSE, TRUE)
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

gf <- trainLogisticRegression()

## system.time(trainLogisticRegression()) ## 22.7 sec

pred <- predictLogisticRegression(0.5)

## system.time(predictLogisticRegression(0.5)) ## 24.3 sec

gf$lambda.min

gf$lambda.1se

select <- which(gf$glmnet.fit$lambda == gf$lambda.1se)
beta <- gf$glmnet.fit$beta[,select]
a0 <- gf$glmnet.fit$a0[select]

paste(names(beta)[beta != 0], collapse = "+")

length(names(beta)[beta != 0])

## ----------------------------------------------------------------------

plotData <- dataset

plotData$predictions <- pred[[1]]

plotData$predictions <- ifelse(plotData$predictions,'black','Predict No Buy')
plotData$predictions <- ifelse(plotData$predictions == 'black',
                               ifelse(plotData$CARAVAN == 1,'Correctly Predicted Buy','Incorrectly Predicted Buy'),
                               plotData$predictions)

p <- ggplot(plotData, aes_string(x="MOSHOOFD", y="MGEMLEEF")) + theme(axis.text.x = element_text(angle = 40, hjust = 1))

p <- p + xlab(col_dict[names(ticcompl) == input$x]) + ylab(col_dict[names(ticcompl) == input$y])

## if (input$color != 'None')
p <- p + aes_string(color=input$color)

width_strength <- ifelse(is.factor(ticcompl[["MOSHOOFD"]]),
                         nlevels(ticcompl[["MOSHOOFD"]]),
                         diff(range(ticcompl[["MOSHOOFD"]]))) * 0.01 * 1

height_strength <- ifelse(is.factor(ticcompl[["MGEMLEEF"]]),
                          nlevels(ticcompl[["MGEMLEEF"]]),
                          diff(range(ticcompl[["MGEMLEEF"]]))) * 0.01 * 1

p <- p + geom_jitter(position=position_jitter(width=width_strength,height=height_strength),alpha=1)

## } else {
    ## p <- p + geom_point(alpha=input$alphaStrength)
## }

colorpalette <- c("Correctly Predicted Buy" = "green","Predict No Buy" = "grey","Incorrectly Predicted Buy" = "grey30")

p <- p + aes_string(color='predictions') + scale_colour_manual(values = colorpalette)

print(p)

## ----------------------------------------------------------------------

plotData <- dataset

plotData$predictions <- pred[[1]]

nPredictions <- length(which(plotData$predictions))
nSuccPredictions <- length(which(plotData$predictions & plotData$CARAVAN == 1))
nInsurances <- length(which(plotData$CARAVAN == 1))

input <- list(mktReturn = 100, mktCost = 1)

succSpend <- nSuccPredictions/nPredictions*100
realPot <- nSuccPredictions/nInsurances*100
roi <- (nSuccPredictions*as.numeric(input$mktReturn)*100)/(nPredictions*as.numeric(input$mktCost))-100

values <- c(nPredictions*as.numeric(input$mktCost),
            nSuccPredictions*as.numeric(input$mktCost),
            succSpend,
            nInsurances*as.numeric(input$mktReturn),
            nSuccPredictions*as.numeric(input$mktReturn),
            realPot,
            roi)

tradTargeting <- function() {
    plotData <- selectedData()
    
    succSpend <- length(which(plotData$comb_range & plotData$CARAVAN == 1))/length(which(plotData$comb_range))*100
    realPot <- length(which(plotData$comb_range & plotData$CARAVAN == 1))/length(which(plotData$CARAVAN == 1))*100
    roi <- ((length(which(plotData$comb_range & plotData$CARAVAN == 1))*as.numeric(input$mktReturn))/
              (length(which(plotData$comb_range))*as.numeric(input$mktCost)))*100-100
    
    values <- c(length(which(plotData$comb_range))*as.numeric(input$mktCost),
                length(which(plotData$comb_range & plotData$CARAVAN == 1))*as.numeric(input$mktCost),
                succSpend,
                length(which(plotData$CARAVAN == 1))*as.numeric(input$mktReturn),
                length(which(plotData$comb_range & plotData$CARAVAN == 1))*as.numeric(input$mktReturn),
                realPot,
                roi)
    
    return(values)
  })
  
                                        # Traditional Targeting
valuesTrad <- tradTargeting()

ratio <- values/valuesTrad
ratio <- round(ratio,digits=2)
values[c(3,6,7)] <- paste(round(values[c(3,6,7)],digits=2),'%')
valuesTrad[c(3,6,7)] <- paste(round(valuesTrad[c(3,6,7)],digits=2),'%')

data.frame(row.names=descriptions,Model.Targeting=values,Traditional.Targeting=valuesTrad, Ratio=ratio)

logreg <- pred[[2]]

data.frame(row.names=impVarNames,Importance=impVars)

## ----------------------------------------------------------------------

delete("demo_train"); delete("demo_valid")
traindat <- as.db.data.frame(traindataset, "demo_train")
dat <- as.db.data.frame(dataset, "demo_valid")

fit <- madlib.glm(CARAVAN ~ ., data = traindat, family = "binomial")

pred <- predict(fit, dat, "prob")

res <- lk(cbind2(dat, pred), -1)

## m0 <- madlib.glm(CARAVAN ~ MOSTYPE, family = "binomial", data = dat)

## mstep <- step(m0, scope = list(lower = CARAVAN ~ MOSTYPE, upper = CARAVAN ~ .))

## step(fit)

fit <- madlib.glm(CARAVAN ~ MOPLLAAG + MBERBOER + MBERMIDD + MOPLHOOG + MHHUUR + MAUT1 + MAUT0 + MINKM30 + MINKGEM + PWAPART + PPERSAUT + PBESAUT + PBRAND + AWALAND + APERSAUT + APLEZIER, data = traindat, family = "binomial")

pred <- predict(fit, dat, "prob")

res <- lk(cbind2(dat, pred), -1)

## ----------------------------------------------------------------------

plotData <- res[,-87]

plotData$predictions <- res[,87] > 0.5

nPredictions <- length(which(plotData$predictions))
nSuccPredictions <- length(which(plotData$predictions & plotData$CARAVAN == 1))
nInsurances <- length(which(plotData$CARAVAN == 1))

input <- list(mktReturn = 100, mktCost = 1)

succSpend <- nSuccPredictions/nPredictions*100
realPot <- nSuccPredictions/nInsurances*100
roi <- (nSuccPredictions*as.numeric(input$mktReturn)*100)/(nPredictions*as.numeric(input$mktCost))-100

values <- c(nPredictions*as.numeric(input$mktCost),
            nSuccPredictions*as.numeric(input$mktCost),
            succSpend,
            nInsurances*as.numeric(input$mktReturn),
            nSuccPredictions*as.numeric(input$mktReturn),
            realPot,
            roi)

values

## ----------------------------------------------------------------------

lambda <- 0.00479

fit <- madlib.elnet(CARAVAN ~ ., data = traindat, family = "binomial", alpha = 1, lambda = lambda, control = list(random.stepsize=TRUE))

fit

sum(fit$coef != 0)

system.time(madlib.elnet(CARAVAN ~ ., data = traindat, family = "binomial", alpha = 1, lambda = lambda, control = list(random.stepsize=TRUE, eta=1.5)))

system.time(madlib.elnet(CARAVAN ~ ., data = traindat, family = "binomial", method = "cd", alpha = 1, lambda = lambda, control = list(verbose=FALSE)))

s <- sample(traindat, 1000)

x <- traindat
s <- as.db.data.frame(sort(x, FALSE, "random"), "tmp23", FALSE, FALSE, TRUE, FALSE, x@.dist.by, 1000)

fit <- generic.cv(train = function(data, lambda) madlib.elnet(CARAVAN ~ ., data = data, family = "binomial", method = "fista", alpha = 1, lambda = lambda, control = list(random.stepsize=TRUE, eta=1.5)), predict = predict, metric = function(predicted, actual) lk(mean(as.logical(actual[,86]) != predicted)), k = 5, find.min = TRUE, data = traindat, params = list(lambda = seq(0.001, 0.006, length.out=10)))

plot(fit$params[,1], fit$metric$avg, type = 'b')
