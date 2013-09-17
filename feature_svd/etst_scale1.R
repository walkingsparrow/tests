library(PivotalR)

dims <- array(c(10000, 100,
                10000, 200,
                10000, 400,
                10000, 800,
                10000, 1600,
                10000, 3200,
                10000, 6400,
                20000, 6400,
                40000, 6400,
                80000, 6400,
                160000, 6400), dim = c(2, 11))

db.connect(port = 5432, dbname = "madlib_test")

output.vec <- function(vec, con)
{
    l <- length(vec)
    for (k in 1:l) {
        if (is.null(vec[k]) || is.infinite(vec[k]) || is.na(vec[k]))
            cat("Null", file = con)
        else
            cat(vec[k], file = con)
        if (k != l)
            cat(", ", file = con)
    }
}

perf <- function (n) {
    con <- file("result.txt", "w")
    
    for (i in 1:n) {
        args <- dims[,i]
        dim_x <- as.integer(args[1])
        dim_y <- as.integer(args[2])
        k <- min(args[1], args[2])
    
        m <- matrix(rexp(dim_x * k, .1), dim_x)
        u <- qr.Q(qr(m))
        
        n <- matrix(rexp(dim_y * k, .1), dim_y)
        v <- qr.Q(qr(n))
        
        s <- diag(sort(rexp(k, .1), decreasing = TRUE), k, k)
        
        x <- u %*% s %*% t(v)
    
        t <- system.time(svd(x))
    
        cat(dim_x, " ", dim_y, " ", k, "\n", file = con)
        cat("R: ", as.numeric(t[3]), file = con)
        cat("\n", file = con)
    
        ## ------------------------------------------------
    
        tbl.name <- paste0("new_scale_", dim_x, "_", dim_y)
        file.name <- paste0(tbl.name, ".csv")
    
        con1 <- file(file.name, "w")
        for (i in 1:dim_x){
            cat(i - 1, "\t{", file = con1)
            output.vec(x[i,], con1)
            cat("}\n", file = con1)
        }
        close(con1)
    
        fpath <- file.path(getwd(), file.name)

        PivotalR:::.db.getQuery(paste("drop table if exists", tbl.name))
        PivotalR:::.db.getQuery(paste("create table", tbl.name, "(row_id integer, row_vec double precision[])"))
        PivotalR:::.db.getQuery(paste0("copy ", tbl.name, " from '", fpath, "'"))
        
        ## ------------------------------------------------
    
        k.use <- if (k < 5000) k else 5000
    
        PivotalR:::.db.getQuery("drop table if exists svd_u")
        PivotalR:::.db.getQuery("drop table if exists svd_v")
        PivotalR:::.db.getQuery("drop table if exists svd_s")
        PivotalR:::.db.getQuery("drop table if exists svd_sum")
        PivotalR:::.db.getQuery(paste0("select madlib.svd('", tbl.name, "', 'svd', 'row_id', ",
                                    k.use, ", 'svd_sum')"))
        res <- PivotalR:::.db.getQuery("select * from svd_sum")
    
        cat("MADlib: ", res$exec_time, " ", res$iter, " ", res$recon_error, "\n\n", file = con)    
    }
    
    close(con)
}
