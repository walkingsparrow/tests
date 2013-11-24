library(nnet)

data("Fishing", package = "mlogit")
Fish <- mlogit.data(Fishing, varying = c(2:9), shape = "wide", choice = "mode")

fish <- rbind(Fishing, c(1,2,3,NA,NA,0,0,0,0,NA))

fit <- multinom(mode ~ ., data = Fishing, na.action = na.omit)

s <- summary(fit)

## a formula with to alternative specific variables (price and catch) and
## an intercept
f1 <- mFormula(mode ~ price + catch)
head(model.matrix(f1, Fish), 2)

## same, with an individual specific variable (income)
f2 <- mFormula(mode ~ price + catch | income)
head(model.matrix(f2, Fish), 2)

## same, without an intercept
f3 <- mFormula(mode ~ price + catch | income + 0)
head(model.matrix(f3, Fish), 2)

## same as f2, but now, coefficients of catch are alternative specific
f4 <- mFormula(mode ~ price | income | catch)
head(model.matrix(f4, Fish), 2)

summary(mlogit(alt ~ price + catch, data = Fish))
