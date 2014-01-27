library(PivotalR)
db.connect(port = 5433, dbname = "madlib")

dat <- db.data.frame("madlibtestdata.dt_abalone")

d <- lk(dat, -1)

dim(d)

d$r <- sample(1:2, 4177, replace = TRUE)

dat1 <- as.db.data.frame(d)

lk(by(dat1[,-2], dat1$sex, mean), -1)

lk(by(dat1[,-c(2,11)], list(dat1$sex, dat1$r), mean), -1)

lk(by(dat1[,-2], dat1$r + 1 > 2, mean), -1)

by(dat1, dat1$r + 1 > 2,
   function(x)
   madlib.lm(rings ~ . - id - r - sex, data = x))

content(dat1$r == "1")

dat2 <- dat1[,-2]

lk(mean(dat2[dat1$sex == "M"],))

x <- c("a", "b")
v <- c(NA, 1)

ifelse(!is.na(v), paste(x[1:2], "==", v), paste("is.na(", x[1:2], ")", sep = ""))

content(merge(dat, dat, by = "sex"))

lk(merge(dat, dat, by = "sex"), 10)

a <- merge(dat, dat, by = "sex")

attributes(a)
