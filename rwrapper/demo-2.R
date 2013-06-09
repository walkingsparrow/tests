library(PivotalR)

## ------------------------------------------------------------------------

## Connect to multiple databases on different hosts

db.connect(port = 5433) # suppose you have MADlib installed on madlib schema

db.connect(port = 5433, madlib = "test1") # give the correct warning 

db.connect(dbname="fdic", user="gpadmin", host="10.110.122.107", password = "changeme", madlib="madlib_v05")

db.list()

## ------------------------------------------------------------------------

## Extraction methods

## default connection is 1
x <- db.data.frame("ornstein")

y <- x[,]

content(y)

content(x$assets < x$sector)

y <- x$assets < x$sector

y@.col.data_type

content(!(x$assets < x$sector))

z <- x[,'nation']

content(z)

content(y$nation)

y$nation <- z$nation + 1

content(y)

y <- y[x$nation < 10,]

content(y)

y <- y[y$nation < 10,]

content(y)

dim(x)

names(x)

x[[1]]

content(x[[1]])

x$sector

content(x$sector)

x[,1:2]

content(x[,1:2])

z <- x[,1:2]

z$assets

content(z$assets)

x[,c("assets", "sector")]

content(x[,c("assets", "sector")])

x[,-1]

content(x[,-1])

content(x[x$interlocks < 20,])

preview(x[x$interlocks < 20,], 50, FALSE)

w <- as.db.data.frame(x[x$interlocks < 20,], "lin_ornstein_part")

delete("lin_ornstein_part")

w <- as.db.data.frame(x[x$interlocks < 20,], "lin_ornstein_part")

preview(w, 20)

preview(x[x$interlocks < 20,], 20, FALSE)

content(x[x$interlocks < 20,]$nation)

## ------------------------------------------------------------------------

## Replace method

u <- x

u

u$interlocks <- u$sector + 2.3

u

u$new <- u$sector %% 3

names(u)

content(u)

preview(u, 10)

## ------------------------------------------------------------------------

## Linear & Logistic regressions

## Specify the primary key
y <- db.data.frame("ornstein", key = "key")

y

dim(y)

names(y)

preview(y, 50)

preview(y[y$key<50,], 100)

y[1,] # must specify key if you want to use such expressions

content(y[1,])

preview(y[1,], interactive = FALSE)

content(y[y$key<20,])

content(y[1:20,]) # must specify key if you want to use such expressions

content(y[,])

delete("temp_79874")

z <- as.db.data.frame(y[y$key<150,], "temp_79874", verbose = TRUE)

f <- madlib.lm(interlocks ~ sector + assets | nation, data = y)

f

f <- madlib.lm(interlocks ~ sector + assets | nation, data = y[y$key<150,])

f

f <- madlib.glm(interlocks<20 ~ sector + assets | nation, data = y, family = "binomial")

f

f <- madlib.glm(interlocks<20 ~ sector + assets | nation, data = y[y$interlocks<40,-5], family = "binomial")

f

## ------------------------------------------------------------------------

## Support for factor (Categorial variable)

t <- y

preview(t, 20)

t$nation <- as.factor(t$nation)

## If you create table, extra columns will be created
## There are unique string in the name of extra column
## to avoid name conflicts
z <- as.db.data.frame(t, "or_factor", is.temp = TRUE)

names(z)

delete(z)

f <- madlib.lm(interlocks ~ assets + nation, data = t)

f

f <- madlib.glm(interlocks < 20 ~ assets + nation, data = t, family = "binomial")

f

f <- madlib.lm(interlocks ~ assets + nation * sector | nation, data = t)

f

## ------------------------------------------------------------------------

## Directly specify which column is categorial variable

s <- y

s

f <- madlib.lm(interlocks ~ assets + as.factor(nation), data = s)

f

f <- madlib.glm(interlocks < 20 ~ assets + as.factor(nation), data = s, family = "binomial")

f

f <- madlib.lm(interlocks ~ assets + sector * as.factor(nation), data = s)

f

f <- madlib.lm(interlocks ~ assets + sector : as.factor(nation), data = s)

f

f <- madlib.lm(interlocks ~ assets + sector : as.factor(nation) | nation, data = y)

f

## ------------------------------------------------------------------------

## Wrapper for MADlib summary function

madlib.summary(s)

madlib.summary(s$nation)

## ------------------------------------------------------------------------

## ------------------------------------------------------------------------

## A key can have multiple rows

## Specify the key
x <- db.data.frame("census1", key = "h_serialno", conn.id = 3)

x

dim(x)

names(x)

preview(x, 30)

## actually no need to specify key if you want to use such expressions
x[x$h_serialno == 2655447,]

preview(x[x$h_serialno == 2655447,], 20, FALSE) 

preview(x[2655447,], 20, FALSE) 
