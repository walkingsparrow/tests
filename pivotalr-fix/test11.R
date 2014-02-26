library(PivotalR)
db.connect(port = 5433, dbname = "madlib")

library(testthat)

cid <- 1

expect_that(db.q("select version()", conn.id = cid, verbose = FALSE),
            {if (PivotalR:::.get.dbms.str(cid)$db.str == "HAWQ")
                 matches("HAWQ")
            else if (PivotalR:::.get.dbms.str(cid)$db.str == "PostgreSQL")
                matches("PostgreSQL")
            else
                matches("Greenplum")})

s <- db.q("select version()", conn.id = cid, verbose = FALSE)

expect_that(s,
            {if (PivotalR:::.get.dbms.str(cid)$db.str == "HAWQ")
                 matches("HAWQ")
            else if (PivotalR:::.get.dbms.str(cid)$db.str == "PostgreSQL")
                matches("PostgreSQL")
            else
                matches("Greenplum")})

expect_that(as.character(s), matches('PostgreSQL1'))


skip_if <- function(cond, test.expr)
{
    expr <- deparse(test.expr)
    print(expr)
    l <- sum(sapply(gregexpr("expect_that\\(", expr), function(s) sum(s>0)))
    if (cond)
        for (i in seq_len(l)) cat(testthat::colourise(".", fg = "light blue"))
    else
        test.expr
}

skip_if(TRUE, "expect_that11")

gregexpr("expect_that\\(", "\"expect_that()\"")
