hilbert <- function(n) { i <- 1:n; 1 / outer(i - 1, i, "+") }
h8 <- hilbert(8); h8

coef <- solve(h8, rep(1,8))

h8 %*% coef

library(PivotalR)
db.connect(port = 14526, dbname = "madlib")
db.connect(port = 12526, dbname = "madlib")

dat <- as.data.frame(h8)
dat$row_id <- 0:7
delete("s_tmp")
x1 <- as.db.data.frame(dat, "s_tmp")
x2 <- x1$row_id
x2$row_vec <- rowAgg(x1[,1:8])
delete("s_dm")
x3 <- as.db.data.frame(x2, "s_dm")

y <- data.frame(row_id = 0:7, val = rep(1,8))
delete("y_sm")
y1 <- as.db.data.frame(y, "y_sm")

## ------------------------------------------------------------------------

dat <- as.data.frame(h8)
dat$row_id <- 0:7
delete("s_tmp", conn.id = 2)
x1 <- as.db.data.frame(dat, "s_tmp", conn.id = 2)
x2 <- x1$row_id
x2$row_vec <- rowAgg(x1[,1:8])
delete("s_dm", conn.id = 2)
x3 <- as.db.data.frame(x2, "s_dm")

y <- data.frame(row_id = 0:7, val = rep(1,8))
delete("y_sm", conn.id = 2)
y1 <- as.db.data.frame(y, "y_sm", conn.id = 2)
