library(PivotalR)
db.connect(port = 5433, dbname = "madlib")

dat <- lk("madlibtestdata.ar_connect", -1)
dat[,2] <- gsub("\\n", "", dat[,2])

names(dat)

dim(dat)

dat[1:10,]

table(dat[,1])

input <- data.frame(do.call("rbind", by<-by(dat, dat$trans_id, as.list)))

dat1 <- dat[1:100,]

input <- data.frame(do.call("rbind", by<-by(dat1, dat1$trans_id, as.list)))

input <- dat[1:1000,]
input <- by(input[,2], input[,1], function(x) x)
input <- lapply(input, function(x) unique(x))

library(arules)

trans <- as(as(input, "list"), "transactions")

rules <- apriori(trans, parameter = list(supp = 0.7, conf = 0.75, target = "rules"))

s <- summary(rules)

options(width = 120)

a <- inspect(rules)

blst <- list(Tr0=input[[1]], Tr1=input[[2]])

blst

as(blst, "transactions")

a_list <- list(
      c("a","b","c"),
      c("a","b"),
      c("a","b","d"),
      c("c","e"),
      c("a","b","d","e")
      )

## set transaction names
names(a_list) <- paste("Tr",c(1:5), sep = "")

a_list

## coerce into transactions
trans <- as(a_list, "transactions")
