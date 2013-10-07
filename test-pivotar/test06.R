library(PivotalR)

db.connect(port = 14526, dbname = "madlib")

x <- db.data.frame("madlibtestdata.dt_abalone")

f <- madlib.lm(log(rings) ~ . - id - sex, data = x)

f

AIC(f, k=5)

y <- lookat(x, "all")

g <- lm(log(rings) ~ . - id - sex, data = y)

AIC(g, k=5)

summary(g)

resid(f)

f$data

f$terms[[2]]

with(f$data, f$terms[[2]])

with(f$data, rings)

a <- f$terms[[2]]

with(f$data, expression(rings))

with(f$data, expression("rings"))

a <- eval(parse(text=paste0("with(f$data,", deparse(f$terms[[2]]), ")")))

content(a)
