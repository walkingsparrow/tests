
x <- 1
class(x) <- c("db.obj", "db.data.frame", "data.frame")

setClass("db.obj",
         representation(
             .name = "character", # object name
             .con.id = "numeric", # connection ID
             ## used for identify connection
             .dbname = "character", # database name
             .host = "character", # database server
             .con.pkg = "character", # R package used for connection
             ## table properties
             .col.names = "character", # column names
             .col.types = "character" # column types
             )
         )

y <- new("db.obj")

attributes(y)
attr(y, "a") <- 1

z <- 1
attr(z, "a") <- 10

setMethod("==", c("db.obj", "db.obj"), function (e1, e2) { 23 })

x <- data.frame(a = 1:4, b = 2:5)

## ------------------------------------------------------------------------

`[.data.frame` <- function (x, i, j)
{
    n <- nargs()
    print(n)
    if (missing(i)) {
        message("i is missing")
        return (23)
    }
    if (is.null(i)) {
        message("i is NULL")
        return (24)
    }
    if (missing(j)) {
        message("j is missing")
        return (25)
    }
    if (is.null(j)) {
        message("j is NULL")
        return (26)
    }
}
