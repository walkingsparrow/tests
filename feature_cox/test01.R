library(survival)

test1 <- list(time=c(4,3,1,1,2,2,3), 
              status=c(1,1,1,0,1,1,0), 
              x=c(0,2,1,1,1,0,0), 
              sex=c(0,0,0,0,1,1,1)) 

fit <- coxph(Surv(time, status) ~ x, test1) 

dg <- cox.zph(fit, transform="rank", global = F)

dg

print(dg)

plot(dg)

names(dg)

names(fit)

cor(fit$residuals, test1$time)

cor(fit$residuals, rank(test1$time))

sr <- 5 * fit$var * fit$residuals

cor(sr, rank(test1$time))

length(fit$coefficients)

sum(fit$residuals)

fit$residuals

rs <- resid(fit, "schoenfeld")

cor(rs, rank(as.numeric(names(rs))))

cor(rs, as.numeric(names(rs)))

## ----------------------------------------------------------------------

library(survival)
library(PivotalR)
library(car)

db.connect(port = 14526, dbname = "madlib")

dat <- db.data.frame("leukemia")

x <- lookat(dat, "all")

x

coxph(Surv(timedeath, status) ~ grp + wbc, data = x)

## ----------------------------------------------------------------------

rossi <- read.table('Rossi.txt', header=T)

rossi$age_cat <- recode(rossi$age, "lo:19=1; 20:25=2; 26:30=3; 31:hi=4")

rossi$age_cat <- recode(rossi$age, "lo:hi=1")

s0 <- coxph(Surv(week, arrest) ~ fin + prio, data = rossi, ties = "breslow")

s1 <- coxph(Surv(week, arrest) ~ fin + prio + strata(age_cat), data = rossi, ties = "breslow")

delete("rossi")
x <- as.db.data.frame(rossi, "rossi")

unique(rossi$age.cat)

r <- cox.zph(s0, transform=identity, global = FALSE)

## ----------------------------------------------------------------------

coxph(Surv(time, status) ~ age + ph.ecog + strata(inst), lung)

as.db.data.frame(lung, "madlibtestdata.lung")

## ----------------------------------------------------------------------

coxph(Surv(time,status>0) ~ trt + log(bili) + log(protime) + age + platelet + strata(sex), data=pbc)

coxph(Surv(time) ~ trt + log(bili) + log(protime) + age + platelet + strata(sex), data=pbc)

as.db.data.frame(pbc, "madlibtestdata.pbc")

s <- coxph(Surv(futime,status>0) ~ trt + log(bili) + log(protime) + age + platelet + strata(sex), data=pbcseq)

as.db.data.frame(pbcseq, "madlibtestdata.pbcseq")


## ----------------------------------------------------------------------

x <- db.data.frame("test")

key(x) <- "idx"

lookat(x[1,])

lookat(x[2,])

y <- x[1:2,]

lookat(x[1:2,])

lookat(y)

## ----------------------------------------------------------------------

library(glmnet)

db.connect(dbname="fdic", host="10.110.122.107", user="gpadmin", password="changeme")


x <- lookat("madlibtestdata.dt_abalone", conn.id=1, "all")



x <- as.matrix(abalone[,4:7])
y <- abalone$length

m1 <- glmnet(x, y, alpha = 0, lambda = 0.1)

names(m1)

m1$beta
m1$a0

sy <- (y - mean(y)) / (sd(y) * sqrt(4176/4177))

sy <- scale(y)

m2 <- glmnet(x, sy, alpha = 0, lambda = 0.1)

m2$beta
m2$a0

dat <- cbind(abalone, sy=as.numeric(sy))

delete("test_ab", conn.id=2)

as.db.data.frame(dat, "test_ab", conn.id=2)

## ----------------------------------------------------------------------

lookat1 <- function (x, nrows = 100, array = TRUE, ...)
{
    if (is(x, "db.table")) return (preview(x, nrows, array = array))
    if (is(x, "db.Rcrossprod")) return (preview(x, nrows, FALSE))
    if (is(x, "character")) {
        print("OK")
        if (! conn.id %in% ...)) print("Ah")
        conn.id <- ..1
        print(conn.id)
        return (preview(x, conn.id, nrows, array))
    }
    preview(x, nrows, FALSE, array)
}

x <- lookat1("madlibtestdata.dt_abalone", "all", conn=1)
