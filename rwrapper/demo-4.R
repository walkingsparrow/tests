library(PivotalR)

db.connect(port = 5433)

db.connect(port = 14526, dbname = "madlib")

db.list()

## ------------------------------------------------------------------------

x <- db.data.frame("madlibtestdata.dt_abalone", key = "id", conn.id = 2)

dim(x)

names(x)

preview(x, 20)

print(preview(sort(x, by = "id"), 20), row.names = FALSE)

## ------------------------------------------------------------------------
## replacement and is.na

y <- x

content(is.na(y))

content(y[is.na(y$sex),])

y[is.na(y$sex),"sex"] <- 3

content(y)



## ------------------------------------------------------------------------
## is.na continued

y <- db.data.frame("dt_abalone_na", key = "id", conn.id = 2)

preview(y, 200)

print(preview(sort(y), 200), row.names = FALSE)

z <- y[is.na(y)]

content(y[is.na(y)])

y[is.na(y)] <- 3

content(y)

print(preview(sort(y), n = 200), row.names = FALSE)

z <- as.db.data.frame(y, "test_abalone")

z

y$new <- y$shell + y$rings + 2.3

content(y)

## ------------------------------------------------------------------------
## merge

y <- x[1:30,]

content(y)

z <- x[21:50,]

m <- merge(y, z, by = c("id", "sex"))

content(m)

preview(sort(m, by = "id"))

## ------------------------------------------------------------------------
## by

preview(by(y, y$sex, mean))

preview(by(y, NULL, mean))

## ------------------------------------------------------------------------
## various examples

names(x)

dim(x)

## find ID for each gender

sex.id <- by(y, y$sex, c)

preview(sex.id)

## ------------------------------------------------------------------------

content(y * 3 + 2)

preview(y * 3 + 2)

content(mean(y$rings))

content(mean(sort(y, by ="id")$rings))

preview(sort(y, "id"))

content(sort(y))


