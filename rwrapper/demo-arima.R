library(PivotalR)
db.connect(port = 14526, dbname = "madlib")

x <- db.data.frame("tseries")

dim(x)

names(x)

lookat(x, 10)

s <- madlib.arima(tval ~ tid, x, order = c(2,0,1))

s

lookat(sort(s$residuals, F, s$residuals$tid), 10)

s1 <- madlib.arima(x$tval, x$tid, order = c(2,0,1))

s1

lookat(sort(s1$residuals, F, s1$residuals$tid_opr), 10)

s1$exec.time

## ----------------------------------------------------------------------

pred <- predict(s, n.ahead = 10)

lookat(sort(pred, F, pred$steps_ahead))


