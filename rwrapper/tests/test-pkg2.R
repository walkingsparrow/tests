install.packages("PivotalR_0.0.1.tar.gz", repos = NULL, type = "source")
library(PivotalR)
db.connect(host="localhost", user="qianh1", dbname="qianh1", port=5433)

db.disconnect(2)

db.list()

dbname(3)

user("a")

host()

conn.pkg(1)

x <- db.data.frame("madlibtestdata.lin_redundantobservations_oi")

dim(x)

names(x)

conn.id(x)

conn.id(x) <- 2

PivotalR:::.db.listTables()

PivotalR:::.is.table.or.view(c("public", "cvtest1"))

rst <- PivotalR:::.db.getQuery("select count(*) from cvtest1")

rst

rst <- PivotalR:::.db.sendQuery("select count(*) from cvtest1")

PivotalR:::.db.fetch(rst)

rst <- PivotalR:::.db.getQuery("select column_name, data_type from information_schema.columns where table_name = 'cvtest'")

rst

PivotalR:::.db.existsTable("cvtest1")

PivotalR:::.db.existsTable("tv")

PivotalR:::.db.existsTable(c("madlibtestdata", "lin_redundantobservations_oi"))

PivotalR:::.db.listFields(c("madlibtestdata", "lin_redundantobservations_oi"))

PivotalR:::.db.existsTable("tt_1")

PivotalR:::.db.listFields("tt_1")

res <- PivotalR:::.db.readTable("tt5")

str <- res$val[1]

PivotalR:::.db.str2vec(str)

x <- data.frame(a = 1:3, b = 2:4)

PivotalR:::.db.removeTable("testx1")

PivotalR:::.db.writeTable(table = "testx1", r.obj = x, distributed.by = NULL, row.names = FALSE)

res <- PivotalR:::.db.readTable("testx1")

## ------------------------------------------------------------------------

num <- as.numeric(strsplit(gsub("\\{(.*)\\}", "\\1", str), ",")[[1]])

res <- PivotalR:::.db.readTable("teststr")

str <- res$str[2]

gsub("[\\{,\\s]([^\\},]*)[,\\}\\s]", "\\1", str)

regmatches(str, gregexpr("[^,\"\\s\\{\\}]+|\"(\\\"|[^\"])*\"", str, perl=T))[[1]]

strsplit(gsub("\\{(.*)\\}", "\\1", str), ",")
