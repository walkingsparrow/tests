library(PivotalR)

db.connect(port = 14526, dbname = "madlib")

dat <- db.data.frame("t3")

system.time(PivotalR:::.cut.data(dat, 10))

system.time(PivotalR:::.approx.cut.data(dat, 10))

lst <- list(item = 3)
gsub(paste("<", "item", ">", sep = ""), lst[["item"]], "<item> is 3")


PivotalR:::.format("SELECT c.oid
                 FROM pg_catalog.pg_class c
                 LEFT JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
                 WHERE c.relname ~ '^(<table.name>)$'
                 AND n.nspname ~ '^(<table.schema>)$'
                 AND pg_catalog.pg_table_is_visible(c.oid)
                 ORDER BY 2, 3", list(table.name="lda_nytimes_corpus",
                                      table.schema="madlibtestdata"))
