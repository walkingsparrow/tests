library(PivotalR)

db.connect(port = 14526, dbname = "madlib")

x <- db.data.frame("madlibtestdata.rf_abalone")

fit <- madlib.lm(rings ~ length + diameter + height, data = x)

fit

dim(x)

rx <- preview(x, 5000)

rf <- lm(rings ~ length + diameter + height, data = rx)

summary(rf)

library(car)
library(lmtest)
library(sandwich)

coeftest(rf, vcov=vcovHC(rf, type = "HC0")) 

## ------------------------------------------------------------------------

fit <- madlib.lm(rings ~ log2(length) + diameter + height, data = x)

fit

dim(x)

rf <- lm(rings ~ log(length) + diameter + height, data = rx)

summary(rf)

rf1 <- rf

log(1.2)

log10(1.2)

coeftest(rf, vcov=vcovHC(rf, type = "HC0")) 

## ------------------------------------------------------------------------

rf <- lm(rings ~ log10(length) + exp(diameter) + I((height+1)/2), data = rx)

summary(rf)

coeftest(rf, vcov = vcovHC(rf, type = "HC0"))

## ------------------------------------------------------------------------

db.connect(port = 14526, dbname = "madlib")

y <- db.data.frame("madlibtestdata.lin_winequality_white_oi", 2)

dim(y)

ry <- preview(y, 5000)

ry[1:2,]

z <- arraydb.to.arrayr(ry$x, "double")

v <- data.frame(cbind(z, ry$y))

names(v)

rf <- lm(X13 ~ ., data = v)

summary(rf)

## ------------------------------------------------------------------------

library(PivotalR)

db.connect(port = 14526, dbname = "madlib")

x <- db.data.frame("madlibtestdata.rf_abalone")

fit <- madlib.glm(rings<10 ~ length + diameter + height, data = x, family = "binomial")

fit

ry <- preview(x, 5000)

rfit <- glm(rings<10 ~ length + diameter + height, data = ry, family = binomial)

summary(rfit)

library(car)
library(lmtest)
library(sandwich)

coeftest(rfit, vcov=vcovHC(rfit, type = "HC0")) 
