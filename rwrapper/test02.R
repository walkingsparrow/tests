## test loading file

library(PivotalR)

db.connect(port = 14526, dbname = "madlib")

x <- db.data.frame("abalone")

delete("abalone_f1")

x <- as.db.data.frame("abalone.csv", "abalone_f1")

con <- conn()

delete("abalone_f")

dbWriteTable(conn = con, name = "abalone_f", value = "/Users/qianh1/workspace/tests/rwrapper/abalone.csv")

dbGetQuery(con, "\\d abalone_f")

## ------------------------------------------------------------------------

y <- as.db.data.frame(sort(x, F, x$id), "aba_port", nrow = 20)

library(PivotalR)

db.connect(port = 14526, dbname = "madlib")

y <- db.data.frame("aba_port")

dim(y)

a <- sample(y, 20)

dim(a)

lookat(a)

b <- sample(y, 40, replace = TRUE)

dim(b)

lookat(b)

delete(b)

ct <- PivotalR:::.db.getQuery(paste("select count(*) from information_schema.tables where table_name = '", z[2], "' and table_schema = '", z[1], "'", sep = ""), 1)

ct

PivotalR:::.db.getQuery(paste("select count(*) from information_schema.tables where table_name = '", "\"__madlib_temp_790374_1371355226_56336__\"", "' and table_schema = '", "pg_temp_24", "'", sep = ""), 1)
