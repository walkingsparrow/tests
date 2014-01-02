library(PivotalR)
db.connect(port = 5433, dbname = "madlib")
options(width = 100)

dat <- db.data.frame("madlibtestdata.dt_abalone")

dat$sex <- relevel(dat$sex, "M")

fit <- madlib.lm(rings ~ . - id, data = dat)

fit

margins(fit, ~ Terms(), at.mean = FALSE)



## ----------------------------------------------------------------------

fit <- madlib.glm(rings < 10 ~ . - id - sex, data = dat, family = "logistic")

fit

margins(fit, at.mean = TRUE)

fit <- madlib.glm(rings < 10 ~ length + sex, data = dat, family = "logistic")

fit

margins(fit)

## ----------------------------------------------------------------------

dat <- db.data.frame("madlibtestdata.lin_auto_mpg_wi")

fit <- madlib.lm(y ~ x[2] + x[3]:x[4], data = dat)

fit

margins(fit)

fit <- madlib.glm(y < 23 ~ x[2] + x[3]:x[4], data = dat, family = "logistic")

fit

margins(fit)

## ----------------------------------------------------------------------

unlist(sapply(list(1, dat$rings), function(x) {if (is(x, "db.obj")) x@.expr else x}))

.parse.deriv <- function (expr.str, var)
{
    formula <- formula(paste("~", expr.str))
    x <- deriv(formula, var)
    lst0 <- deparse(x)
    lst0 <- lst0[2:(length(lst0)-1)]
    lst <- character(0)
    ignore <- FALSE
    for (i in 1:length(lst0)) {
        if (grepl("value", lst0[i]) ||
            grepl("array", lst0[i]) ||
            grepl("attr", lst0[i])) {
            ignore <- TRUE
            next
        }
        if (ignore) {
            if (!grepl("<-", lst0[i]))
                next
            else
                ignore <- FALSE
        }
        if (grepl("<-", lst0[i])) {
            lst <- c(lst, lst0[i])
        } else {
            if (i != 1)
                lst[length(lst)] <- paste(lst[length(lst)], lst0[i])
        }
    }

    env <- lapply(lst, function(x) eval(parse(
        text = paste("quote(", strsplit(x, "\\s*<-\\s*")[[1]][2],
        ")", sep = ""))))

    names(env) <- sapply(lst, function(x)
                         gsub("^\\s*", "",
                              strsplit(x, "\\s*<-\\s*")[[1]][1]))
    res <- ""
    k <- which(names(env) == paste(".grad[, \"", gsub("\"", "\\\\\\\"", var),
                    "\"]", sep = ""))
    
    while (env[[k]] != res) {
        res <- env[[k]]
        for (i in 1:length(env))
            env[[i]] <- eval(parse(text = paste("substitute(",
                                   paste(deparse(env[[i]]),
                                         collapse = " "),
                                   ", env)", sep = "")))
    }
    print(res)
    gsub("\\s+", " ", paste(deparse(res), collapse = " "))
}

a <- .parse.deriv("(`\"x\"`) * b1", "b1")

a

PivotalR:::.parse.deriv("log(sin(`\"x a\"`) * y + 1)", "\"x a\"")

