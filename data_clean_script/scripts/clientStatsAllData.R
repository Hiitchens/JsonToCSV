args<-commandArgs(TRUE)
file <- args[1]

fileExportLoc <- (args[2])

df <- read.csv(file)
#column names were given duplicates such as ("hits__hits___x")
colnames(df) <- gsub("hits.", "", colnames(df))
colnames(df) <- gsub("_source.", "", colnames(df))
colnames(df) <- gsub("internet.", "", colnames(df))
colnames(df) <- gsub("wtfast.", "", colnames(df))
colnames(df) <- gsub("trace_data.", "", colnames(df))
colnames(df) <- gsub(".timestamp", "timestamp", colnames(df))
colnames(df) <- gsub("hops.", "", colnames(df))
#this removes redundant columns 1-7 such as "took, timed_out etc"
write.csv(df[-c(1:7)], file = fileExportLoc, na="", row.names = FALSE)