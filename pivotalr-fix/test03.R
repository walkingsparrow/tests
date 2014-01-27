library(PivotalR)
db.connect(port = 5433, dbname = "madlib")

dat <- db.data.frame("madlibtestdata.dt_abalone")

madlib.lm(rings ~ diameter + diameter^2:factor(sex), data = dat)

f <- madlib.lm(rings ~ diameter + diameter^2:sex, data = dat)

f

margins(f)

madlib.lm(rings ~ diameter + I(diameter^2):factor(sex), data = dat)

f <- madlib.lm(rings ~ diameter + I(diameter^2):sex, data = dat)

f

margins(f)

madlib.lm(rings ~ diameter + diameter:length:sex, data = dat)

summary(lm(rings ~ diameter + sex + diameter^2:sex, data = abalone))

summary(lm(rings ~ diameter + sex + I(diameter^2):sex, data = abalone))

f <- madlib.lm(rings ~ diameter + sex + diameter^2:sex, data = dat)

f

margins(f)

dat$sex <- relevel(dat$sex, "F")

f <- madlib.lm(rings ~ diameter + sex + I(diameter^2):sex, data = dat)

f

predict(f, dat)

margins(f)

m <- model.matrix(~ diameter + sex + I(diameter^2):sex - 1, data = abalone)

colnames(m)

gsub("\"", "`", "\"sex__madlib_temp_d534860e_f572_9e9693_b52f194d7083__I\"")
