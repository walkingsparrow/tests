library(PivotalR)
db.connect(port = 14526, dbname = "madlib")

a <- array(1:100, dim = c(10, 10))

for (tbl in db.objects("public.__madlib_temp")) delete(tbl)

x <- as.db.data.frame(as.data.frame(a))

x1 <- as.matrix(lookat(x))

t(x1) %*% x1

z <- crossprod(x)

lookat(z)

content(z)

s <- PivotalR:::.db.getQuery("select pg_temp_53.__madlib_temp_766752_1376030611_477523__(array[(\"V1\"), (\"V2\"), (\"V3\"), (\"V4\"), (\"V5\"), (\"V6\"), (\"V7\"), (\"V8\"), (\"V9\"), (\"V10\")], 10) as crossprod from \"__madlib_temp_15243742_1376030608_4093828__\"", 1)

s <- PivotalR:::.db.getQuery("select unnest(cross_prod) as v from (select pg_temp_53.__madlib_temp_766752_1376030611_477523__(array[(\"V1\"), (\"V2\"), (\"V3\"), (\"V4\"), (\"V5\"), (\"V6\"), (\"V7\"), (\"V8\"), (\"V9\"), (\"V10\")], 10) as crossprod from \"__madlib_temp_15243742_1376030608_4093828__\") s", 1)

s <- PivotalR:::.db.getQuery("SELECT specific_schema from information_schema.routines where routine_name = '__madlib_temp_3494354_1376023760_2742638__'")

PivotalR:::.db.getQuery(content(z))

w <- db.array(x)

content(w)

content(w$agg_opr)

(w$agg_opr)@.col.data_type

content(w$agg_opr[1])

content((w$agg_opr)[1])

content(w[1])

eql(w, w$agg_opr)


