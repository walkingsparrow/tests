library(PivotalR)

db.connect(port = 14526, dbname = "madlib")

x <- db.data.frame("fdic")

sm <- summary(x)

dim(x)

names(x)

dat <- read.csv("/Users/qianh1/workspace/tests/fdic/pipe_RIS_2004_2011_extract.csv", sep = "|")

## dat1 <- read.table("pipe_RIS_2004_2011_extract.csv", sep = "|", header = TRUE, fill = TRUE)

## delete("fdic")

## x <- as.db.data.frame("/Users/qianh1/workspace/tests/fdic/pipe_RIS_2004_2011_extract.csv", "fdic", sep = "|", header = TRUE, fill = TRUE)

names(dat) <- tolower(names(dat))

x <- dat[1:10000,]

delete("null_data")
z <- as.db.data.frame(x, "null_data")

sm <- summary(x)

dim(x)

names(x)

fit <- madlib.lm(sf_mrtg_pct_assets ~ RIS_asset + LNCRCD + LNAUTO + LNCONOTH + LNCONRP + INTMSRFV + LNRENR1A + LNRENR2A + LNRENR3A, data = x)

y <- dat[,c("sf_mrtg_pct_assets","RIS_asset", "LNCRCD","LNAUTO","LNCONOTH","LNCONRP","INTMSRFV","LNRENR1A","LNRENR2A","LNRENR3A")]

for (i in seq_len(length(names(y)))) y <- y[!is.na(y[i]),]

dim(y)

preview(length(y[1]))

fit <- madlib.lm(sf_mrtg_pct_assets ~ ., data = y)

fit

sm <- summary(y)

z <- as.db.data.frame(y, "fdic_nonull")

y <- dat[,c("sf_mrtg_pct_assets","ris_asset", "lncrcd","lnauto","lnconoth","lnconrp","intmsrfv","lnrenr1a","lnrenr2a","lnrenr3a")]

null.data <- y

save(null.data, file = "null.data.RData")

delete("null_data")
z <- as.db.data.frame(y, "null_data")

y <- z

dim(y)

for (i in seq_len(length(names(y)))) y <- y[!is.na(y[i]),]

dim(y)

z <- as.db.data.frame(y, "fdic_lower_tencol")

## ------------------------------------------------------------------------

x <- db.data.frame("fdic_lower")

dim(x)

x1 <- preview(x, 10)

dim(x1)

u <- as.db.data.frame(x1, "fdic_small")

## ------------------------------------------------------------------------

library(PivotalR)

db.connect(port = 14526, dbname = "madlib")

x <- db.data.frame("fdic_lower")

dim(x)

sm <- summary(x)

y <- x[,1:30]
delete("fdic_lower_col")
z <- as.db.data.frame(y, "fdic_lower_col", nrow = 5)

dim(z)

sm <- summary(z)

## ------------------------------------------------------------------------

fit0 <- lm(rings ~ . - id - sex, data = abalone)

summary(fit0)

x <- db.data.frame("abalone")

fit <- madlib.lm(rings ~ . - id - sex, data = x)

print(fit, digits = 5)
