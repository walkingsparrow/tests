
rossi <- read.table("Rossi.txt", header = TRUE)

dim(rossi)

t <- rossi[1:432, 1:9]

names(t)

names(rossi)

library(PivotalR)

db.connect(port = 14526, dbname = "madlib")

x <- as.db.data.frame(t, "rossi_part")
