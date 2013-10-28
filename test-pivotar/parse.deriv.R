## ----------------------------------------------------------------------
## parse the derivative of any function
## ----------------------------------------------------------------------

deriv(~ log((sin(x)*cos(x))^2 + y), var)

## ----------------------------------------------------------------------

parse.deriv <- function (formula, var)
{
    x <- deriv(formula, var)
    lst0 <- deparse(x)
    lst0 <- lst0[2:(length(lst0)-1)]
    lst <- character(0)
    for (i in 1:length(lst0)) {
        if (gsub("value", "", lst0[i]) != lst0[i] ||
            gsub("array", "", lst0[i]) != lst0[i] ||
            gsub("attr", "", lst0[i]) != lst0[i]) next
        if (gsub("<-", "", lst0[i]) != lst0[i]) {
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
    k <- which(names(env) == paste(".grad[, \"", var, "\"]",
                    sep = ""))
    
    while (env[[k]] != res) {
        res <- env[[k]]
        for (i in 1:length(env))
            env[[i]] <- eval(parse(text = paste("substitute(",
                                   paste(deparse(env[[i]]),
                                         collapse = " "),
                                   ", env)", sep = "")))
    }
    gsub("\\s+", " ", paste(deparse(res), collapse = ""))
}

## For example:
parse.deriv(~ log((sin(x)*cos(x))^2 + y), "x")
