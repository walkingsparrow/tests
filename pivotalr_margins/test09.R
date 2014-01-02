library(PivotalR)
db.connect(port = 5433, dbname = "madlib")

dat <- db.data.frame("madlibtestdata.dt_abalone")

fit <- madlib.glm(rings < 10 ~ . - id - sex, data = dat, family = "logistic")

fit <- madlib.glm(rings ~ . - id - sex, data = dat, family = "linear")

fit

fit <- madlib.glm(rings < 10 ~ length + diameter + diameter:sex, data = dat, family = "logistic")

fit

margins(fit, factor.continuous = FALSE)

margins(fit, factor.continuous = TRUE)

fit <- madlib.glm(rings < 10 ~ length + sex, data = dat, family = "logistic")

fit

margins(fit, factor.continuous = TRUE)

margins(fit, factor.continuous = FALSE)

d <- lk(dat, -1)

summary(lm(rings ~ length + sex - 1, data = d))

madlib.glm(rings ~ length + sex - 1, data = dat, family = "linear")

summary(lm(rings ~ length + diameter + diameter:sex, data = d))

summary(lm(rings ~ length + diameter + log(1+sex), data = d))

f <- lm(rings ~ length + diameter + diameter:sex, data = d)

f$coefficients

mean(with(d, (3.5003410 - 9.5902565*length + 28.8461888*diameter - 2.4633656*diameter*(1) - 0.3040375*diameter*(sex=="M")) - (3.5003410 - 9.5902565*length + 28.8461888*diameter - 2.4633656*diameter*(0) - 0.3040375*diameter*(sex=="M"))))

mean(with(d, - 2.4633656*diameter))

## ----------------------------------------------------------------------

fit <- madlib.glm(rings < 10 ~ diameter + diameter:sex, data = dat, family = "logistic")

fit

margins(fit, factor.continuous = TRUE)

margins(fit, factor.continuous = FALSE)

b <- fit$coef

mean(with(d, 1/(1+exp(-(b[1] + b[2]*diameter + b[3]*diameter*(0) + b[4]*diameter*(1)))) - 1/(1+exp(-(b[1] + b[2]*diameter + b[3]*diameter*(0) + b[4]*diameter*(0))))))

mean(with(d, 1/(1+exp(-(b[1] + b[2]*diameter + b[3]*diameter*(1) + b[4]*diameter*(0)))) - 1/(1+exp(-(b[1] + b[2]*diameter + b[3]*diameter*(0) + b[4]*diameter*(0)))))) 


g <- data.frame(a = 1:3, b = c('m', 'f', 'i', 'l'), e = 2:4, y = 2:4)

terms(y ~ e + a:b, data = g)

f <- lm(rings ~ length + diameter + diameter:sex, data = d)

names(f)

f <- lm(rings ~ length + diameter + (diameter+shell):sex, data = d)

summary(f)

f <- lm(rings ~ length + diameter + diameter:shell:sex, data = d)

summary(f)

test <- function(formula, data)
{
    mf <- match.call(expand.dots = FALSE)
    m <- match(c("formula", "data"), names(mf), 0L)
    mf <- mf[c(1L, m)]
    mf$drop.unused.levels <- TRUE
    mf[[1L]] <- quote(stats::model.frame)
    mf <- eval(mf, parent.frame())
    mt <- attr(mf, "terms")
    x <- model.matrix(mt, mf, contrasts)
    colnames(x)
}

g <- data.frame(a = rep(1, 2), b = c('m', 'f'), e = c(1,1), y = c(1,1))

terms(y ~ e + a + a:b, data = g)

test(y ~ e + a + a:b, g)


f <- glm(rings < 10 ~ length + diameter + diameter:sex, data = d, family = "binomial")

b <- f$coefficients

with(d, 1/(1+exp(-(b[1] + b[2]*mean(length) + b[3]*mean(diameter) + b[4]*mean(diameter)*(0) + b[5]*mean(diameter)*(1)))) - 1/(1+exp(-(b[1] + b[2]*mean(length) + b[3]*mean(diameter) + b[4]*mean(diameter)*(0) + b[5]*mean(diameter)*(0)))))

with(d, 1/(1+exp(-(b[1] + b[2]*mean(length) + b[3]*mean(diameter) + b[4]*mean(diameter)*(1) + b[5]*mean(diameter)*(0)))) - 1/(1+exp(-(b[1] + b[2]*mean(length) + b[3]*mean(diameter) + b[4]*mean(diameter)*(0) + b[5]*mean(diameter)*(0)))))

with(d, 1/(1+exp(-(b[1] + b[2]*mean(length) + b[3]*mean(diameter) + b[4]*mean(diameter)*(0) + b[5]*mean(diameter)*(1)))) - 1/(1+exp(-(b[1] + b[2]*mean(length) + b[3]*mean(diameter) + b[4]*mean(diameter)*(0) + b[5]*mean(diameter)*(0)))))

with(d, b[2]*(1/(1+exp(-(b[1] + b[2]*mean(length) + b[3]*mean(diameter) + b[4]*mean(diameter)*mean(sex=="I") + b[5]*mean(diameter)*mean(sex=="M")))))*(1 - 1/(1+exp(-(b[1] + b[2]*mean(length) + b[3]*mean(diameter) + b[4]*mean(diameter)*mean(sex=="I") + b[5]*mean(diameter)*mean(sex=="M"))))))

with(d, (b[3] + b[4]*mean(sex=="I") + b[5] * mean(sex == "M"))*(1/(1+exp(-(b[1] + b[2]*mean(length) + b[3]*mean(diameter) + b[4]*mean(diameter)*mean(sex=="I") + b[5]*mean(diameter)*mean(sex=="M")))))*(1 - 1/(1+exp(-(b[1] + b[2]*mean(length) + b[3]*mean(diameter) + b[4]*mean(diameter)*mean(sex=="I") + b[5]*mean(diameter)*mean(sex=="M"))))))


fit <- madlib.glm(rings < 10 ~ length + diameter + diameter:sex, data = dat, family = "logistic")

fit

margins(fit, factor.continuous = FALSE)

margins(fit, factor.continuous = TRUE)
