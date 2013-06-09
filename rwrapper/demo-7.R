library(PivotalR)

db.connect(port = 5433)

delete("abalone")
x <- as.db.data.frame(abalone, "abalone")

fit <- madlib.lm(rings ~ . - id | sex, data = x)

fit

y <- x$rings

y$pred <- predict(fit, x)

names(y)

dy <- preview(sort(y, FALSE, NULL), 1000)

plot(dy)

plot(dy$rings, dy$pred, cex = 0.2)

## ------------------------------------------------------------------------

y <- x$length + x$height + 2.3
z <- x$length * x$height / 3

preview(y < z, 20)

## ------------------------------------------------------------------------

x <- db.data.frame('abalone', key = 'id')

y <- db.data.frame('abalone')

eql(x, y)

y <- x[1:20, 1:6]
z <- x[21:40, c(1,7,8)]

m <- merge(y, z)

content(m)
