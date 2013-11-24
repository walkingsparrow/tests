library(PivotalR)
db.connect(port = 14526, dbname = "madlib")

dat <- lk("madlibtestdata.pbc_xy", "all")

dat[1:10,]

f <- by(dat[,-c(2,15)], dat$sex, function(x) glm(y < 51 ~ . - 1, data = x, family = binomial, na.action = na.omit))

f

x <- dat[dat$sex == 'm',-c(2,4:6,15)]

glm(y < 51 ~ . - 1, data  = x, family = binomial, na.action = na.omit, control=list(epsilon=1e-8, maxit=2000))

lm(y ~ . - 1, data = x)

g <- glm(y ~ . - 1, data  = x, family = gaussian, na.action = na.omit, control=list(epsilon=1e-10, maxit=2000))
