library(PivotalR)
db.connect(port = 14526, dbname = "madlib")

suppressMessages(library(nnet))

dat <- lk("madlibtestdata.mlogr_test_wi", "all")

for (i in seq(ncol(dat))) dat <- dat[!is.na(dat[,i]),]

g <- multinom(y ~ . - 1, data = dat)

n <- sum(grepl("^x\\[", names(dat)))
ncat <- length(unique(dat$y)) - 1
vals <- list()
for (cat in 1:ncat)
    for (i in 1:n) {
        id <- i + cat * (n+1) + 1
        eval(parse(text = paste0("vals$b", cat, i, "=", g$wts[id])))
    }

denom <- "(1"
for (cat in 1:ncat)
    denom <- paste0(denom, "+exp(", paste0("b", cat, 1:n, "*`x[", 1:n, "]`", collapse = "+"), ")")
denom <- paste0(denom, ")")

margin <- function(fit, cat, i) {
    num <- paste0("exp(", paste0("b", cat, 1:n, "*`x[", 1:n, "]`", collapse = "+"), ")")
    P <- paste0(num, "/", denom)
    s <- PivotalR:::.parse.deriv(P, paste0("x[",i,"]"))
    w <- eval(parse(text = paste0("substitute(", s, ",vals)")))
    v <- as.character(enquote(w))[2]
    eval(parse(text = paste("mean(with(dat, ", v, "))")))
}

margin1 <- function(fit, cati, i, catj, j) {
    num <- paste0("exp(", paste0("b", cati, 1:n, "*`x[", 1:n, "]`", collapse = "+"), ")")
    P <- paste0(num, "/", denom)
    s <- PivotalR:::.parse.deriv(P, paste0("x[",i,"]"))
    s1 <- PivotalR:::.parse.deriv(s, paste0("b", catj, j))
    w <- eval(parse(text = paste0("substitute(", s1, ",vals)")))
    v <- as.character(enquote(w))[2]
    eval(parse(text = paste("mean(with(dat, ", v, "))")))
}

coef <- unlist(Map(function(cat, i) margin(g, cat, i), rep(1:ncat, each = n), rep(1:n, ncat)))
se <- array(0, dim = c(n*ncat, n*ncat))
for (cat in 1:ncat)
    for (i in 1:n)
        se[(cat-1)*n+i,] <- unlist(Map(function(catj, j) margin1(g, cat, i, catj, j),
                                       rep(1:ncat, each = n), rep(1:n, ncat)))

se <- sqrt(diag(se %*% vcov(g) %*% t(se)))

ts <- coef / se
pv <- 2 * (1 - pnorm(abs(ts)))

coef

se

ts

pv
