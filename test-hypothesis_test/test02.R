library(PivotalR)
db.connect(port = 5433, dbname = "madlib")

dat <- lk("madlibtestdata.ht_normal_middle", -1)

dim(dat)

db.q("select (madlib.chi2_gof_test(observed, 1, 10)).* from madlibtestdata.ht_normal_middle")

x <- dat$observed
p <- rep(1 / length(x), length(x))

z <- chisq.test(x, p = p)

z

sqrt(z$statistic / length(x))

sqrt(z$statistic / (length(x) + z$statistic))

names(z)

z$stdres

## ----------------------------------------------------------------------

db.q("select (madlib.t_test_two_unpooled(first, value)).* from madlibtestdata.ht_normal_small")

dat1 <- lk("madlibtestdata.ht_normal_small", -1)

x <- dat1$value[dat1$first]
y <- dat1$value[!dat1$first]

a <- t.test(x, y, var.equal = FALSE)

a$statistic

t.test(x, y, alternative = 'g', var.equal = FALSE)

db.q("select (madlib.t_test_two_unpooled(first, value)).* from madlibtestdata.ht_normal_middle")

a <- t.test(x, y, var.equal = FALSE)

a

a$statistic

## ----------------------------------------------------------------------

dd <- dat[order(dat$id),]

dd[1:20,]

## ----------------------------------------------------------------------

a <- db.q("SELECT (f).* FROM (
        SELECT madlib.ks_test(
            first, value,
            (SELECT count(value) FROM (
                SELECT * FROM madlibtestdata.ht_normal_middle
                ORDER BY id) t1
            WHERE first),
            (SELECT count(value) FROM (
                SELECT * FROM madlibtestdata.ht_normal_middle
                ORDER BY id) t2
            WHERE NOT first)
            ORDER BY value) AS f
        FROM (
            SELECT first, value FROM madlibtestdata.ht_normal_middle
            ORDER BY id
        ) s1
    ) s2")

x <- dat$value[dat$first]
y <- dat$value[!dat$first]

z <- ks.test(x, y, alternative = 't', exact = FALSE)

a
z

names(z)

1 - z$p.value

z$statistic

r <- sqrt(500/2)
(r + 0.12 + 0.11/r) * z$statistic

dd <- dat[order(dat$value),]
md <- sapply(1:1000, function(i) abs(sum(dd$first[1:i]) - sum(!dd$first[1:i])))
max(md)

.Call(stats:::C_pSmirnov2x, z$statistic, 500, 500)

.Call(stats:::C_pKolmogorov2x, z$statistic, 500)

1 - .Call(stats:::C_pSmirnov2x, z$statistic, 500, 500)

1 - .Call(stats:::C_pKolmogorov2x, z$statistic, 500)

1 - .Call(stats:::C_pKolmogorov2x, 0.1912601437, 500)

1 - .Call(stats:::C_pSmirnov2x, 0.8287939562, 500, 500)

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

1 - pkstwo(sqrt(500) * z$statistic)

exp(-2 * 500 * z$statistic^2)

## ----------------------------------------------------------------------

a <- db.q("SELECT (f).* FROM (
        SELECT madlib.mw_test(first, value ORDER BY value) AS f
        FROM (
            SELECT first, value FROM madlibtestdata.ht_normal_middle
            ORDER BY id
        ) s1
    ) s2")

x <- dat$value[dat$first]
y <- dat$value[!dat$first]

z <- wilcox.test(x, y, alternative = 'l', mu = -mean(x) + mean(y))

a
z1

z1 <- wilcox.test(x, y, alternative = 'g')

names(z)

z1$p.value

names(z1)

z$statistic

z$parameter

m <- 500
n <- 500
(z1$statistic - m*n/2) / sqrt(m*n*(m+n+1)/12)

(120812 - m*n/2) / sqrt(m*n*(m+n+1)/12)

## ----------------------------------------------------------------------

a <- db.q("SELECT (f).* FROM (
        SELECT madlib.wsr_test(value ORDER BY abs(value), 0) AS f
        FROM (
            SELECT * FROM madlibtestdata.ht_normal_middle
            ORDER BY id
        ) s1
    ) s2")

a

x <- dat$value

z <- wilcox.test(x)

names(z)

z$statistic

wilcox.test(x, alternative = 'g')

sum(sapply(1:length(x),
           function(i) if (x[i] > 0)
           sum(abs(x) < abs(x[i])) + (sum(abs(x)==abs(x[i])) + 1)/2
           else 0))

sum(sapply(1:length(x),
           function(i) if (x[i] < 0)
           sum(abs(x) < abs(x[i])) + (sum(abs(x)==abs(x[i])) + 1)/2
           else 0))

t <- sapply(1:length(x), function(i) sum(abs(x) == abs(x[i])))

n <- length(x)
w <- z$statistic

(w - n*(n+1)/4)/sqrt(n*(n+1)*(2*n+1)/24 - sum(t^2-1)/48)

## ----------------------------------------------------------------------

a <- db.q("
    SELECT (f).* FROM (
        SELECT madlib.one_way_anova(group_id, value) AS f
        FROM (
            SELECT group_id, value FROM madlibtestdata.ht_normal_middle
            ORDER BY id
        ) s1
    ) s2")

a

f <- lm(value ~ as.factor(group_id), data = dat)

w <- anova(f)

w

names(w)
