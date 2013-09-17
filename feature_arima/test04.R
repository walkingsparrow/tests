library(PivotalR)

db.connect(port=14526, dbname="madlib")

db.connect(port=12526, dbname="madlib")

x <- db.data.frame("madlibtestdata.tsa_beer")

dat <- lookat(sort(x, F, x$id), "all")

ts <- dat[,2]
for (i in 1:400) ts <- c(ts, dat[,2])

ts <- diff(dat[,2], 2)

plot(ts, type='l')

ts <- arima.sim(list(order = c(2,1,1), ar = c(0.7, -0.3), ma=0.2), n = 10000) + 3.2

dat <- data.frame(tid=1:length(ts), tval=ts)

delete("tseries")
x <- as.db.data.frame(dat, "tseries", field.types=list(tid="integer", tval="double precision"))

s <- arima(ts, order=c(2,1,1), include.mean=T, method="CSS")
s


r <- madlib.arima(ts, 2,1,1, include.mean=FALSE, max.iter = 1000, tau = 1e-3, e1 = 1e-15, e2 = 1e-15, e3= 1e-15)


a <- data.frame(tid=1:length(ts), tval=ts)
delete("tseries")
b <- as.db.data.frame(a, "tseries", field.types=list(tid="integer", tval="double precision"))

## ----------------------------------------------------------------------

x <- db.data.frame("tseries")

dat <- lookat(sort(x, F, x$tid), "all")

ts <- dat[,2]

s <- arima(ts, order=c(2,1,1), method="CSS", include.mean=T)

s

pre <- predict(s, n.ahead = 20)

pre
