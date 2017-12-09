 library(kimisc) # for thisfile() to determine the path of the currently running script
# library(testthat)
library(RUnit)
 
# set working directory to roor dir
this.file <- normalizePath(thisfile())
setwd(file.path(dirname(this.file), '..'))

source("lib/helpers.R")
source("lib/preprocess.R")

# testthat cannot be invoked from the command line
# test_dir("tests") # get "Variable context not set"

test.suite <- defineTestSuite("example",
                              dirs = file.path("tests"),
                              testFileRegexp = '^\\d+\\.R')

test.result <- runTestSuite(test.suite)
printTextProtocol(test.result)
