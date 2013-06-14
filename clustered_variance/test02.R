library(foreign)
library(sandwich)

data <- read.dta("fertil2.dta", convert.factors = FALSE)

dat <- data[!is.na(data$agefbrth) & !is.na(data$usemeth),]

r1 <- lm(ceb ~ age + agefbrth + usemeth, data = dat)

sandwich(r1)

summary(r1)

X <- model.matrix(r1)

Y <- estfun(r1)

X[1:10,]

Y[1:10,]
