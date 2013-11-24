
rm(list=ls())

graphics.off()

require(glmnet)
require(pROC)


# Set locations of directories and data files
workDir <- 'W:\\GRMOS\\PaulBranoff\\Work\\MachineLearningDataMining\\VariableSelection\\RegularizedLogistic\\SAHeartDisease_PivotalR'


# Load the data to be used
SAheart <- read.csv(file=paste0(workDir,"\\SAHeart_RawData.csv"), head=TRUE, sep=",")
SAheart$adiposity <- NULL
SAheart$typea <- NULL

# Specify dependent and independent variables
y <- SAheart$chd
X <- SAheart;
X$chd <- NULL

# Determine Lasso paths
X <- data.matrix(X)
y <- data.matrix(y)
paths_EN = glmnet(scale(X), y, family=c("binomial"), alpha=1, standardize=FALSE, intercept=TRUE)
plot(paths_EN)

# Find optimal lambda with cross-validation
cvfit = cv.glmnet(scale(X), y, family=c("binomial"), nfolds=5, alpha=1, type.measure="mse", standardize=FALSE)
betas <- coef(cvfit, s=cvfit$lambda.1se)
plot(cvfit)


# # Open connection to PivotalR
# library(PivotalR)
# db.connect(host = "19.86.118.69", user = "pbranoff", password = "pivotal", dbname = "ford")
# 
# SAheart_db_ptr <- as.db.data.frame(SAheart, "SAheart_db")

