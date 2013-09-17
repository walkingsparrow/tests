library(PivotalR)
db.connect(port = 14526, dbname = "madlib")

data <- data.frame(tid = seq(0, 100, length.out = 100000),
                   tval = arima.sim(list(order=c(2,0,1), ar=c(0.7, -0.3), ma=0.56), n = 100000) + 3.4)

delete("tseries")
x <- as.db.data.frame(data, "tseries", field.types=list(tid="double precision", tval="double precision"))

x <- db.data.frame("tseries")

dim(x)

names(x)

s <- madlib.arima(tval+2 ~ I(tid + 1), x, order = c(2,0,1))

s

lookat(sort(s$residuals, F, s$residuals$tid), 10)

delete(s)

f <- function() {
    s <- madlib.arima(val ~ id, x, order = c(2,0,1))
    print(s)
    delete(s)
}



s1 <- madlib.arima(x$tval+2, x$tid+1, order = c(2,0,1))

s1

lookat(sort(s1$residuals, F, s1$residuals$tid_opr), 10)

s1$exec.time

lookat(sort(s$residuals, F, s$residuals$tid), 10)

lookat(s$model)

lookat(s$statistics)

pred <- predict(s, n.ahead = 10)

lookat(pred)

pred1 <- predict(s1, n.ahead = 10)

lookat(sort(pred1, F, pred1$steps_ahead))

## clean.madlib.temp()

y <- lookat(sort(x, F, x$tid), "all")

r <- arima(y$tval, order = c(2,0,1), method = "CSS")

r

setMethod (
    "delete",
    signature (x = "arima.css.madlib"),
    def = function (x) {
        delete(x$model)
        delete(x$residuals)
        delete(x$statistics)
    })

delete(s)

## ----------------------------------------------------------------------

library(PivotalR)

db.connect(port = 14526, dbname = "madlib", default.schemas = "madlib")

db.connect(port = 14526, dbname = "madlib", default.schemas = "public")

db.default.schemas()

db.search.path()

db.default.schemas(2)

db.search.path(2)

db.search.path(set="public")
