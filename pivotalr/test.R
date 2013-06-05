
test <- function (x)
{
    match.call()
}

a <- test(x = 3)

y <- c(1,2,3)
a <- test(y)
