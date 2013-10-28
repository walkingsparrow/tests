
res <- rep(0, 10)
for (i in seq_len(1000)) {
    s <- sample(seq_len(10^6), 10^5, replace = TRUE)
    a <- table(table(s)) / 10^6
    b <- a[1:10]
    b[is.na(b)] <- 0
    res <- res + b
}

res <- res / 1000

a <- rep(0, 10)
for (i in 1:10) a[i] <- sum(res[i:10])

a
n

sum(a)

plot(res, type = 'b')

sum(res * (1:10))

dpois(1:10, 0.1)

