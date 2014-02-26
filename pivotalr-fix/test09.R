        x <- matrix(rnorm(100*20),100,20)
        y <- rnorm(100, 0.1, 2)

        dat <- data.frame(x, y)
        delete("eldata", conn.id = 1)
        z <- as.db.data.frame(dat, "eldata", conn.id = 1, verbose = FALSE)

        g <- generic.cv(
            train = function (data, alpha, lambda) {
                madlib.elnet(y ~ ., data = data, family = "gaussian", alpha =
                             alpha, lambda = lambda, control = list(random.stepsize=TRUE))
            },
            predict = predict,
            metric = function (predicted, data) {
                lk(mean((data$y - predicted)^2))
            },
            data = z,
            params = list(alpha=1, lambda=seq(0,0.2,0.1)),
            k = 5, find.min = TRUE, verbose = FALSE)
