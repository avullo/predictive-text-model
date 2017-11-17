# Data Science Capstone Project
#
# Utility functions

# get the number of lines in a file
numberOfLines <- function(fname) {
  if(!file.exists(fname)) {
    stop(paste("Cannot read file ", fname, sep = " "))
  }
  as.integer(strsplit(try(system(paste("wc", fname, sep = " "), intern = TRUE)), " +")[[1]][2])
}

# count empty lines in a file
numberOfEmptyLines <- function(fname) {
  if(!file.exists(fname)) {
    stop(paste("Cannot read file ", fname, sep = " "))
  }
  as.integer(strsplit(try(system(paste("grep -cP '^$'", fname, sep = " "), intern = TRUE)), " +")[[1]][1])
}

# sample a certain fraction of the lines of a file, and write them to an output file
#
# adapted from https://stat.ethz.ch/pipermail/r-help/2007-February/124812.html
#
# The basic premise with this approach below, is that you are in effect
# creating a sequential file cache in an R object. Reading large chunks of
# the source file into the cache. Then randomly selecting rows within the
# cache and then writing out the selected rows.
# Thus, if you can read 100,000 rows at once, you would have 9 reads of
# the source file, and 9 writes of the target file.
# The key thing here is to ensure that the offsets within the cache and
# the corresponding random row values are properly set.
#
# WARN
#   works with files with no or a very few empty lines 
#
# TODO
# Add profanity filtering, list from https://github.com/LDNOOBW/List-of-Dirty-Naughty-Obscene-and-Otherwise-Bad-Words
# but must detect language first, or specify language as parameter
#
# NOTE
# Translate cyrillic alphabet to latin, package string1
# stri_trans_general('ДРАГИ', 'latin')
#
sampleFile <- function(ifname, ofname, perc = 1, append = TRUE, seed = 1234) {
  nlines <- numberOfLines(ifname)
  
  # generate the random row values
  set.seed(seed)
  sel <- sample(1:nlines, nlines * perc / 100)
  
  # set up a sequence for the cache chunks,
  # chunk size is 9th of number of lines
  chunk_size <- floor(nlines/9)
  cuts <- seq(0, nlines, chunk_size)
  
  # loop over the length of cuts, less 1
  for ( i in seq(along = cuts[-1]) ) {
    # get a chunk_size row chunk, skipping rows
    # as appropriate for each subsequent chunk
    # might get less then chunk_size lines, if there are empty lines
    chunk <- scan(ifname, what = character(), sep = "\n", skip = cuts[i], nlines = chunk_size)
    
    # set up a row sequence for the current chunk
    rows <- (cuts[i]+1):(cuts[i+1])
    
    # are any of the the random values in the current chunk?
    # if so, get them and write them out
    chunk.sel <- sel[which(sel %in% rows)]
    if(length(chunk.sel) > 0) {
      chunk_index <- sel - cuts[i]
      # take into account chunk might have less than chunk_size lines
      write.rows <- chunk[chunk_index[chunk_index>0 & chunk_index <= chunk_size]]
      # write.rows <- chunk[!is.na(chunk[sel-cuts[i]])]
      write(write.rows, ofname, append = append, sep = "\n")
    }
  }
}

# sample a given percentage of lines from a number of files in a directory 
# and write them out to a file
sampleFiles <- function(dir = './', ofname, perc = 1, append = TRUE, seed = 1234) {
  # files <- lapply(list.files(dir), function(f) paste(dir, f, sep = "/"))
  files <- list.files(dir)
  lapply(files, function(fname) sampleFile(paste(dir, fname, sep = "/"), ofname, perc = perc, append = append, seed = seed))
}

lengthLongestLine <- function(fname, chunk_size = 1000) {
  con <- file(fname, 'r')
  
  max <- -1
  while(TRUE) {
    lines <- readLines(con, n = chunk_size)
    if(length(lines) == 0) { 
      break 
    }
    max_chunk <- max(unlist(lapply(lines, nchar)))
    if(max < max_chunk) { max = max_chunk }
  }
  close(con)
  max
}