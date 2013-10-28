library(PivotalR)

db.connect(port = 14526, dbname = "madlib")

dbbank <- db.data.frame("madlibtestdata.bank")

dbbank$resp <- dbbank$default == "yes"

m <- madlib.glm(resp ~ age + factor(marital) + factor(education) + factor(housing) + factor(loan) + factor(job), family="binomial", data=dbbank)

m

m <- madlib.glm(default == "yes" ~ age + factor(marital) + factor(education) + factor(housing) + factor(loan) + factor(job), family="binomial", data=dbbank)

m

x <- dbbank
x$job <- as.factor(x$job)

attributes(x)

y <- db.data.frame("test_pivot2")

names(y)

with(y, `job__madlib_temp_19770113_1382551627_18413830__self-employed`)

x <- db.data.frame("madlibtestdata.lin_auto_mpg_oi")

madlib.lm(y ~ ., data = x)

content(with(x, x[1]))

content(with(x, `x[1]`))

z <- PivotalR:::.expand.array(x)

content(z)

content(with(z, `x[1]`))

db.data.frame(x, "test_pivot2")
