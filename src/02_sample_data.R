#!/usr/bin/env Rscript

library(logging)
library(kimisc) # for thisfile() to determine the path of the currently running script

# config logging
basicConfig()

# set working directory to roor dir
this.file <- normalizePath(thisfile())
setwd(file.path(dirname(this.file), '..'))
loginfo(sprintf("Set working directory to %s", getwd()))

# read configuration, e.g. locale, data dirs and remote/local file names 
loginfo("Reading configuration")
library(yaml)
config <- yaml.load_file("config.yml")

locale <- config$locale

sources <- strsplit(config$data$source,",")
raw_data_dir <- file.path(config$data$dir, config$data$raw$dir)

sample_perc <- config$data$sample
stopifnot(sample_perc > 0 & sample_perc <= 100)
loginfo(sprintf("Will sample %d perc of data", sample_perc))
        
sampled_txt <- c()
set.seed(config$seed)

for (source in c("blogs", "news", "twitter")) {
  loginfo(sprintf("Sampling %s source", source))
  
  source_fname <-file.path(raw_data_dir, paste(locale, '.', source, '.rds', sep = ""))
  loginfo(sprintf("Reading file %s", source_fname))
  txt <- readRDS(source_fname)
  nlines <- length(txt)
  loginfo(sprintf("Source %s text has %d lines", source, nlines))
  
  nslines <- ceiling(nlines * sample_perc / 100)
  loginfo(sprintf("Sampling %d lines", nslines))
  source_sampled_txt <- txt[sample(nlines, nslines)]
  stopifnot(length(source_sampled_txt) == nslines)
  
  source_sample_fname = file.path(raw_data_dir, 
                                  paste(locale, '.', source, '.sample.', sample_perc, '.rds', sep = ""))
  loginfo(sprintf("Saving %s sampled data to file %s", source, source_sample_fname))
  saveRDS(object = source_sampled_txt, file = source_sample_fname)
  sampled_txt <- c(sampled_txt, source_sampled_txt)
}

sample_fname <-file.path(raw_data_dir, paste(locale, '.sample.', sample_perc, '.rds', sep = "")) 
loginfo("Saving sampled data from all sources to file %s", sample_fname)
saveRDS(object = sampled_txt, file = sample_fname)
loginfo("Done")