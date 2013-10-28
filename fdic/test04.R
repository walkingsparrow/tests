library(PivotalR)

db.connect(port = 14526, dbname = "madlib")

x <- lookat("lintest", "all")

dim(x)

f <- lm(sf_mrtg_pct_assets ~ ris_asset + lncrcd + lnauto + lnconoth + lnconrp + intmsrfv + lnrenr1a + lnrenr2a + lnrenr3a, data = x)

s <- summary(f)

s$coefficients

s

g <- glm(sf_mrtg_pct_assets ~ ris_asset + lncrcd + lnauto + lnconoth + lnconrp + intmsrfv + lnrenr1a + lnrenr2a + lnrenr3a, data = x, family = "gaussian")

r <- summary(g)

r

r$coefficients
