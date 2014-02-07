library(knitr)

?knit

f <- system.file("examples", "knitr-minimal.Rnw", package = "knitr")

knit(f)
