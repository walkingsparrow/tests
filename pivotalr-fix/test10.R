## prototype of Rd parser
library(PivotalR)

PivotalR:::.localVars$pkg.path

rdb <- paste(PivotalR:::.localVars$pkg.path, "/help/PivotalR.rdb", sep = "")

library(tools)

x <- Rd_db("PivotalR")

length(x)

seq(names(x))[grepl("generic\\.cv", names(x))]

y <- eval(parse(text = as.character(x[40])))

length(y)

z <- unlist(y[[13]])

z

sum(grepl("%%\\s+@test", z))

pa <- grepl("%%\\s+@test", z)

seq(z)[pa]

gsub("%%\\s+@test\\s+(\\S+)\\s+.*", "\\1", z[pa])
