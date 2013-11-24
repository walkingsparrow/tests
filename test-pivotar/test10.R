select1 <- function (n, size) {
    select <- sample(seq(n), size, replace = TRUE)
    table(table(select))
}

select2 <- function (n, size) {
    fn <- function (x, y) {
        l <- length(x)
        s <- sample(seq_len(l), 1, prob = x)
        if (s == l) {
            x <- c(x, 1)
            x[l] <- x[l] - 1
        } else {
            x[s+1] <- x[s+1] + 1
            x[s] <- x[s] - 1
        }
        x
    }
    Reduce(fn, seq(size), n)[-1]
}

select3 <- function (n, size) {
    x <- n
    for (i in seq(size)) {
        l <- length(x)
        s <- sample(seq_len(l), 1, prob = x)
        if (s == l) {
            x <- c(x, 1)
            x[l] <- x[l] - 1
        } else {
            x[s+1] <- x[s+1] + 1
            x[s] <- x[s] - 1
        }
    }
    x[-1]
}

select4 <- function (n, size) {
    
}

select1(1e6, 1e5)

select2(1e6, 1e5)

select3(1e6, 1e5)

system.time(select1(1e6, 1e5))

system.time(select2(1e7, 1e6))
