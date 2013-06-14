library(foreign)

children <- read.dta("fertil2.dta", convert.factors = FALSE)

r1 <- lm(ceb ~ age + agefbrth + usemeth, data = children)

summary(r1)

X <- model.matrix(r1)

dim(X)

n <- dim(X)[1]

k <- dim(X)[2]

se <- sqrt(diag(solve(crossprod(X)) * as.numeric(crossprod(resid(r1))/(n-k))))

se

## ------------------------------------------------------------------------

length(resid(r1))

u <- matrix(resid(r1))

dim(u)

length(diag(crossprod(t(u))))

meat1 <- t(X) %*% diag(diag(crossprod(t(u)))) %*% X

meat1

meat2 <- t(X) %*% crossprod(t(u)) %*% X

dim(meat2)

## degrees of freedom adjust
dfc <- n/(n-k)    

## like before
se <- sqrt(dfc*diag(solve(crossprod(X)) %*% meat1 %*% solve(crossprod(X))))

se

## ------------------------------------------------------------------------

data <- children

dim(data)

cluster <- "children"

length(unique(data[[cluster]]))

unique(data[[cluster]])

idx <- !(is.na(data$agefbrth) | is.na(data$usemeth))

# matrix for loops
clus <- cbind(X, data[idx,cluster], resid(r1))

dim(clus)

colnames(clus)

colnames(clus)[(dim(clus)[2]-1):dim(clus)[2]] <- c(cluster,"resid")

colnames(clus)

## number of clusters
m <- dim(table(clus[,cluster]))

m

## dof adjustment
dfc <- (m/(m-1))*((n-1)/(n-k))

## uj matrix
uclust <- matrix(NA, nrow = m, ncol = k)

gs <- names(table(data[,cluster]))

for(i in 1:m) uclust[i,] <- t(matrix(clus[clus[,cluster]==gs[i],k+2])) %*% clus[clus[,cluster]==gs[i],1:k]

dim(uclust)

## square root of diagonal on bread meat bread like before
se <- sqrt(diag(solve(crossprod(X)) %*% (t(uclust) %*% uclust) %*% solve(crossprod(X)))*dfc)

se

t(uclust) %*% uclust

a <- array(0, dim=c(4,4))
for (i in 1:14) a <- a + uclust[i,] %*% t(uclust[i,])

a

## ------------------------------------------------------------------------

library(lmtest)
library(car)
library(sandwich)

for (i in 1:m) {
    fit <- lm()
}

## ------------------------------------------------------------------------

library(PivotalR)

db.connect(port = 14526, dbname = "madlib")

x <- as.db.data.frame(data, "children")

y <- x
y <- y[!is.na(y$agefbrth) & !is.na(y$usemeth),]

fit <- madlib.lm(ceb ~ age + agefbrth + usemeth | children, data = y)

fit

dim(fit$std_err)

g <- m*(n-1)/(m-1)

sqrt(colSums(fit$std_err^2 / g))

## ------------------------------------------------------------------------

x <- db.data.frame("madlibtestdata.log_ornstein")

dim(x)

lookat(x, 10)

rx <- lookat(x, "all")

dim(rx)

rx$interlocks <- as.factor(rx$interlocks)

fit <- glm(interlocks ~ ., data = rx, family = binomial)

summary(fit)

X <- model.matrix(fit)

dim(X)

X[1:10,]

rx[1:10,]

n <- dim(X)[1]

k <- dim(X)[2]

se <- sqrt(diag(solve(crossprod(X)) * as.numeric(crossprod(resid(fit))/(n-k))))

se

## ------------------------------------------------------------------------

x <- db.data.frame("fdic_lower")

dim(x)

y <- x[,c("sf_mrtg_pct_assets","ris_asset", "lncrcd","lnauto","lnconoth","lnconrp","intmsrfv","lnrenr1a","lnrenr2a","lnrenr3a")]

dim(y)

## remove NULL values
for (i in 1:10) y <- y[!is.na(y[i]),]

dim(y)

r2 <- madlib.lm(sf_mrtg_pct_assets ~ ., data = y)

r2

lookat(mean((y$sf_mrtg_pct_assets - predict(r2, y))^2))

## -----------------

z <- lookat(y, "all")

dim(z)

r1 <- lm(sf_mrtg_pct_assets ~ ., data = z)

mean((z$sf_mrtg_pct_assets - predict(r1, z))^2)

summary(r1)

## --------------------

X <- model.matrix(r1)

dim(X)

cx <- crossprod(X)

cx

cor(X)

eigen(cx)

Y <- solve(crossprod(X))

dim(Y)

Y %*% t(X) %*% z$sf_mrtg_pct_assets

cx %*% Y

Y %*% cx
