library(PivotalR)

.unique.string <- function ()
{
    r1 <- sample(seq_len(100000000), 1)
    r2 <- unclass(as.POSIXct(strptime(date(),"%c")))[1]
    r3 <- r2 %% r1
    paste("__madlib_temp_", r1, "_", r2, "_", r3, "__", sep = "")
}

.unique.string <- function ()
{
    ## r1 <- sample(seq_len(100000000), 1)
    r1 <- as.integer(runif(1) * 1e8) + 1
    
    r2 <- unclass(as.POSIXct(strptime(date(),"%c")))[1]
    r3 <- r2 %% r1
    paste("__madlib_temp_", r1, "_", r2, "_", r3, "__", sep = "")
}


test <- function(n) {
    res <- rep("a", n)
    for (i in 1:n) res[i] <- .unique.string()
}

test1 <- function(n) {
    res <- rep(0, n)
    for (i in 1:n) res[i] <- sample(seq_len(10), 1)
}

test2 <- function(n) {
    res <- rep(0, n)
    for (i in 1:n) res[i] <- as.integer(runif(1) * 1e8) + 1
}


system.time(test(100))

system.time(test1(100))

system.time(test2(100))

system.time(sample(1e8, 1e7, replace = TRUE))


