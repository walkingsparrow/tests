library(PivotalR)

db.connect(port = 5433)

delete("abalone")

x <- as.db.data.frame(abalone, "abalone", key = "id", add.row.names = FALSE)

names(x)

preview(x, 20)

preview(sort(x, by = "id"))

content(sort(x))

preview(sort(x, by = NULL))

z <- as.db.data.frame(x, "abalone_factor3")

z <- db.data.frame("abalone_factor2")

x$sex <- as.factor(x$sex)

fit <- madlib.lm(rings ~ . - id | sex, data = x)

fit

fit <- madlib.lm(rings ~ . - id, data = x)

fit

fit <- madlib.glm(rings < 10 ~ . - id, data = x, family = "binomial")

fit

madlib.summary(x)

madlib.summary(z, target.cols = "sex__madlib_temp_84373837_1369883536_19902144__M")

fit3 <- madlib.lm(rings ~ as.factor(sex) + length + diameter, data = x)

fit3

fit3 <- madlib.glm(rings < 10 ~ as.factor(sex) + length + diameter, data = x, family = "binomial")

fit3

## ------------------------------------------------------------------------

y <- db.data.frame("abalone")

names(y)

preview(mean(y$diameter))

## ------------------------------------------------------------------------

x <- db.data.frame("abalone")

names(x)

y <- x$height < x$length

preview(y, 10)

delete("abalone")

y <- as.db.data.frame(abalone, "abalone")

x == y

content(x == y)

eql(x, y)

preview(by(x, NULL, sum))

## ------------------------------------------------------------------------

x <- db.data.frame("madlibtestdata.lin_ornstein")

content(x$assets[x$nation == 1])

y <- x

y$assets[y$nation == 1] <- -23

content(y)

fit <- madlib.lm(interlocks ~ ., data = x)

fit

z <- predict(fit, newdata = x)

content(z)

preview(z, 10)

v <- x$interlocks
v$predict <- z

content(v)

preview(v, 10)

fit <- madlib.lm(interlocks ~ . | nation + sector, data = x)

fit

names(fit)

z <- predict(fit, newdata = x[])

fit <- madlib.lm(interlocks ~ I(assets^2) + sector | nation, data = x)

fit

## ------------------------------------------------------------------------

names(x)

y <- x[,1:5]

content(y)

y$new <- x[,6]

content(y)

## ------------------------------------------------------------------------

db.connect(port = 5433)

delete("abalone")

x <- as.db.data.frame(abalone, "abalone", key = "id", add.row.names = FALSE)

y <- x

y$length <- y$diameter + y$height

content(y$length)

content(sort(y, INDICES = y$length))

content(by(y, y$length, mean))

## ------------------------------------------------------------------------

x <- db.data.frame("abalone")

preview(x, 10)

key(x)

key(x) <- "id"

key(x)

## ------------------------------------------------------------------------

library(PivotalR)

db.connect(port = 5433)

x <- db.data.frame("madlibtestdata.lin_forestfires_oi")

dim(x)

preview(x, 10)

fit <- madlib.lm(y ~ -1 + x , data = x)

fit

fit <- madlib.lm(y ~ x[2] , data = x)

fit

fit <- madlib.lm(y ~ x - x[1], data = x)

fit

## ------------------------------------------------------------------------

library(PivotalR)

db.connect(dbname="fdic", user="gpadmin", host="10.110.122.107", password = "changeme")

db.connect(dbname="fdic", user="gpadmin", host="10.110.122.107", password = "")

db.list()

d <- db.data.frame("census1", 1)

d$wage<- d$earns/d$hours 

preview(d$wage, 10)

m1<- madlib.lm(wage ~ -1 + rooms, data=d) 

m1

d_part1<- db.data.frame("census1_part1")
d_part2<- db.data.frame("census1_part2")

preview(d_part1,1)
preview(d_part2,1)

d5<- merge(d_part1, d_part2, by = "row_id")

preview(d5, 10)

d1 <- as.db.data.frame(d[,], "census_2mil1")

## ------------------------------------------------------------------------

m1<- madlib.lm(wage ~ as.factor(h_state)+ rooms, data=d)

m1

d$h_state_factor<- as.factor(d$h_state)

preview(d, 1)

content(d)

d@.is.factor

delete("census1_temp10")

d3<- as.db.data.frame(d, "census1_temp10", 2)

d1_part1<- db.data.frame("census1_part1", 2)
d1_part2<- db.data.frame("census1_part2", 2)

d5 <- merge(d1_part1, d1_part2, by = c("h_serialno","h_state"))

preview(d5, 10)

## ------------------------------------------------------------------------

library(PivotalR)

db.connect(port = 5433)
db.connect(port = 5433)

delete("abalone", 2, is.temp = TRUE)

delete("abalone", 2, is.temp = FALSE)

x <- as.db.data.frame(abalone, "abalone", conn.id = 2)

preview(x, 10)

y <- as.db.data.frame(abalone, "abalone", conn.id = 2, is.temp = TRUE)

preview(y, 10)

db.existsObject("abalone", 2, is.temp = TRUE)

db.existsObject("abalone", 2, is.temp = FALSE)

delete("abalone", 2)

p <- db.objects()
p[p[,2] == "abalone",]
