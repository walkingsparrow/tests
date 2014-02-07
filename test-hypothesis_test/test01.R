library(PivotalR)
db.connect(port = 5433, dbname = "madlib")

dat <- db.data.frame("madlibtestdata.ht_normal_middle")

dat <- lk(dat, -1)

dat$nan_value

dat$null_value

dat[1:10,]

dat <- get.data(dataset)

x <- dat$shifted_value[dat$first]
y <- dat$shifted_value[!dat$first]

var.test(x, y, alternative = 'less')

db.q("SELECT (f).* FROM (
        SELECT madlib.f_test(first, shifted_value) AS f
        FROM (
            SELECT first, shifted_value FROM madlibtestdata.ht_normal_middle
            ORDER BY id
            LIMIT 1000
        ) s1
    ) s2;")


db.q("SELECT (f).* FROM (
        SELECT madlib.t_test_one(zero_entry_value) AS f
        FROM (
            SELECT zero_entry_value FROM madlibtestdata.ht_normal_small
            ORDER BY id
            LIMIT 20
        ) s1
    ) s2;")


## ----------------------------------------------------------------------
