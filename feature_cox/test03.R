library(PivotalR)
library(survival)

db.connect(port = 14526, dbname = "madlib")

x <- preview("madlibtestdata.pbc", "all", conn.id=1)

y <- x[!is.na(x$protime),]

as.db.data.frame(y, "pbc_nonull")

coxph(Surv(time, status>0) ~ log10(bili) + log10(protime) + age + strata(sex), data = y, ties = "breslow")

## ----------------------------------------------------------------------

x <- db.data.frame("madlibtestdata.pbcseq")

names(x)

dim(x)

y <- x
for (i in seq_len(length(names(y)))) y <- y[!is.na(y[[i]]),]

dim(y)

delete("")

as.db.data.frame(y, "madlibtestdata.pbcseq_nonull")

PivotalR:::.db.getQuery("create table madlibtestdata.lung3 as select * from madlibtestdata.lung", 1)

ex <- db.existsObject("madlibtestdata.lung4", conn.id=1, TRUE)
ex

for (i in db.objects("lung\\d")) delete(paste0("\"", i, "\""))
