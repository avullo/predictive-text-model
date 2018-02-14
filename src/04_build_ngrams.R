#!/usr/bin/env Rscript

library(logging)
library(kimisc) # for thisfile() to determine the path of the currently running script

# config logging
basicConfig()

# set working directory to roor dir
this.file <- normalizePath(thisfile())
setwd(file.path(dirname(this.file), '..'))
loginfo(sprintf("Set working directory to %s", getwd()))

source("lib/helpers.R")
source("lib/ngram.R")

loginfo("Reading configuration")
library(yaml)
config <- yaml.load_file("config.yml")

locale <- config$locale

sample_perc <- config$data$sample
assert(sample_perc > 0 & sample_perc <= 100, "Data sample perc must be a number > 0 and <= 100")
loginfo(sprintf("Will use %s %d perc sample data", locale, sample_perc))

# create model data dir if not exist
model_data_dir <- file.path(config$model$dir, config$model$data$dir)
if(!file.exists(model_data_dir)) {
  loginfo(sprintf("Model data dir %s does not exist, creating", model_data_dir))
  dir.create(model_data_dir, showWarnings = FALSE, recursive = TRUE)
}

#
# check existence of processed (sampled) data 
# TODO 
# at the moment, processed file a symlink to the unprocessed one, waiting
# for a clear definition of the cleaning steps.
processed_data_dir <- file.path(config$data$dir, config$data$process$dir)
processed_data_fname <- file.path(processed_data_dir, 
                            paste(locale, '.sample.', sample_perc, '.rds', sep = ""))
assert(file.exists(processed_data_fname), 
       sprintf("processed sample data file %s does not exist", processed_data_fname))

# TODO
# split processed data into training/testing/validation set

#
# build ngrams (i.e. (token,count)) with size 1 (words), 2, 3, 4
# TODO: when training/testing/validation split is available, corpus file will be training set one
#
corpus_file <- processed_data_fname
corpus <- data.frame(text = readRDS(corpus_file), stringsAsFactors = FALSE)
for (size in seq(1,4)) {
  loginfo(sprintf("Building ngrams (size = %d)", size))
  
  # tokenize into ngrams, attach token counts
  ngrams <- ngram_table(corpus, size)
  ngram_fname <- file.path(model_data_dir, paste(locale, '.sample.', sample_perc, '.ngram.', size, '.rds', sep = ""))
  saveRDS(object = ngrams, file = ngram_fname)
}

loginfo("Done")