library(PivotalR)
library(testthat)

skip_if <- function(cond, test.expr)
{
    expr <- deparse(substitute(test.expr))
    print(expr)
    l <- sum(sapply(gregexpr("expect_that\\(", expr), function(s) sum(s>0)))
    if (cond) {
        cat("here 1: l=")
        cat(l)
        ## for (i in seq_len(l)) cat(testthat::colourise(".", fg = "light blue"))
        for (i in seq_len(l)) cat("-")
    } else {
        print("here 2")
        test.expr
    }
}

cid <- db.connect(port = 5433, dbname = "madlib", verbose = FALSE)

## data in the datbase
dat <- as.db.data.frame(abalone, conn.id = cid, verbose = FALSE)

skip_if(TRUE, {
    ## 34, 35, 36
    test_that("Always skip this", {
        tmp <- dat
        tmp$new.col <- 1
        ##
        expect_that(names(tmp), matches("new.col", all = FALSE))
        expect_that(print(tmp), prints_text("temporary"))
    })

    test_that("Also always skip this",
              expect_that(db.q("\\dn", verbose = FALSE),
                          throws_error("syntax error")))
})

skip_if(TRUE,
        test_that("Always skip this", {
            tmp <- dat
            tmp$new.col <- 1
            ##
            expect_that(names(tmp), matches("new.col", all = FALSE))
            expect_that(print(tmp), prints_text("temporary"))
        }))


deparse(quote({a = 0}))

a <- 1.2
skip_if(TRUE, sin(a))

test_that("test output", expect_that({
    x <- array(1:9, dim = c(3,3))
    x
    dbms()
    message("OK")
    cat("OK")
}, PivotalR:::has_no_error()))
