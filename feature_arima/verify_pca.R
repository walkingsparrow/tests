
library(PivotalR)

db.connect(port=14526, dbname="madlib")

tbl <- db.data.frame("madlibtestdata.pca_mat_100_200")

x <- lookat(sort(tbl, F, tbl$row_id), "all")[,-1]

p <- prcomp(x)

names(p)

p$sdev

p$rotation[,1:2]
