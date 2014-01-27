library(ggmap)

Map <- get_map()

p <- ggmap(Map)

p

## ----------------------------------------------------------------------

library(PivotalR)
db.connect(port = 5433, dbname = "madlib")

dat <- db.data.frame("madlibtestdata.dt_abalone")

content(cbind(dat$rings, dat$sex))

content(cbind(dat$rings, 1))

cbind(1:3, 2:4, 3:5)
