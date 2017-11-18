#!/usr/bin/env Rscript
#
# sub-sample the data
#
# To build models you don't need to load in and use all of the data. 
# Often relatively few randomly selected rows or chunks need to be included 
# to get an accurate approximation to results that would be obtained using all 
# the data.
# This is script to create a separate sub-sample dataset by reading in a random 
# subset of the original data and writing it out to a separate file. That way, we
# store the sample and not have to recreate it every time.

# set working directory to roor dir
library(kimisc) # for thisfile() to determine the path of the currently running script
this.file <- try(system(paste("realpath", thisfile(), sep = " "), intern = TRUE))
setwd(file.path(dirname(this.file), '..'))

# access file sampling and other util functions
source('lib/helpers.R')

# argument reading
library(optparse)

# args = commandArgs(trailingOnly = TRUE)
# if (length(args)==0) {
#   stop("At least one argument must be supplied (input file).n", call. = FALSE)
# } else if (length(args)==1) {
#   # default output file
#   args[2] = "out.txt"
# }

option_list = 
  list(make_option(c("-l", "--language"), type="character", default="en", help="dataset language (de|en|fi|ru) [default = %default]", metavar="character"),
       make_option(c("-t", "--type"), type="character", default="all", help="dataset type (blogs|news|twitter|all) [default = %default]", metavar="character"),
       make_option(c("-o", "--out"), type="character", default="out.txt", help="output file name [default= %default]", metavar="character"))

opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);
if(!opt$language %in% c("de","en","fi","ru")) {
  print_help(opt_parser)
  stop("Language must be either de|en|fi|ru", call.=FALSE);
}

if(!opt$type %in% c("blogs","news","twitter","all")) {
  print_help(opt_parser)
  stop("Dataset type must be either blogs|news|twitter", call.=FALSE);
}