library(PivotalR)
db.connect(port = 18526, dbname = "madlib")

db.connect(port = 14526, dbname = "madlib")

x <- db.data.frame("madlibtestdata.dt_abalone")

## -----------------------------------------------------------------------

f <- madlib.lm(rings ~ . - id - sex, data = x)

f

lookat(predict(f, x), 10)

## -----------------------------------------------------------------------

g <- madlib.glm(rings < 10 ~ . - id - sex, data = x, family = "binomial")

g

lookat(predict(g, x), 10)

## ------------------------------------------------------------------------

y <- db.data.frame("madlibtestdata.lin_auto_mpg_oi")

dim(y)

names(y)

f <- madlib.lm(y ~ x - `x[1]`, data = y)

f

content(predict(f, y))

lookat(predict(f, y), 10)

g <- madlib.glm(y<10 ~ x - `x[1]`, data = y, family = "binomial")

g

PivotalR:::.analyze.formula(y ~ x - x[1], data = y)


## ------------------------------------------------------------------------

f.str <- strsplit(paste(deparse(y ~ x - `x[1]`), collapse = ""), "\\|")[[1]]

f.str <- PivotalR:::.replace.array(f.str, y)

f.str

f1 <- formula(f.str[1])

f1

fdata <- PivotalR:::.expand.array(y)

fake.data <- data.frame(t(names(fdata)))

fake.data

f.terms <- terms(f1, data = fake.data)

f.terms
