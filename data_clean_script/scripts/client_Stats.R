# Author: James Behnke
# Purpose: Transform raw WTFast monthly Client Stats data into cleaned data for further processing. This script primarily cleans
# Usage: This script runs as part of the GPerfCleaner bash script which automatically runs this R script on monthly client stats data when -cs parameter is given.
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
setwd(args[2])
fileExportLoc <- (args[2])

'%ni%' <- Negate('%in%')

colsToFix <- c('hits.',
               '_source.',
               'internet.',
               'wtfast.',
               'trace_data.',
               'hops.')
  
  df <- read.csv(file)
  for (title in colsToFix) {
    colnames(df) <- gsub(title, "", colnames(df))
  }
  colnames(df) <- gsub(".timestamp", "timestamp", colnames(df))
  #column names were given duplicates such as ("hits__hits___x")
  #this removes redundant columns 1-7 such as "took, timed_out etc"
  notNull <- df[df$'_index' %ni% "",] #this is a very important line, it checks the first column to see if it contains relevant info, if it doesnt, its removed
  
  write.csv(notNull[-c(1:7)], file =fileExportLoc, na="", row.names = FALSE)
  