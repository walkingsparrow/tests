library(PivotalR)

db.connect(port = 14526, dbname = "madlib")

x <- db.data.frame("madlibtestdata.bank")

x$marital <- as.factor(x$marital)

madlib.lm(duration ~ age + marital, data = x)

con <- conn(1)

dbSendQuery()

x <- db.data.frame("grad_school")

dim(x)

dim(x[!is.na(x$admit),])

as.db.data.frame(x[!is.na(x$admit),], "grad_school1")

dbSendQuery(con, "drop table if exists temp_result;
select madlib.logregr_train(
    'grad_school',
    'temp_result',
    'admit',
    'ARRAY[1, gre, gpa]',
    'rank');
")

res <- dbSendQuery(con, "select pg_sleep(20);")

dbClearResult(res)

close(res)
