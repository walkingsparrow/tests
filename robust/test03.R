library(PivotalR)

db.connect(port = 14526, dbname = "madlib")

x <- db.data.frame("madlibtestdata.log_ticdata2000")

x <- db.data.frame("madlibtestdata.log_breast_cancer_wisconsin")

lookat(x, 10)

dim(x)

fit <- madlib.glm(y ~ x, data = x, family = "binomial")

fit

y <- lookat(x, "all")

z <- arraydb.to.arrayr(y$x, "double")

dim(z)

d <- data.frame(y = y$y, z)

names(d)

f <- glm(y ~ . - 1, data = d, family = binomial, x = TRUE, control = list(epsilon = 1e-10, maxit = 10000))

summary(f)

y <- (d$y - 0.5) * 2

coef <- as.vector(f$coefficients)

sm <- rep(0, (dim(d)[2])-1)
for (i in 1:(dim(d))[1]) {
    sm <- sm - y[i] * z[i,] / (1 + exp(y[i] * sum(coef * z[i,])))
}

sm

dim(d)

library(erer)

m <- maBina(f, digits = 5)

names(m)

dim(m$out)

m$out
