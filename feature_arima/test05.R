library(PivotalR)
db.connect(port=14526, dbname="madlib")

tbl <- db.data.frame("madlibtestdata.tsa_king_deaths")

ts <- lookat(sort(tbl, F, tbl$id), "all")[,2]

s <- arima(ts, order=c(1,0,1), include.mean=T, method="CSS")

s

s$residuals

ts <- arima.sim(list(order=c(2,0,1), ar=c(0.7, -0.3), ma=0.2), n=1000000) + 3.2

data <- data.frame(tstamp=seq(0,1000,length.out=length(ts)), tval=ts)

delete("tseries")
x <- as.db.data.frame(data, "tseries", field.types=list(tstamp="double precision", tval="double precision"))

s <- arima(ts, order=c(2,0,1), include.mean=T, method="CSS")

s

s$residuals

system.time(arima(ts, order=c(2,0,1), include.mean=T, method="CSS"))
