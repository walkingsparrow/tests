library(PivotalR)

db.connect(port = 5433, dbname = "madlib")

dat <- db.data.frame("madlibtestdata.tsa_beer_time")

lk(min(dat$id) + "1 day")

lk(dat$id + "1 day")

lk(dat, 10)

lk(dat$id > '2005-02-28 16:00:11', 10)

lk(dat$id - '2005-02-28 16:00:11', 10)

content(dat$id - '2005-02-28 16:00:11')

lk('2005-02-28 16:00:11' - dat$id, 10)

dat$id2 <- '2005-02-23 16:00:11'
dat$id2 <- as.timestamp(dat$id2)

lk(dat$id2 - dat$id, 10)

content(dat$id2)

content(dat$id - dat$id2)

dat$id - dat$id2

lk(as.Date(dat$id), 10)

lk(as.Date(dat$id) - as.Date(dat$id2), 10)

lk(mean(dat$val) + mean(dat$val))

db.q("select ('2005-02-28 16:00:11')::timestamp - ('2005-02-27 16:00:11')::timestamp")

db.q("select ('16:00:11')::time + 1")

db.q("select ('2013-3-20')::date + '1 day'::interval")

db.q("select '1 day'::interval + 1")

content(as.Date(dat$id) + 1)

lk(as.Date(dat$id) + 2, 10)

lk(as.Date(dat$id) - '2005-01-29' > 2, 10)
