library(PivotalR)
db.connect(port = 14526, dbname = "madlib")

dat <- lk("madlibtestdata.fdic_part_null_boolean", "all")

for (i in seq(ncol(dat))) dat <- dat[!is.na(dat[,i]),]

g <- glm(y ~ . - 1, data = dat, family = binomial)

n <- sum(grepl("^x\\[", names(dat)))
vals <- list()
for (i in 1:n) {
    eval(parse(text = paste0("vals$b", i, "=", g$coefficients[i])))
}

datm <- list()
for (i in 1:n) datm[[paste0("x[", i, "]")]] <- mean(dat[,i])

denom <- "(1"
denom <- paste0(denom, "+exp(-(", paste0("b", 1:n, "*`x[", 1:n, "]`", collapse = "+"), "))")
denom <- paste0(denom, ")")

margin <- function(fit, i) {
    ## num <- paste0("exp(", paste0("b", 1:n, "*`x[", 1:n, "]`", collapse = "+"), ")")
    P <- paste0("1/", denom)
    s <- PivotalR:::.parse.deriv(P, paste0("x[",i,"]"))
    w <- eval(parse(text = paste0("substitute(", s, ",vals)")))
    v <- as.character(enquote(w))[2]
    eval(parse(text = paste("mean(with(dat, ", v, "))")))
}

margin1 <- function(fit, i, j) {
    ## num <- paste0("exp(", paste0("b", 1:n, "*`x[", 1:n, "]`", collapse = "+"), ")")
    P <- paste0("1/", denom)
    s <- PivotalR:::.parse.deriv(P, paste0("x[",i,"]"))
    s1 <- PivotalR:::.parse.deriv(s, paste0("b", j))
    w <- eval(parse(text = paste0("substitute(", s1, ",vals)")))
    v <- as.character(enquote(w))[2]
    eval(parse(text = paste("mean(with(dat, ", v, "))")))
}

coef <- unlist(Map(function(i) margin(g, i), 1:n))
se <- array(0, dim = c(n, n))
for (i in 1:n)
    se[i,] <- unlist(Map(function(j) margin1(g, i, j), 1:n))

se <- sqrt(diag(se %*% vcov(g) %*% t(se)))

ts <- coef / se
pv <- 2 * (1 - pt(abs(ts), nrow(dat) - n))

coef

se

ts

pv

2*(1-pnorm(abs(ts)))
