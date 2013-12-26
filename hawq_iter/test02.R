x <- array(rnorm(1000000 * 20), dim = c(1000000, 20))
y <- sample(0:4, 1000000, replace = TRUE)

save(x, y, file="test_mlog.rda")

load("test_mlog.rda")

library(PivotalR)
db.connect(port = 18526, dbname = "madlib")

delete("perf_mlog")
dat <- as.db.data.frame(as.data.frame(cbind(x, y)), "perf_mlog")

## select madlib.mlogregr_train('perf_mlog', 'mlog', 'y::integer', 'array[1,"V1","V2","V3","V4","V5","V6","V7","V8","V9","V10","V11","V12","V13","V14","V15","V16","V17","V18","V19","V20"]', 0, 'max_iter=10, precision=0');

CREATE TYPE madlib.__logregr_result AS (
    coef            DOUBLE PRECISION[],
    log_likelihood  DOUBLE PRECISION,
    std_err         DOUBLE PRECISION[],
    z_stats         DOUBLE PRECISION[],
    p_values        DOUBLE PRECISION[],
    odds_ratios     DOUBLE PRECISION[],
    condition_no    DOUBLE PRECISION,
    status          INTEGER,
    num_processed   BIGINT,
    num_iterations  INTEGER
);
