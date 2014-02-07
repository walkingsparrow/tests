timing <- function(expr) {
    t0 <<- proc.time()
    res <- eval(expr)
    t1 <- proc.time()
    print(t1 - t0)
    return (res)
}

timing(sin(2.3))

timing(Sys.sleep(10))

t0 <- 10

timing(print(t0))

substitue(expression)

func1 <- function(dat, eval.this) {
    eval(parse(text = paste0("with(dat, ", eval.this, ")")))
}

dat <- data.frame(x = 1:2, y = 2:3)

func1(dat, "x*2+y")

func1(dat, "sin(x)*cos(y)")

system.time({for (i in 1:10000) p <- with(dat, sin(x)*cos(y))})

system.time({for (i in 1:10000) p <- eval(parse(text = "with(dat, sin(x)*cos(y))"))})

system.time({for (i in 1:10000) p <- eval(parse(text = paste0("with(dat, ", "sin(x)*cos(y)",")")))})

system.time({for (i in 1:10000) p <- with(dat, eval(parse(text="sin(x)*cos(y)")))})

with(dat, expression(sin(x)*cos(y)))

with(dat, expression(parse(text = "sin(x)*cos(y)")))

eval(parse(text = "sin(x)*cos(y)"), envir = dat)

system.time({for (i in 1:10000) p <- eval(parse(text = "sin(x)*cos(y)"), envir = dat)})

a <- enquote(sin(x)*cos(y))

a <- parse(text = "sin(x)*cos(y)")
system.time({for (i in 1:10000) p <- with(dat, eval(a))})
