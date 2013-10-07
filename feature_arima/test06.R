library(PivotalR)

db.connect(port = 14526, dbname = "madlib")

x <- as.db.data.frame("subject102.dat", "subject102", sep = " ")

dim(x)

y <- cbind(x[,1], x[,7])
names(y) <- c("tid", "tval")

z <- as.db.data.frame(y, "im_hand")

dim(z)

s <- madlib.arima(tval ~ tid, z, order = c(2,0,1), include.mean = TRUE, optim.control = list(max_iter=1))

w <- lookat(sort(z, F, z$tid), "all")

plot(w$tid, w$tval, type = 'l')

r <- arima(w$tval, order = c(2,0,1), include.mean = TRUE, method = "CSS")

r

names(x)
