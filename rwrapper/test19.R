library(PivotalR)
db.connect(port = 5433, dbname = "madlib")

dat <- db.data.frame("madlibtestdata.pbc")

dat$sex[dat$sex == "f",] <- NA

content(dat)

f <- madlib.lm(protime ~ . + as.factor(sex), data = dat, na.action = na.omit)

f

dat1 <- as.db.data.frame(dat)

dat2 <- na.omit(dat1, vars = c("\"protime\"", "\"id\"", "\"time\"", "\"status\"",  "\"trt\"", "\"age\"", "\"sex\"", "\"ascites\"" ,"\"hepato\""   ,"\"spiders\"" ,"\"edema\""    ,"\"bili\""     ,"\"chol\""     ,"\"albumin\""  ,"\"copper\""  ,"\"alk.phos\"" ,"\"ast\""      ,"\"trig\""     ,"\"platelet\"" ,"\"stage\""   ,"sex"  ))

dat3 <- as.db.data.frame(dat2)

f <- madlib.lm(protime ~ . + as.factor(sex), data = dat1, na.action = na.omit)

f



t1 <- db.data.frame("t1")

t1$val <- as.factor(t1$val)

delete("t2")
as.db.data.frame(t1, "t2")

content(dat)

content(dat[is.na(as.factor(dat$sex)),])

content(dat[is.na(I(dat$sex)),])

