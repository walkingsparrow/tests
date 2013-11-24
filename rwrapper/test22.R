library(PivotalR)
db.connect(port = 5433, dbname = "madlib")

## setMethod (
##     "-",
##     signature(e1 = "numeric", e2 = "db.obj"),
##     function (e1, e2) {
##         if (missing(e1))
##             -1 * e2
##         else
##             PivotalR:::.compare(e2, e1, " + ", PivotalR:::.num.types,
##                                 prefix = "-",
##                                 res.type = "double precision",
##                                 res.udt = "float8")
##     },
##     valueClass = "db.Rquery")

dat <- db.data.frame("madlibtestdata.dt_abalone")

content(db.array(dat[-2]))

z <- cbind(db.array(dat[-2]), dat[,2])

attributes(z)

content(as.integer(z))

z <- db.array(dat[-2])

content(as.integer(db.array(dat[-2])))

content(1 - dat$rings)

content(-dat$rings + 2)

setGeneric("-", def = function(e) standardGeneric("-"))

setMethod("+",
          signature(e1 = "character", e2 = "ANY"),
          def = function (e1, e2) paste(e1, as.character(e2), sep = ""))

`%+%` <- function (e1, e2) paste(e1, e2, sep = "")
`%.%` <- function (e1, e2) paste(e2, collapse = e1)

"+" = function(x,y) {
    if(is.character(x) | is.character(y)) {
        return(paste(x , y, sep=""))
    } else {
        `+`(x,y)
    }
}

setGeneric("%.%", function(e1, e2) standardGeneric("%.%"))

setMethod()
