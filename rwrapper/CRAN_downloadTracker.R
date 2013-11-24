## ======================================================================
## Step 1: Download all log files
## ======================================================================

root <- "/Users/qianh1/workspace/tests/rwrapper/"

## Here's an easy way to get all the URLs in R
start <- as.Date('2013-06-03')
today <- as.Date('2013-10-03')
 
all_days <- seq(start, today, by = 'day')
 
year <- as.POSIXlt(all_days)$year + 1900
urls <- paste0('http://cran-logs.rstudio.com/', year, '/', all_days, '.csv.gz')
 
## only download the files you don't have:
missing_days <- setdiff(as.character(all_days), tools::file_path_sans_ext(dir(paste0(root, "CRANlogs")), TRUE))
 
dir.create("CRANlogs")
for (i in 1:length(missing_days)) {
  print(paste0(i, "/", length(missing_days)))
  download.file(urls[i], paste0(root, 'CRANlogs/', missing_days[i], '.csv.gz'))
}

## ======================================================================
## Step 2: Load single data files into one big data.table
## ======================================================================
 
file_list <- list.files(paste0(root, "CRANlogs"), full.names=TRUE)
 
logs <- list()
for (file in file_list) {
	cat(paste("Reading", file, "...\n"))
	logs[[file]] <- read.table(file, header = TRUE, sep = ",", quote = "\"",
         dec = ".", fill = TRUE, comment.char = "", as.is=TRUE)
}
 
## rbind together all files
library(data.table)
dat <- rbindlist(logs)
 
## add some keys and define variable types
dat[, date:=as.Date(date)]
dat[, package:=factor(package)]
dat[, country:=factor(country)]
dat[, weekday:=weekdays(date)]
dat[, week:=strftime(as.POSIXlt(date),format="%Y-%W")]
 
setkey(dat, package, date, week, country)
 
save(dat, file=paste0(root,"CRANlogs.RData"))
 
## for later analyses: load the saved data.table
load(paste0(root, "CRANlogs.RData"))

## ======================================================================
## Step 3: Analyze it!
## ======================================================================
 
## library(ggplot2)
## library(plyr)
 
## str(dat)
 
## ## Overall downloads of packages
## d1 <- dat[, length(week), by=package]
## d1 <- d1[order(V1), ]
## d1[package=="TripleR", ]
## d1[package=="psych", ]
## d1[package=="PivotalR", ]

## agg1 <- dat[J(c("PivotalR")), length(unique(ip_id)), by=c("week", "package")]
 
## ggplot(agg1, aes(x=week, y=V1, color=package, group=package)) + geom_line(size=1.5) + ylab("Downloads") + theme_bw() + theme(axis.text.x  = element_text(angle=90, size=8, vjust=0.5))

## pdf("PivotalR_download.pdf", width=12, height=12)
## ggplot(agg1, aes(x=week, y=V1, color=package, group=package)) + geom_line(size=2) + ylab("Downloads") + theme_bw() + theme(axis.text.x  = element_text(angle=90, size=16, vjust=0.5), axis.title = element_text(size=16))
## dev.off()

## ## plot 1: Compare downloads of selected packages on a weekly basis
## agg1 <- dat[J(c("TripleR", "RSA")), length(unique(ip_id)), by=c("week", "package")]
 
## ggplot(agg1, aes(x=week, y=V1, color=package, group=package)) + geom_line() + ylab("Downloads") + theme_bw() + theme(axis.text.x  = element_text(angle=90, size=8, vjust=0.5))
 
 
## agg1 <- dat[J(c("psych", "TripleR", "RSA")), length(unique(ip_id)), by=c("week", "package")]
 
## ggplot(agg1, aes(x=week, y=V1, color=package, group=package)) + geom_line() + ylab("Downloads") + theme_bw() + theme(axis.text.x  = element_text(angle=90, size=8, vjust=0.5))
 
## ## ----------------------------------------------------------------------

## if(packageVersion("installr") %in% c("0.8","0.9","0.9.2")) install.packages('installr') #If you have one of the older installr versions, install the latest one....
 
require(installr)
 
# The first two functions might take a good deal of time to run (depending on the date range)
RStudio_CRAN_data_folder <- download_RStudio_CRAN_data(START = '2013-06-03', END = '2013-11-19')

my_RStudio_CRAN_data <- read_RStudio_CRAN_data(RStudio_CRAN_data_folder)
 
##  # barplots: (more functions can easily be added in the future)
## barplot_package_users_per_day("plyr", my_RStudio_CRAN_data)
## barplot_package_users_per_day("installr", my_RStudio_CRAN_data)

barplot_package_users_per_day("PivotalR", my_RStudio_CRAN_data)

lineplot_package_downloads(pkg_names = c("PivotalR"),
                           dataset = my_RStudio_CRAN_data,
                           by_time = "week")

dataset <- my_RStudio_CRAN_data

agg1 <- ddply(dataset[dataset$"package" %in% c("PivotalR"),], .(time= get("date"), NA), function(xx) {c(V1 = length(unique(as.vector(xx$ip_id))))})

ggplot(agg1, aes(x=time, y=V1, color=package, group=package)) + geom_line() + ylab("Downloads") + theme_bw() + theme(axis.text.x  = element_text(angle=90, size=8, vjust=0.5))

pdf("PivotalR_download_count.pdf", width = 400, height = 300)
plot(as.Date(agg1$time), agg1$V1, type='l', col='pink', lwd=2, xlab = "Day", ylab = "# of IP that downloaded PivotalR")
dev.off()
