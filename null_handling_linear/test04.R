ans.path_ = "/Users/qianh1/workspace/madlib_testsuite/tests/marginal_logregr/expected_output"
method.name_ = "test_marginal_logregr_patients_wi.sql"
port_ = "14526"
dbname_ = "madlib"
schema_testing = "madlibtestdata"

suppressMessages(library(PivotalR))

conid <- suppressMessages(db.connect(port = as.integer(port_), dbname = dbname_))


# Figure out where to put the answer files.
tincrepo <- Sys.getenv("TINCREPOHOME")
source(paste(tincrepo, "/madlib/src/r_utils/utils.R", sep = ""))
fn <- gsub("\\.sql", "", method.name_)

get.data <- function(dataset) {
    dat <- db.data.frame(paste0(schema_testing, ".", dataset), verbose = FALSE)
    lookat(dat, "all")
}

get.result.name <- function() {
    rst <- paste(ans.path_, "/", fn, ".ans", sep = "")
    system(paste("rm -f", rst))
    rst
}


## ------------------------------------------------------------------------
## Generate R results for validation
##
## The parameter values are fed from TINC
##
## Put all the results into one file
##
## This is a quite general example, wihout grouping
## ------------------------------------------------------------------------

dataset = "patients_wi"

dat <- get.data(dataset)
ans.file <- get.result.name()

## ------------------------------------------------------------------------
suppressMessages(library(lmtest))
suppressMessages(library(erer))
suppressMessages(library(car))

## Other parameters
target <- "y"                  # dependent variable
predictors <- " ~ . -1"          # fitting formula

## Actual computation part
fit <- glm(formula(paste(target, predictors)), family=binomial, x=TRUE, data = dat)
mfalse <- maBina(fit, digits = 3, x.mean=FALSE)
result <- mfalse$out
l <- dim(result)[1]

con <- file(ans.file, "w")
print(result[1:l,1])
[1] -0.97066539 -0.25036259  0.01815877
output.vec(result[1:l,1], con)    # marginal_effects
output.vec(result[1:l,2], con)    # std err
output.vec(result[1:l,3], con)    # t value
output.vec(result[1:l,4], con)    # p value
close(con)

