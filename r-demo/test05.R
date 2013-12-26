library(PivotalR)
library(glmnet)

db.connect(port = 14526, dbname = "madlib")

setwd("~/workspace/rwrapper/insurance_demo")
source("getData.R")

ticcompl <- getData()
tmp <- ticcompl
names(tmp) <- tolower(names(tmp))

save(tmp, file = "tmp.rda")

dim(tmp)

idx <- sample(seq_len(nrow(tmp)), 1e6, replace = TRUE, prob = ifelse(tmp[,86] == 0, 586, 9236))
dat <- tmp[idx,]

x <- as.matrix(dat[,-86])
y <- dat[,86]

gf <- glmnet(x, y, family = "binomial", alpha = 1, lambda = 0.05)

gf$beta
gf$a0


