library(PivotalR)
db.connect(port = 5433, dbname = "madlib")

dat <- db.data.frame("madlibtestdata.dt_abalone")

f <- madlib.elnet(rings ~ . - id - sex, data = dat,
                  family = "gaussian", alpha = 1, lambda = 0.1,
                  method = "fista")

f

f <- madlib.elnet(rings ~ . - id + as.factor(sex), data = dat,
                  family = "gaussian", alpha = 1, lambda = 0.1,
                  method = "fista")

f

db.q <- function(..., conn.id = 1, nrow = 100)
{
    sql <- paste(..., sep = " ")
    print(sql)
    if (!is.character(sql))
        stop("can only execte a SQL query string!")

    res <- PivotalR:::.db.sendQuery(sql, conn.id)
    dat <- try(PivotalR:::.db.fetch(res, nrow), silent = TRUE)
    if (!is(dat, PivotalR:::.err.class)) {
        dbClearResult(res$res)
        dat
    } else
        dbClearResult(res$res)
}

db.q("select * from madlibtestdata.dt_abalone", nrow = -2)

res <- PivotalR:::.db.sendQuery("select * from madlibtestdata.dt_aalone", conn.id=1)

dat <- PivotalR:::.db.fetch(res, n=10)

dbClearResult(res$res)

db.q("drop table if exists tr;;",
     "create temp table tr (idx integer, val double precision);",
     "insert into tr values (1, 2.3), (2, 3.4)")

db.q("select * from tr")
