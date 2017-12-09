#!/usr/bin/env Rscript

library(logging)
library(kimisc) # for thisfile() to determine the path of the currently running script

# config logging
basicConfig()

# set working directory to roor dir
this.file <- normalizePath(thisfile())
setwd(file.path(dirname(this.file), '..'))
loginfo(sprintf("Set working directory to %s", getwd()))

source("lib/preprocess.R")

loginfo("Reading configuration")
library(yaml)
config <- yaml.load_file("config.yml")

locale <- config$locale

sample_perc <- config$data$sample
assert(sample_perc > 0 & sample_perc <= 100, "Data sample perc must be a number > 0 and <= 100")
loginfo(sprintf("Will use %s %d perc sample data", locale, sample_perc))

# check existence of sampled data 
raw_data_dir <- file.path(config$data$dir, config$data$raw$dir)
sample_data_fname <- file.path(raw_data_dir, paste(locale, '.sample.', sample_perc, '.rds', sep = ""))
assert(file.exists(sample_data_fname), 
       sprintf("sample data file %s does not exist", sample_data_fname))

# process sample data
corpus <- readRDS(sample_data_fname)
processed_corpus <- preprocess(corpus, stem = config$data$process$stem, stopwords = config$data$process$stopwords)

# create processed data dir if not exist
processed_data_dir <- file.path(config$data$dir, config$data$process$dir)
if(!file.exists(processed_data_dir)) {
  loginfo(sprintf("Processed data dir %s does not exist, creating", processed_data_dir))
  dir.create(processed_data_dir, showWarnings = FALSE, recursive = TRUE)
}

# save processed sampled data to file
processed_data_fname <- file.path(processed_data_dir, 
                                  paste(locale, '.sample.', sample_perc, '.rds', sep = ""))
saveRDS(object = processed_corpus, file = procesed_data_fname)

loginfo("Done")