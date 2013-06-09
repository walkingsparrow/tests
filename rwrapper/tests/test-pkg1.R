
install.packages("PivotalR_0.0.1.tar.gz", repos = NULL)

library(PivotalR)

db.connect(host="localhost", user="qianh1", dbname="qianh1", port=5433)

db.disconnect(1)

db.list()

dbname(2)

user("a")

host()

conn.pkg(1)

.db.getQuery <- function(query, conn.id) PivotalR:::.db.getQuery(query, conn.id)

PivotalR:::.db.listTables()

PivotalR:::.is.table("cvtest1")

rst <- PivotalR:::.db.getQuery("select count(*) from cvtest1")

rst <- PivotalR:::.db.sendQuery("select count(*) from cvtest1")

rst <- PivotalR:::.db.getQuery("select column_name, data_type from information_schema.columns where table_name = 'cvtest'")

PivotalR:::.db.fetch(rst)

PivotalR:::.db.existsTable("cvtest")

PivotalR:::.db.existsTable("tv")

PivotalR:::.db.existsTable(c("madlibtestdata", "lin_redundantobservations_oi"))

PivotalR:::.db.listFields(c("madlibtestdata", "lin_redundantobservations_oi"))

## PivotalR:::.db.listFields("madlibtestdata.lin_redundantobservations_oi")

PivotalR:::.db.existsTable("tt")

PivotalR:::.db.listFields("tt")

PivotalR:::.db.removeTable("testx1")

res <- PivotalR:::.db.readTable("tt5")

str <- res$val[1]

PivotalR:::.db.str2vec(str)

x <- data.frame(a = 1:3, b = 2:4)

PivotalR:::.db.writeTable(table = "testx1", r.obj = x, distributed.by = NULL, row.names = FALSE)

## ------------------------------------------------------------------------

num <- as.numeric(strsplit(gsub("\\{(.*)\\}", "\\1", str), ",")[[1]])

res <- PivotalR:::.db.readTable("teststr")

str <- res$str[2]

gsub("[\\{,\\s]([^\\},]*)[,\\}\\s]", "\\1", str)

regmatches(str, gregexpr("[^,\"\\s\\{\\}]+|\"(\\\"|[^\"])*\"", str, perl=T))[[1]]

strsplit(gsub("\\{(.*)\\}", "\\1", str), ",")
