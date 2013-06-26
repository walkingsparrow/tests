library(PivotalR)
library(lmtest)
library(sandwich)

db.connect(port = 5433)

x <- db.data.frame("abalone")

madlib.lm(rings ~ height + diameter + length + whole, data = x)

rx <- lookat(x, "all")

rf <- lm(rings ~ height + diameter + length + whole, data = rx)
summary(rf)

coeftest(rf, vcov=vcovHC(rf, type = "HC0"))

rf <- lm(rings ~ log10(height+1) + log10(diameter+1) + length + whole, data = rx)
coeftest(rf, vcov=vcovHC(rf, type = "HC0"))

ap <- x$length
ap$rings <- x$rings

smpl <- lookat(sort(ap, FALSE, "random"), 2000)

plot(smpl)

smpl1 <- lookat(sort(ap, FALSE, "random"), "all")

plot(smpl1)

## ------------------------------------------------------------------------

madlib.lm(I(rings+shell) ~ height + diameter + length + whole, data = x)

rf <- lm(I(rings+shell) ~ height + diameter + length + whole, data = rx)
summary(rf)

coeftest(rf, vcov=vcovHC(rf, type = "HC0"))

## ------------------------------------------------------------------------

madlib.lm(I(rings+shell) ~ height + diameter + length + whole - 1, data = x)

rf <- lm(I(rings+shell) ~ height + diameter + length + whole - 1, data = rx)
summary(rf)

coeftest(rf, vcov=vcovHC(rf, type = "HC0"))

## ------------------------------------------------------------------------

madlib.glm(rings < 10 ~ height + diameter + length + whole, data = x, family = "binomial")

rf <- glm(rings < 10 ~ height + diameter + length + whole, data = rx, family = "binomial")
summary(rf)

coeftest(rf, vcov=vcovHC(rf, type = "HC0"))

## ------------------------------------------------------------------------

rf <- glm(rings < 10 ~ height + diameter + length + whole - 1, data = rx, family = "binomial")
summary(rf)

coeftest(rf, vcov=vcovHC(rf, type = "HC0"))

## ------------------------------------------------------------------------

rf <- glm(rings < 10 ~ log10(height+1) + diameter + length + whole, data = rx, family = "binomial")
summary(rf)

coeftest(rf, vcov=vcovHC(rf, type = "HC0"))
