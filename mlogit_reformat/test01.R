library(PivotalR)
db.connect(port = 14526, dbname = "madlib")

dat <- lk("madlibtestdata.mlogr_isis_wi", "all")

library(nnet)

g <- multinom(y ~ . - 1, data = dat)

g$wts

p <- predict(g, newdata = dat, type = "probs")

dr <- 1e-10
i <- 3
cat <- 2
y <- dat; y[,i] <- y[,i] + dr
p1 <- predict(g, newdata = y, type = "probs")
y <- dat; y[,i] <- y[,i] - dr
p2 <- predict(g, newdata = y, type = "probs")
mean(p1[,cat+1] - p2[,cat+1])/(2*dr)

margin <- function(fit, data, i, cat, dr = 1e-10) {
    y <- data; y[,i] <- y[,i] + dr
    p1 <- predict(fit, newdata = y, type = "probs")
    y <- data; y[,i] <- y[,i] - dr
    p2 <- predict(fit, newdata = y, type = "probs")
    mean(p1[,cat+1] - p2[,cat+1])/(2*dr)
}

## first derivative of margin over i-th variable
margin1 <- function(fit, data, i, cati, j, catj, dr = 1e-10) {
    n <- length(fit$coefnames)
    id <- j + catj * (n+1) + 1
    f <- fit; f$wts[id] <- f$wts[id] + dr
    p1 <- margin(f, data, i, cati)
    f <- fit; f$wts[id] <- f$wts[id] - dr
    p2 <- margin(f, data, i, cati)
    (p1 - p2) / (2*dr)
}

n <- 3
cn <- 2
l <- n * cn
mat <- array(0, dim = c(l,l))
for (cati in 1:cn)
    for (i in 1:n)
        for (catj in 1:cn) 
            for (j in 1:n) {
                a <- (cati - 1) * n + i
                b <- (catj - 1) * n + j
                mat[a,b] <- margin1(g, dat, i, cati, j, catj, 1e-6)
            }

mat

sqrt(t(mat[3,]) %*% vcov(g) %*% mat[3,])

sqrt(diag(mat %*% vcov(g) %*% t(mat)))

sqrt(diag(t(mat) %*% vcov(g) %*% mat))

sqrt(diag(mat %*% t(mat) %*% vcov(g)))

sqrt(diag(t(mat) %*% mat %*% vcov(g)))

## ----------------------------------------------------------------------


s <- PivotalR:::.parse.deriv("exp(b11*`x[1]` + b12*`x[2]` + b13*`x[3]`)/(1 + exp(b11*`x[1]` + b12*`x[2]` + b13*`x[3]`) + exp(b21*`x[1]` + b22*`x[2]` + b23*`x[3]`))", "x[1]")

g$wts

n <- 3
vals <- list()
for (cat in 1:2)
    for (i in 1:3) {
        id <- i + cat * (n+1) + 1
        eval(parse(text = paste0("vals$b", cat, i, "=", g$wts[id])))
    }
        
w <- eval(parse(text = paste0("substitute(", s, ",vals)")))

v <- as.character(enquote(w))[2]

eval(parse(text = paste("with(dat, mean(", v, "))")))

paste0("b", 2, 1:3, "*`x[", 1:3, "]`", collapse = "+")

margin <- function(fit, dat, cat, i) {
    denom <- "(1 + exp(b11*`x[1]` + b12*`x[2]` + b13*`x[3]`) + exp(b21*`x[1]` + b22*`x[2]` + b23*`x[3]`))"
    num <- paste0("exp(", paste0("b", cat, 1:3, "*`x[", 1:3, "]`", collapse = "+"), ")")
    P <- paste0(num, "/", denom)
    s <- PivotalR:::.parse.deriv(P, paste0("x[",i,"]"))
    w <- eval(parse(text = paste0("substitute(", s, ",vals)")))
    v <- as.character(enquote(w))[2]
    eval(parse(text = paste("with(dat, mean(", v, "))")))
}

margin(g, dat, 2, 3)

margin1 <- function(fit, dat, cati, i, catj, j) {
    denom <- "(1 + exp(b11*`x[1]` + b12*`x[2]` + b13*`x[3]`) + exp(b21*`x[1]` + b22*`x[2]` + b23*`x[3]`))"
    num <- paste0("exp(", paste0("b", cati, 1:3, "*`x[", 1:3, "]`", collapse = "+"), ")")
    P <- paste0(num, "/", denom)
    s <- PivotalR:::.parse.deriv(P, paste0("x[",i,"]"))
    s1 <- PivotalR:::.parse.deriv(s, paste0("b", catj, j))
    w <- eval(parse(text = paste0("substitute(", s1, ",vals)")))
    v <- as.character(enquote(w))[2]
    eval(parse(text = paste("with(dat, mean(", v, "))")))
}

datm <- list(`x[1]` = mean(dat[,1]), `x[2]` = mean(dat[,2]), `x[3]` = mean(dat[,3]))

## ----------------------------------------------------------------------
## at mean
margin <- function(fit, dat, cat, i) {
    denom <- "(1 + exp(b11*`x[1]` + b12*`x[2]` + b13*`x[3]`) + exp(b21*`x[1]` + b22*`x[2]` + b23*`x[3]`))"
    num <- paste0("exp(", paste0("b", cat, 1:3, "*`x[", 1:3, "]`", collapse = "+"), ")")
    P <- paste0(num, "/", denom)
    s <- PivotalR:::.parse.deriv(P, paste0("x[",i,"]"))
    w <- eval(parse(text = paste0("substitute(", s, ",vals)")))
    v <- as.character(enquote(w))[2]
    eval(parse(text = paste("with(datm, mean(", v, "))")))
}


margin1 <- function(fit, dat, cati, i, catj, j) {
    denom <- "(1 + exp(b11*`x[1]` + b12*`x[2]` + b13*`x[3]`) + exp(b21*`x[1]` + b22*`x[2]` + b23*`x[3]`))"
    num <- paste0("exp(", paste0("b", cati, 1:3, "*`x[", 1:3, "]`", collapse = "+"), ")")
    P <- paste0(num, "/", denom)
    s <- PivotalR:::.parse.deriv(P, paste0("x[",i,"]"))
    s1 <- PivotalR:::.parse.deriv(s, paste0("b", catj, j))
    w <- eval(parse(text = paste0("substitute(", s1, ",vals)")))
    v <- as.character(enquote(w))[2]
    eval(parse(text = paste("with(datm, mean(", v, "))")))
}

n <- 3
cn <- 2
l <- n * cn
mat <- array(0, dim = c(l,l))
for (cati in 1:cn)
    for (i in 1:n)
        for (catj in 1:cn) 
            for (j in 1:n) {
                a <- (cati - 1) * n + i
                b <- (catj - 1) * n + j
                mat[a,b] <- margin1(g, dat, cati, i, catj, j)
            }

mat

sqrt(diag(mat %*% vcov(g) %*% t(mat)))

se <- array(0, dim = c(n*ncat, n*ncat))
for (cat in 1:ncat)
    for (i in 1:n)
        se[(cat-1)*n+i,] <- unlist(Map(function(catj, j) margin1(g, dat, cat, i, catj, j),
                                       rep(1:ncat, each = n), rep(1:n, ncat)))

se

sqrt(diag(se %*% vcov(g) %*% t(se)))
