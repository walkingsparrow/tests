library(PivotalR)

db.connect(port = 14526, dbname = "madlib")

delete("null_data", conn.id = 1)
w <- as.db.data.frame(null.data, "null_data", conn.id = 1)

dim(w)

lookat(w, 10)

z <- w$lnauto

lookat(mean(z))

content(z[is.na(z)])

z[is.na(z)] <- mean(z)

w$lnauto <- mean(z)

content(w)

names(w)

content(z)

dim(w)

madlib.lm(sf_mrtg_pct_assets ~ ., data = w)

w[is.na(w)] <- 20

content(w)

w[is.na(w)] <- mean(w$lnauto)

content(w)
