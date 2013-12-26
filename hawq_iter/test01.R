x <- array(rnorm(1000000 * 20), dim = c(1000000, 20))
y <- sample(0:1, 1000000, replace = TRUE)
g <- sample(1:10, 1000000, replace = TRUE)

g <- glm(y ~ x, family = "binomial")

save(x, y, g, file="testdat_grp10.rda")

load("testdat1.rda")
delete("perf_grp1000")
dat <- as.db.data.frame(as.data.frame(cbind(x, y, g)), "perf_test1000")

summary(g)

library(PivotalR)
db.connect(port = 18526, dbname = "demo")

load("testdat_grp10.rda")
delete("perf_grp10")
dat <- as.db.data.frame(as.data.frame(cbind(x, y, g)), "perf_test10")

## dat <- db.data.frame("perf_test")

madlib.lm(y ~ ., data = dat)

fit <- madlib.glm(as.integer(y) ~ ., data = dat, family = "binomial")

system.time({fit <- madlib.glm(as.integer(y) ~ . | g, data = dat, family = "binomial", control = list(max.iter=3, tolerance=0))})

system.time({fit <- madlib.glm(as.integer(y) ~ ., data = dat, family = "binomial", control = list(method = "cg", max.iter=10, tolerance=0))})

fit
