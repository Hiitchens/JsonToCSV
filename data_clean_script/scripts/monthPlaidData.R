# Author: James Behnke
# Purpose: Transform raw WTFast monthly Plaid data into cleaned data for further processing. This script primarily cleans
# Usage: This script runs part of the GPerfCleaner bash script which automatically runs this R script on Plaid data when -pd parameters are given
# License: MIT License

# Copyright (c) [2021] [James Behnke]

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# Begin

args<-commandArgs(TRUE)
file <- args[1]
fileExportLoc <- (args[2])


toDateCols <- c('game_session_start',
                'game_session_stop',
                'load_time',
                'stats_start',
                'stats_stop')

'%ni%' <- Negate('%in%')


df <- data.frame(read.csv(file))

#column names were given prepended strings as part of the JSON conversion
colnames(df) <- gsub("_source.", "", colnames(df))
colnames(df) <- gsub("X", "", colnames(df))

#convert any UNIX timestamps that are stored as Strings to numbers
#For each file, change the appropriate character columns to equivalent numeric columns
df[,c(toDateCols)] <- lapply((df[,c(toDateCols)]), as.numeric)

#convert UNIX timestamp (including milliseconds to Date eg: 1596259808483 to 2020-08-01 05:30:08 UTC)
for (i in toDateCols) {
  df[,c(i)] <- as.POSIXct(((df[,(c(i))])/1000),tz="UTC", origin="1970-01-01")
}

df <- df[df$'_index' %ni% "",]

#write a csv file of the same name ending in CSV
write.csv(df, file=fileExportLoc, na="", row.names = FALSE)