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

# raw data file names
locale <- config$locale

# create data directories, if necessary
raw_data_dir <- file.path(config$data$dir, config$data$raw$dir)
if(!file.exists(raw_data_dir)) {
  dir.create(raw_data_dir, showWarnings = FALSE, recursive = TRUE)
  loginfo(sprintf("Created raw data directory %s", raw_data_dir))
} else { loginfo("Raw data directory exist")}

# download and extract archived data, if it doesn't exist
raw_files <- file.path(raw_data_dir, paste(locale, ".", c("blogs", "news", "twitter"), ".txt", sep=""))
local_file <- file.path(raw_data_dir, config$data$raw$local)

if(!all(unlist(lapply(raw_files, file.exists)))) {
  loginfo("Some source data file is not present, recreating")
  if(!file.exists(local_file)) {
    loginfo(sprintf("Downloading remote file %s", config$data$raw$url))
    download.file(url = config$data$raw$url, destfile = local_file, method = "curl")
  }
  loginfo(sprintf("Unzipping file %s", local_file))
  unzip(local_file)
  
  loginfo(sprintf("Moving source files to destination (%s)", raw_data_dir))
  for (source_file in Sys.glob(file.path("final", locale, "*.txt"))) {
    stopifnot(file.rename(from = source_file, to = file.path(raw_data_dir, basename(source_file))))
  }
  loginfo("Removing remaining unzipped content")
  unlink(c("final"), recursive = TRUE, force = TRUE)
} else { loginfo("Raw source data files exist")}

# read files from all three sources and serialise content to speed up loading in other tasks
object_files <- file.path(raw_data_dir, paste(locale, ".", c("blogs", "news", "twitter"), ".rds", sep=""))
i <- 1
for (source in c("blogs", "news", "twitter")) {
  if(file.exists(object_files[i])) {
    loginfo(sprintf("Target object file %s exists. Skip", object_files[i]))
    next
  }
  
  loginfo(sprintf("Reading file %s", raw_files[i]))
  content <- readLines(raw_files[i], skipNul = TRUE, encoding="UTF-8")
  loginfo(sprintf("Serialising to file %s", object_files[i]))
  saveRDS(object = content, file = object_files[i])
  i <- i + 1
}