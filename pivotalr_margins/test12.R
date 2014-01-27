library(PivotalR)
db.connect(port = 5433, dbname = "madlib")

dat <- db.data.frame("madlibtestdata.dt_abalone")

d <- lk(dat, -1)

d$s <- sample(1:4, nrow(d), replace = TRUE)

dat1 <- as.db.data.frame(d)

madlib.lm(rings ~ factor(s), data = dat1)
