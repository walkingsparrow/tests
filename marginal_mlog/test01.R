library(mlogit)

options(width = 150)

data(Fishing)

dim(Fishing)

names(Fishing)

Fishing[1:10,]

levels(Fishing[,1])

library(PivotalR)

db.connect(port = 14526, dbname = "madlib")

x <- as.db.data.frame(Fishing, "fishing")

dim(x)

names(x)

content(unique(x$mode))

## ------------------------------------------------------------------------

Fish <- mlogit.data(Fishing, shape="wide", varying=2:9, choice="mode")

dim(Fish)

Fish[1:10,]

