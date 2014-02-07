library(PivotalR)
db.connect(port = 5433, dbname = "madlib")

dat <- lk("madlibtestdata.ht_normal_middle", -1)

x <- dat$value[dat$first][sample(1:500, 200, replace = F)]
y <- dat$value[!dat$first][sample(1:500, 200, replace = F)]

z <- ks.test(x, y, alternative = 't', exact = TRUE)

r <- sqrt(length(x)*length(y)/(length(x) + length(y)))
k <- (r + 0.12 + 0.11/r) * z$statistic

k

z

first <- c(rep(TRUE, length(x)), rep(FALSE, length(y)))
value <- c(x, y)

delete("ks_test")
tt <- as.db.data.frame(data.frame(first=first, value=value), "ks_test")

a <- db.q("SELECT (f).* FROM (
        SELECT madlib.ks_test(
            first, value,
            (SELECT count(value) FROM (
                SELECT * FROM ks_test) t1
            WHERE first),
            (SELECT count(value) FROM (
                SELECT * FROM ks_test) t2
            WHERE NOT first)
            ORDER BY value) AS f
        FROM (
            SELECT first, value FROM ks_test
        ) s1
    ) s2")

a
z

pkstwo <- function(x, tol = 1e-06) {
    if (is.numeric(x))
        x <- as.double(x)
    else stop("argument 'x' must be numeric")
    p <- rep(0, length(x))
    p[is.na(x)] <- NA
    IND <- which(!is.na(x) & (x > 0))
    if (length(IND))
        p[IND] <- .Call(stats:::C_pKS2, p = x[IND], tol)
    p
}

w <- c(x,y)
n.x <- length(x)
n.y <- length(y)
z1 <- cumsum(ifelse(order(w) <= n.x, 1/n.x, -1/n.y))

length(unique(w))

z1 <- z1[c(which(diff(sort(w)) != 0), n.x + n.y)]

statistic <- max(abs(z1))
statistic

n.x <- length(x)
n.y <- length(y)
n <- n.x * n.y / (n.x + n.y)

1 - pkstwo(sqrt(n) * statistic)

1 - .Call(stats:::C_pSmirnov2x, statistic, n.x, n.y)

1 - .Call(stats:::C_pKolmogorov2x, statistic, 100)

db.q("copy ks_test to '/Users/qianh1/workspace/tests/test-hypothesis_test/ks_test.csv' with csv header")


expected.i <- 1

if (is.na(expected.i) || is(expected.i, "try-error")) {
    p <- dat[[expected]]
} else {
    p <- rep(1 / 10, 10)
}
