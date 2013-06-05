library(PivotalR)

db.connect(port = 14526, dbname = "madlib")

x <- db.data.frame("fdic")

dim(x)

names(x)

dat <- read.csv("/Users/qianh1/workspace/tests/fdic/pipe_RIS_2004_2011_extract.csv", sep = "|")

## dat1 <- read.table("pipe_RIS_2004_2011_extract.csv", sep = "|", header = TRUE, fill = TRUE)

delete("fdic")

x <- as.db.data.frame("/Users/qianh1/workspace/tests/fdic/pipe_RIS_2004_2011_extract.csv", "fdic", sep = "|", header = TRUE, fill = TRUE)

delete("fdic")
x <- as.db.data.frame(dat, "fdic")

dim(x)

names(x)

fit <- madlib.lm(sf_mrtg_pct_assets ~ RIS_asset + LNCRCD + LNAUTO + LNCONOTH + LNCONRP + INTMSRFV + LNRENR1A + LNRENR2A + LNRENR3A, data = x)

y <- x[,c("sf_mrtg_pct_assets","RIS_asset", "LNCRCD","LNAUTO","LNCONOTH","LNCONRP","INTMSRFV","LNRENR1A","LNRENR2A","LNRENR3A")]

for (i in seq_len(length(names(y)))) y <- y[!is.na(y[i]),]

dim(y)

preview(length(y[1]))

fit <- madlib.lm(sf_mrtg_pct_assets ~ ., data = y)

fit

## ------------------------------------------------------------------------

fit0 <- lm(rings ~ . - id - sex, data = abalone)

summary(fit0)

x <- db.data.frame("abalone")

fit <- madlib.lm(rings ~ . - id - sex, data = x)

print(fit, digits = 5)
