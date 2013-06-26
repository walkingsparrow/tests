
library(PivotalR)
db.connect(port = 14526, dbname = "madlib")

data<- lookat(db.data.frame("madlibtestdata.lin_flare_wi_cl2"), "all")

w <- arraydb.to.arrayr(data$x, "double")

z <- as.data.frame(cbind(w[,-1], data$y, as.factor(paste(data$cl1, data$cl2))))

colnames(z) <- c(paste("x", 1:7, sep = ""), 'y', 'cl1_cl2')

r1 <- lm(y ~ . - cl1_cl2, data = z)

summary(r1)

## get X matrix/predictors
X <- model.matrix(r1)
## number of obs
n <- dim(X)[1]
## n of predictors
k <- dim(X)[2]

cluster <- "cl1_cl2"

## matrix for loops
clus <- cbind(X,z[,cluster],resid(r1))

colnames(clus)[(dim(clus)[2]-1):dim(clus)[2]] <- c(cluster,"resid")

## number of clusters
m <- dim(table(clus[,cluster]))

## dof adjustment
dfc <- (m/(m-1))*((n-1)/(n-k))

## uj matrix
uclust <- matrix(NA, nrow = m, ncol = k)
gs <- as.numeric(names(table(clus[,cluster])))
for(i in 1:m){
    w <- as.matrix(clus[clus[,cluster]==gs[i],])
    uclust[i,] <- t(w[,k+2]) %*% w[,1:k]
}

## square root of diagonal on bread meat bread like before
se <- sqrt(diag(solve(crossprod(X)) %*% (t(uclust) %*% uclust) %*% solve(crossprod(X)))*dfc)

se

t(uclust) %*% uclust

uclust

clx <- function(fm, dfcw, cluster)
{
    library(sandwich)
    library(lmtest)
    M <- length(unique(cluster))
    N <- length(cluster)
    dfc <- (M/(M-1))*((N-1)/(N-fm$rank))
    print(dfc)
    print(N)
    u <- apply(estfun(fm), 2,
               function(x) tapply(x, cluster, sum))
    vcovCL <- dfc * sandwich(fm, meat = crossprod(u)/N) * dfcw
    list(coef = coeftest(fm, vcovCL), u = u)
}

z <- clx(r1, 1, data$sex)

z$coef

z$u

diag(solve(crossprod(X)) %*% crossprod(t(z$u[1,])) %*% solve(crossprod(X))) + diag(solve(crossprod(X)) %*% crossprod(t(z$u[2,])) %*% solve(crossprod(X))) + diag(solve(crossprod(X)) %*% crossprod(t(z$u[3,])) %*% solve(crossprod(X)))

diag(solve(crossprod(X)) %*% crossprod(z$u) %*% solve(crossprod(X)))
