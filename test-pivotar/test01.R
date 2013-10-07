library(PivotalR)

db.connect(port = 14526, dbname = "madlib")

bank <- read.csv("bank-full.csv", header = TRUE, sep = ";")

dim(bank)

as.db.data.frame(bank, "bank")

dim(bank[!is.na(bank$job),])

dbbank <- db.data.frame("bank")

madlib.lm(duration ~ age + as.factor(marital), data=dbbank)

madlib.glm(duration ~ age + as.factor(marital), data=dbbank)

y <- dbbank
y$marital <- as.factor(y$marital)

as.db.data.frame(y, "temp_bank")

z <- madlib.lm(age ~ day, dbbank)

madlib.lm(age ~ as.factor(marital), dbbank)

madlib.lm(age ~ as.factor(job), dbbank)

y <- dbbank

y$job <- as.factor(y$job)

content(y)

names(y)

attributes(y)

levels(bank$marital)

levels(bank$education)

f <- madlib.lm(age ~ as.factor(marital) + as.factor(education), data=dbbank)

f

madlib.lm(age ~ marital + education, data=dbbank)

lookat(sort(cbind(dbbank$age, predict(f, dbbank)), F, dbbank$age), 10)

AIC(f)

g <- lm(age ~ marital + education, data = bank)

summary(g)

AIC(g)

logLik(g)

logLik(f)

dim(dbbank)

sigma <- lookat(sd(dbbank$age - predict(f, dbbank)))
-45211 * (1 + log(2*pi*sigma))
