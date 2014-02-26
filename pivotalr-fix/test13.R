library(PivotalR)

db.connect(port = 5433, dbname = "madlib")

library(testthat)

test_that("test glm step",
expect_that(
    ## capture.output(
    {
    cid <- db.connect(port = 5433, dbname = 'madlib', verbose = FALSE)
    source_data <- as.db.data.frame(abalone, conn.id = cid, verbose = FALSE)
    start <- madlib.glm(rings < 10 ~ . - id - sex, data = source_data, family = "binomial")
    step(start)
    db.disconnect(cid, verbose = FALSE)
},
        ## file = "/tmp/899798797__madlib.txt"),
            PivotalR:::has_no_error()))


eval(parse(text = paste("expectation(FALSE,", paste("'code generated an error: ", "Error in madlib.glm(formula = rings < 10 ~ diameter + height + whole +  : \n  object \\'source_data\\' not found\n", "')", sep = ""))))

s <- "Error in madlib.glm(formula = rings < 10 ~ diameter + height + whole +  : \n  object 'source_data' not found\n"

gsub("'", "\\\\'", s)

x <- array(rnorm(10000), dim = c(500, 20))
y <- rnorm(500)
dat <- data.frame(x, y)
start <- lm(y ~ ., data = dat)
step(start)

test_that("test step function",
          expect_that({
              x <- array(rnorm(10000), dim = c(500, 20))
              y <- rnorm(500)
              dat <- data.frame(x, y)
              print(environment())
              print(parent.env(environment()))
              print(ls())
              print(ls(parent.env(environment())))
              ## start <- lm(y ~ ., data = dat)
              ## step(start)
          }, not(throws_error())))

test_that(
    "test lm step",
    expect_that({
        cid <- db.connect(port = 5433, dbname = 'madlib', verbose = FALSE)
        dat <- as.db.data.frame(abalone, conn.id = cid, verbose = FALSE)
        ## print(content(dat))
        ## assign("dat", dat, envir = parent.env(environment()))
        print(environment())
        print(parent.env(environment()))
        print(ls())
        print(ls(parent.env(environment())))
        start <- madlib.lm(rings ~ . - id - sex, data = dat)
        step(start)
        db.disconnect(cid, verbose = FALSE)
    },
                PivotalR:::has_no_error()))

expect_that({
    cid <- db.connect(port = 5433, dbname = 'madlib', verbose = FALSE)
    dat <- as.db.data.frame(abalone, conn.id = cid, verbose = FALSE)
    print(content(dat))
    print(environment())
    print(parent.env(environment()))
    ## assign("dat", dat, envir = parent.env(environment()))
    start <- madlib.lm(rings ~ . - id - sex, data = dat)
    step(start)
    db.disconnect(cid, verbose = FALSE)
},
            PivotalR:::has_no_error())
