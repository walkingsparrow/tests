library(PivotalR)
db.connect(port = 5433, dbname = "madlib")
options(width = 100)

dat <- db.data.frame("madlibtestdata.dt_abalone")

dat$sex <- relevel(dat$sex, "M")

fit <- madlib.lm(rings ~ . - id, data = dat)

fit

margins(fit)

## ----------------------------------------------------------------------

fit <- madlib.lm(rings ~ length + I(diameter*height) + log(1+shell) | sex, data = dat)

fit

margins(fit, ~ Vars(fit) + Terms())

## ----------------------------------------------------------------------

fit <- madlib.lm(rings ~ . - id + factor(sex), data = dat)

fit

dat$sex <- as.factor(dat$sex)

dat$sex <- relevel(dat$sex, ref = "M")

madlib.lm(rings ~ . - id, data = dat)



margins(fit, ~ ., at.mean = FALSE)


## ----------------------------------------------------------------------

dat <- db.data.frame("madlibtestdata.lin_auto_mpg_wi")

fit <- madlib.lm(y ~ x[2] + x[3]:x[4], data = dat)

fit

margins(fit)

dat$x[3] <- as.factor(dat$x[3])

fit <- madlib.lm(y ~ x[2] + factor(x[3]), data = dat)

## ----------------------------------------------------------------------

`[<-.data.frame` <- function (x, i, j, value) 
{
    if (!all(names(sys.call()) %in% c("", "value"))) 
        warning("named arguments are discouraged")
    nA <- nargs()
    print(nA)
    if (nA == 4L) {
        has.i <- !missing(i)
        has.j <- !missing(j)
        print("*********")
        print(missing(i))
        print(missing(j))
    }
}

setClass("test3", representation(val = "numeric"))

setMethod("[<-",
          signature (x = "test2"),
          function(x, i, j, value) {
              print(nargs())
              print(hasArg(x))
              print(hasArg(i))
              print(hasArg(j))
              print(hasArg(value))
              print("***********")
          })

`[<-.test3` <- function(x, i, j, value) print(nargs())

x <- new("test3")

x[1] <- "a"

`[<-`(x=x, j=1, value = "a")

`[<-.test1` <- function(x, i, j, value) print(nargs())

y <- 1
class(y) <- "test1"

y[1] <- "a"
