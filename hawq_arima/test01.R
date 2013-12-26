ts <- arima.sim(list(order=c(2,0,1), ar=c(0.7, -0.3), ma=0.2), n=5000000) + 3.2

data <- data.frame(tstamp=seq(0,1000,length.out=length(ts)), tval=ts)

library(PivotalR)
db.connect(port = 14526, dbname = "madlib")

save(data, file = "tseries.rda")

load("../hawq_arima/tseries.rda")

delete("tseries")
x <- as.db.data.frame(data, "tseries", field.types=list(tstamp="double precision", tval="double precision"))
