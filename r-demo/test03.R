library(PivotalR)
library(glmnet)
options(digits = 5, width=150)

log.likelihood2 <- function(x, y, coef, a0, lambda, alpha, scaling = FALSE, weights = rep(1, length(y)))
{
    s <- 0
    weights <- weights*length(y) / sum(weights)
    for (i in seq(length(y)))
    {
        t <- sum(coef * x[i,]) + a0
        if (y[i] == TRUE)
            s <- s + log(1 + exp(-t)) * weights[i]
        else
            s <- s + log(1 + exp(t)) * weights[i]
    }
    s <- s / length(y)
    if (!scaling)
    {
        s <- s + 0.5 * lambda * (1 - alpha) * sum(coef * coef) + lambda * alpha * sum(abs(coef))
    }
    else
    {
        xsd <- apply(x, 2, sd) * sqrt(1 - 1./length(y))
        s <- s + 0.5 * lambda * (1- alpha) * sum((coef * xsd)^2) + lambda * alpha * sum(abs(coef * xsd))
    }
    as.numeric(-s)
}

db.connect(port = 5433, dbname = "madlib")

dat <- db.data.frame("madlibtestdata.dt_abalone")

fit <- madlib.elnet(rings<10 ~ . - id - sex + weight(as.integer(sex=="M")+0.5), data = dat, family = "binomial", method = "cd", alpha = 1, lambda = 0.03, control = list(tolerance = 1e-6), standardize = FALSE)

fit

d <- lk(dat, -1)

x <- as.matrix(d[,-c(1,2,10)])
y <- as.vector(d[,10]<10)

g <- glmnet(x, y, alpha = 1, lambda = 0.03, family = "binomial", weights = (d[,2]=="M")+0.1, standardize = FALSE)

g$beta
g$a0

w <- (d[,2]=="M")+0.1

log.likelihood2(x, y, fit$coef, fit$intercept, 0.03, 1, FALSE, w)

log.likelihood2(x, y, g$beta, g$a0, 0.03, 1, FALSE, w)


## ----------------------------------------------------------------------

dat <- db.data.frame("madlibtestdata.pca_mat_200_200")

dim(dat)

names(dat)

fit <- madlib.lm(row_vec[1] ~ row_vec[2:199], data = dat)

fit

content(with(dat, c(row_vec[1:2], row_vec[3:4])))

c(dat$row_vec[1:2], dat$row_vec[3:4])

vdata <- PivotalR:::.expand.array(dat)

eval(parse(text = paste("with(dat, row_vec[1])")))

content(eval(parse(text = paste("with(dat, row_vec)"))))

fit <- madlib.glm(rings < 0.8*mean(rings) ~ . - id - sex | sex=="M", data = dat, family = "binomial")

fit

content(predict(fit, dat))

lk(predict(fit, dat, type = "prob"), 10)

## ----------------------------------------------------------------------

dat <- db.data.frame("madlibtestdata.lin_auto_mpg_wi")

fit <- madlib.elnet(y ~ x, data = dat, family = "")


dat <- db.data.frame("madlibtestdata.log_breast_cancer_wisconsin")

fit <- madlib.elnet(y ~ x - x[1:2], data = dat, family = "binomial", alpha = 0.1, lambda = 0.0, method = "cd", control = list(tolerance = 1e-6), standardize = T)

fit

madlib.glm(y ~ . - x[1:2], data = dat, family = "binomial")
