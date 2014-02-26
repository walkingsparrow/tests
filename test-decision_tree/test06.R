library(PivotalR)
db.connect(port = 16526, dbname = "madlib")

library(rpart)

names(solder)

str(solder)

msolder <- solder
names(msolder) <- tolower(names(solder))

for (i in 1:10) msolder <- rbind(msolder, msolder)

dim(msolder)

fit <- rpart(solder ~ opening + mask + padtype + panel + skips,
             data = msolder, parms = list(split = "information"),
             control = list(maxdepth = 4, minbucket = 1, minsplit = 2))

fit

delete("msolder")
as.db.data.frame(msolder, "msolder")
