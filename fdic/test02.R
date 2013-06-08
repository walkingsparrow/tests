library(PivotalR)

db.connect(port = 14526, dbname = "madlib")

db.connect(port = 5433)

## db.list()

## dat <- read.csv("/Users/qianh1/workspace/tests/fdic/pipe_RIS_2004_2011_extract.csv", sep = "|")

## names(dat) <- tolower(names(dat))

## delete("fdic_lower")
## x <- as.db.data.frame(dat, "fdic_lower")

x <- db.data.frame("fdic_lower")

dim(x)



delete("fdic_lower_col")

z <- as.db.data.frame(x[,], "fdic_lower_col", nrow = 10)

dim(z)

delete("fdic_lower_row")
z1 <- as.db.data.frame(x[,], "fdic_lower_row", nrow = 4000)

dim(z1)

nx <- x
nx[is.na(nx)] <- 45

s <- as.db.data.frame(nx, "fdic_nonull_test")

dim(s)

s <- db.data.frame("fdic_nonull_test", 2)

delete("fdic_lower_row", 2)
z1 <- as.db.data.frame(s[,], "fdic_lower_row", nrow = 10)

## ------------------------------------------------------------------------

d <- as.data.frame(array(rnorm(300), dim = c(10, 30)))

names(d) <- tolower(names(d))

delete("fake_dat")
dd <- as.db.data.frame(d[,1:30], "fake_dat")

## ------------------------------------------------------------------------

db.list()

