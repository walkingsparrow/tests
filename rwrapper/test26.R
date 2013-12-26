library(PivotalR)
library(glmnet)
db.connect(port = 5433, dbname = "madlib")

dat <- db.data.frame("madlibtestdata.dt_abalone")

content(rowSums(dat[,-2]))

db.q("select * from madlibtestdata.dt_abalone order by id", nrows = 10)

db.q("drop table if exists tr",
     "create temp table tr (idx integer)",
     "insert into tr values (1), (2)", sep = ";")

db.q("select * from tr")

f <- madlib.lm(rings ~ . - id + as.factor(sex), data = dat)

f

compute <- cbind(mean(residuals(f[[1]])^2), crossprod(z))
compute <- as.db.data.frame(compute, verbose = FALSE)
mn <- lk(compute[,1]) * n / (n - k)
xx <- compute[,2]; class(xx) <- "db.Rcrossprod"; xx@.dim <- c(k,k)
xx@.is.symmetric <- TRUE; xx <- solve(lk(xx))

lk(mean((dat$rings - predict(f, dat))^2))

vcov(f)

z <- PivotalR:::.extract.regr.x(f[[1]])

content(z)

w <- mean(residuals(f[[1]])^2)

crossprod(z)

sqrt(diag(vcov(f[[1]])))

d <- lk(dat, -1)

dim(d)

dim(dat)

fit <- lm(rings ~ . - id, data = d)

summary(fit)

vcov(fit)

sqrt(diag(vcov(fit)))

mean((d$rings - predict(fit))^2)

## ----------------------------------------------------------------------

setGeneric("ifelse")

setMethod("ifelse",
    signature(test = "db.obj"),
    function (test, yes, no)
    {
        if (length(names(test)) != 1 || col.types(test) != "boolean")
            stop(deparse(substitue(test)), " must have only one column",
                 " and the column type is boolean!")
        x <- test
        x$res <- no
        x$res[test,] <- yes
        x$res
    }
)

z <- ifelse(dat$sex == "M", 1, 0)

content(z)

z@.expr

setClass("test", representation(.a = "character", .b = "test"))

z$a <- 1

content(z$a)

(z$a)@.expr

setClass("tt23", representation(.a = "character", .b = "numeric"),
         prototype = list(.b = 23))

x <- new("tt23", .a = "as")

attributes(x)

.extract.regr.x <- function(object)
{
    x <- object$data
    for (i in seq_len(length(object$dummy))) {
        x[[object$dummy[i]]] <- 1
        z <- x[[object$dummy[i]]]
        z@.expr <- object$dummy.expr[i]
        z@.content <- gsub("^select 1 as",
                           paste("select ", z@.expr, " as", sep = ""),
                           z@.content)
        x[[object$dummy[i]]] <- z
    }
    res <- Reduce(cbind, eval(parse(text = "with(x, c(" %+%
                                    ("," %.% object$ind.vars) %+% "))")))
    if (object$has.intercept) { z <- res; z[["const"]] <- 1; res <- cbind(z$const, res)} 
    res
}

## ----------------------------------------------------------------------

`%+%` <- function (e1, e2) paste(e1, e2, sep = "")
`%.%` <- function (e1, e2) paste(e2, collapse = e1)

vcov.lm.madlib <- function(object, ...)
{
    x <- .extract.regr.x(object)
    n <- nrow(object$data)
    k <- length(names(x))
    compute <- cbind(mean(residuals(object)^2), crossprod(x))
    compute <- as.db.data.frame(compute, verbose = FALSE)
    mn <- lk(compute[,1]) * n / (n - k)
    xx <- compute[,2]; class(xx) <- "db.Rcrossprod"; xx@.dim <- c(k,k)
    xx@.is.symmetric <- TRUE; xx <- solve(lk(xx))
    mn * xx    
}

vcov(f)

sqrt(diag(vcov(f)))

vcov(fit)

vcov.logregr.madlib <- function(object, ...)
{
    x <- .extract.regr.x(object)
    cx <- Reduce(function(l,r) l+r, as.list(object$coef * x))
    a <- 1/((1 + exp(-1*cx)) * (1 + exp(cx)))
    xx <- lk(crossprod(x, a*x))
    solve(xx)
}

f <- madlib.glm(rings<10 ~ . - id + as.factor(sex), data = dat, family = "binomial")

f

lk(mean((dat$rings<10) == predict(f, dat)))

d <- lk(dat, -1)

fit <- glm(rings<10 ~ . - id, data = d, family = "binomial")

summary(fit)

mean((d$rings<10) == (predict(fit, d, type = "response") > 0.5))

sqrt(diag(vcov(fit)))

sqrt(diag(vcov(f)))
