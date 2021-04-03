
if (!require(plyr)) install.packages('plyr')
library(plyr)

args<-commandArgs(TRUE)
fileDir <- args[1]
filenames <- list.files(fileDir, pattern = '.csv')
dataset <- ldply(filenames, read.csv, header=TRUE)
dataset <- dataset[!apply(is.na(dataset) | dataset == "", 1, all),]

write.csv(dataset, file="Combined_CSV.csv", na="", row.names = FALSE)