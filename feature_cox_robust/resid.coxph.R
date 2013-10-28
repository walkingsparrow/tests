library(survival)

my.getdata <- function (fit, y = TRUE, x = TRUE, stratax = TRUE, offset = FALSE) 
{
    ty <- fit[["y"]]
    tx <- fit[["x"]]
    strat <- fit$strata
    Terms <- fit$terms
    if (is.null(attr(Terms, "offset"))) 
        offset <- FALSE
    if (offset) 
        x <- TRUE
    if (!inherits(Terms, "terms")) 
        stop("invalid terms component of fit")
    strats <- attr(Terms, "specials")$strata
    if (length(strats) == 0) 
        stratax <- FALSE
    if ((y && is.null(ty)) || (x && is.null(tx)) || (stratax && 
        is.null(strat)) || offset) {
        m <- model.frame(fit)
        if (y && is.null(ty)) 
            ty <- model.extract(m, "response")
        if (offset) 
            toff <- model.extract(m, "offset")
        if ((x || stratax) && is.null(tx)) {
            if (stratax) {
                temp <- untangle.specials(Terms, "strata", 1)
                strat <- strata(m[temp$vars], shortlabel = T)
            }
            if (x) 
                tx <- model.matrix(fit, data = m)
        }
    }
    else if (offset) 
        toff <- fit$linear.predictors - (c(tx %*% fit$coef) - 
            sum(fit$means * fit$coef))
    temp <- list()
    if (y) 
        temp$y <- ty
    if (x) 
        temp$x <- tx
    if (stratax) 
        temp$strata <- strat
    if (offset) 
        temp$offset <- toff
    temp
}

my.resid <- function (object, type = c("martingale", "deviance", "score", 
    "schoenfeld", "dfbeta", "dfbetas", "scaledsch", "partial"), 
    collapse = FALSE, weighted = FALSE, ...) 
{
    print("*********")
    type <- match.arg(type)
    otype <- type
    if (type == "dfbeta" || type == "dfbetas") {
        type <- "score"
        if (missing(weighted)) 
            weighted <- TRUE
    }
    if (type == "scaledsch") 
        type <- "schoenfeld"
    n <- length(object$residuals)
    rr <- object$residuals
    y <- object$y
    x <- object[["x"]]
    vv <- object$naive.var
    if (is.null(vv)) 
        vv <- object$var
    weights <- object$weights
    if (is.null(weights)) 
        weights <- rep(1, n)
    strat <- object$strata
    method <- object$method
    if (method == "exact" && (type == "score" || type == "schoenfeld")) 
        stop(paste(type, "residuals are not available for the exact method"))
    if (type == "martingale" || type == "partial") 
        rr <- object$residuals
    else {
        Terms <- object$terms
        if (!inherits(Terms, "terms")) 
            stop("invalid terms component of object")
        strats <- attr(Terms, "specials")$strata
        if (is.null(y) || (is.null(x) && type != "deviance")) {
            temp <- my.getdata(object, y = TRUE, x = TRUE, 
                stratax = TRUE)
            y <- temp$y
            x <- temp$x
            if (length(strats)) 
                strat <- temp$strata
        }
        ny <- ncol(y)
        status <- y[, ny, drop = TRUE]
        if (type != "deviance") {
            nstrat <- as.numeric(strat)
            nvar <- ncol(x)
            if (is.null(strat)) {
                ord <- order(y[, ny - 1], -status)
                newstrat <- rep(0, n)
            }
            else {
                ord <- order(nstrat, y[, ny - 1], -status)
                newstrat <- c(diff(as.numeric(nstrat[ord])) != 
                  0, 1)
            }
            newstrat[n] <- 1
            x <- x[ord, ]
            y <- y[ord, ]
            score <- exp(object$linear.predictors)[ord]
        }
    }
    if (type == "schoenfeld") {
        if (ny == 2) {
            mintime <- min(y[, 1])
            if (mintime < 0) 
                y <- cbind(2 * mintime - 1, y)
            else y <- cbind(-1, y)
        }
        temp <- .C(Ccoxscho, n = as.integer(n), as.integer(nvar), 
            as.double(y), resid = as.double(x), as.double(score * 
                weights[ord]), as.integer(newstrat), as.integer(method == 
                "efron"), double(3 * nvar))
        deaths <- y[, 3] == 1
        if (nvar == 1) 
            rr <- temp$resid[deaths]
        else rr <- matrix(temp$resid[deaths], ncol = nvar)
        if (weighted) 
            rr <- rr * weights[deaths]
        if (length(strats)) 
            attr(rr, "strata") <- table((strat[ord])[deaths])
        time <- c(y[deaths, 2])
        if (is.matrix(rr)) 
            dimnames(rr) <- list(time, names(object$coefficients))
        else names(rr) <- time
        if (otype == "scaledsch") {
            ndead <- sum(deaths)
            coef <- ifelse(is.na(object$coefficients), 0, object$coefficients)
            if (nvar == 1) 
                rr <- rr * vv * ndead + coef
            else rr <- rr %*% vv * ndead + outer(rep(1, nrow(rr)), 
                coef)
        }
        return(rr)
    }
    if (type == "score") {
        print(ny)
        print(score)
        print(as.double(weights[ord]))
        if (ny == 2) {
            resid <- .C(Ccoxscore, as.integer(n), as.integer(nvar), 
                as.double(y), x = as.double(x), as.integer(newstrat), 
                as.double(score), as.double(weights[ord]), as.integer(method == 
                  "efron"), resid = double(n * nvar), double(2 * 
                  nvar))$resid
        }
        else {
            resid <- .C(Cagscore, as.integer(n), as.integer(nvar), 
                as.double(y), as.double(x), as.integer(newstrat), 
                as.double(score), as.double(weights[ord]), as.integer(method == 
                  "efron"), resid = double(n * nvar), double(nvar * 
                  6))$resid
        }
        if (nvar > 1) {
            rr <- matrix(0, n, nvar)
            rr[ord, ] <- matrix(resid, ncol = nvar)
            dimnames(rr) <- list(names(object$residuals), names(object$coefficients))
        }
        else rr[ord] <- resid
        if (otype == "dfbeta") {
            print(rr)
            print(vv)
            if (is.matrix(rr)) 
                rr <- rr %*% vv
            else rr <- rr * vv
        }
        else if (otype == "dfbetas") {
            if (is.matrix(rr)) 
                rr <- (rr %*% vv) %*% diag(sqrt(1/diag(vv)))
            else rr <- rr * sqrt(vv)
        }
    }
    if (weighted) 
        rr <- rr * weights
    if (!is.null(object$na.action)) {
        rr <- naresid(object$na.action, rr)
        if (is.matrix(rr)) 
            n <- nrow(rr)
        else n <- length(rr)
        if (type == "deviance") 
            status <- naresid(object$na.action, status)
    }
    if (type == "partial") {
        rr <- rr + predict(object, type = "terms")
    }
    if (!missing(collapse)) {
        if (length(collapse) != n) 
            stop("Wrong length for 'collapse'")
        rr <- drop(rowsum(rr, collapse))
        if (type == "deviance") 
            status <- drop(rowsum(status, collapse))
    }
    if (type == "deviance") 
        sign(rr) * sqrt(-2 * (rr + ifelse(status == 0, 0, status * 
            log(status - rr))))
    else rr
}
