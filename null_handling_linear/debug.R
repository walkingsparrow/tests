ans.path_ = "/Users/qianh1/workspace/madlib_testsuite/tests/clustered_logregr/expected_output"
method.name_ = "test_clustered_errors_logregr_output_10.sql"
port_ = "14526"
dbname_ = "madlib"
schema_testing = "madlibtestdata"

suppressMessages(library(PivotalR))

conid <- suppressMessages(db.connect(port = as.integer(port_), dbname = dbname_))
## Created a connection to database with ID 1 

# Figure out where to put the answer files.
tincrepo <- Sys.getenv("TINCREPOHOME")
source(paste(tincrepo, "/madlib/src/r_utils/utils.R", sep = ""))
fn <- gsub("\\.sql", "", method.name_)

get.data <- function(dataset) {
    dat <- db.data.frame(paste0(schema_testing, ".", dataset), verbose = FALSE)
    lookat(dat, "all")
}

get.result.name <- function() paste(ans.path_, "/", fn, ".ans", sep = "")


## ------------------------------------------------------------------------
## Generate R results for verification of Clustered standard errors
##
## Put results into separated files
## ------------------------------------------------------------------------

dataset = "lin_auto_mpg"
cluster = "cl1, cl2"
cl = "cl2"

dataset <- paste0(as.character(dataset), "_wi_", cl)
dat <- get.data(dataset)
if ('x' %in% names(dat)) {
    i <- which(names(dat) == "x")
    dat <- cbind(dat[,-i], arraydb.to.arrayr(dat[,i],"double"))
}
result.file <- get.result.name()

target <- "y"                  # dependent variable
if (cl == "cl1") {
    predictors <- " ~ . - cl"          # fitting formula
} else {
    predictors <- " ~ . - cl1_cl2"
}

cluster <- gsub(" ", "", strsplit(cluster, ",")[[1]])

suppressMessages(library(sandwich))
suppressMessages(library(lmtest))

## ------------------------------------------------------------------------
if (cl == "cl2") {
    dn <- setdiff(names(dat), c("cl1", "cl2"))
    dat <- as.data.frame(cbind(dat[,dn], as.factor(paste(dat$cl1, dat$cl2))))
    colnames(dat) <- c(dn, 'cl1_cl2')
    cluster <- "cl1_cl2"
}

for (col in names(dat)) if (col != cluster) dat <- dat[!is.na(dat[[col]]),]

m <- mean(dat$y, na.rm=TRUE)
fit <- glm(formula(paste("y <", m, predictors)), data = dat, family = binomial,
control = list(maxit = 1000, epsilon = 1e-8), na.action=na.omit)

clx <- function(fm, dfcw = 1, cluster)
{
    M <- length(unique(cluster))
    cl <- cluster
    N <- length(cl)
    dfc <- (M/(M-1))*((N-1)/(N-fm$rank))
    u <- apply(estfun(fm), 2,
               function(x) tapply(x, cl, sum))
    vcovCL <- dfc * sandwich(fm, meat = crossprod(u)/N) * dfcw
    coeftest(fm, vcovCL)
}

print(dim(dat[,cluster]))
NULL

res <- clx(fit, cluster = fit$model[,cluster])

con <- file(result.file, "w")
display_dataset <- as.character(dataset)
cat(paste(display_dataset, "\n", sep = ""), file = con)
l <- dim(res)[1]
output.vec(res[1:l,1], con)    # coef
output.vec(res[1:l,2], con)    # std err
output.vec(res[1:l,3], con)    # t value
output.vec(res[1:l,4], con)    # p value
cat("\n", file = con)
close(con)



