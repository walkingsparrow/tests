library(PivotalR)

db.connect(port = 5433)

delete("abalone")
x <- as.db.data.frame(abalone, "abalone")

fit <- madlib.lm(rings ~ . - sex - id, data = x)

fit

pred <- predict(fit, x)

content(pred)

ans <- x$rings

preview((ans - pred)^2, 10)

preview(mean((ans - pred)^2))

content(ans - pred)

## ------------------------------------------------------------------------

fit <- madlib.lm(rings ~ . - id | sex, data = x)

fit

pred <- predict(fit, x)

content(pred)

ans <- x$rings

preview(mean((ans - pred)^2))

## ------------------------------------------------------------------------

pred <- predict(fit, x[x$sex == 'I',])

content(pred)

## ------------------------------------------------------------------------

dat <- db.data.frame("madlibtestdata.lin_forestfires_oi")

dim(dat)

preview(dat, 10)

preview(length(dat[dat$y < 3, 2]))

fit <- madlib.lm(y ~ ., data = dat)

fit

pred <- predict(fit, dat)

content(pred)

preview(pred, 10)

fit <- madlib.glm(y < 3 ~ ., data = dat, family = "binomial")

fit

pred <- predict(fit, dat)

content(pred)

preview(pred, 10)

## ------------------------------------------------------------------------

library(PivotalR)

db.connect(port = 5433)

delete("abalone")
x <- as.db.data.frame(abalone, "abalone")

y <- x[x$rings < 100,]
y1 <- y[y$rings > 10,]

content(y1)

z <- x[x$rings > 10,]
z1 <- z[z$rings < 100,]

content(z1)

v <- y1 + z1

content(v)

w <- x[!(x$rings > 10 & x$rings < 100),]

content(w)

v <- x[!(x$rings < 100 & 10 < x$rings),]

content(v)

u <- w + v

content(u)

delete("abalone")
x <- as.db.data.frame(abalone, "abalone")

fit <- madlib.lm(rings ~ . - id | sex + length + height, data = x)

fit$grps

fit <- madlib.glm(rings < 20 ~ . - id | sex, data = x, family = "binomial")

fit

names(fit)

