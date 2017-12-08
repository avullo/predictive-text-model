# helper functions for processing, i.e cleaning, the data before tokenisation

library(dplyr)

# special markers to signal the presence of numbers, sentence marks, emails, URLs, twitter tags/names
# using underscores since we're using the tokenizers package which strips most of the non-alphanum
# characters during tokenisation except underscores
markers <- list(number = '_num_', email = '_email_', url = '_url_', hashtag = '_hashtag_', twname = '_twname_', profane = '_profane_', eos = '_eos_')

preprocess <- function(txt) {
  txt
    %>% process_numbers() 
    %>% process_emails()  
    %>% process_urls()  
    %>% process_twitter() 
    %>% process_slang()       # TODO
    %>% process_profanity()   # TODO
    %>% process_punctuation() 
}

process_numbers <- function(txt) {
  gsub("(^|\s)[0-9]+([,\\.]?[0-9]+)?", "_num_", txt)
}

process_emails <- function(txt) {
  gsub("\\w*@\\w*\\.\\w*", "_email_", txt)
}

process_urls <- function(txt) {
  gsub("\\b([a-z]{3,6}://)?([\\0-9a-z\\-]+\\.)+([a-z]{2,6})+(/[\\0-9a-z\\?\\=\\&\\-_]*)*", "_url_", txt)
}

process_twitter <- function(txt) {
  # NOTE:
  # With pipe your data are passed as a first argument to the next function, 
  # so if you want to use it somewhere else you need to wrap the next line in 
  # {} and use . as a data "marker".
  # https://stackoverflow.com/questions/39997273/r-combine-several-gsub-function-ina-pipe
  
  txt
    %>% { gsub("(\\#[[:alnum:]]+)", "_hashtag_", .) }     # hash tags
    %>% { gsub("\\@\\w*[[:alnum]]+\\w*", "_twname_", .) } # twitter names
    %>% { gsub("\\b(rt|RT)\\b", " ", .) }                 # remove retweets
}

# TODO
process_slang <- function(txt) {
  txt
}

# TODO
process_profanity <- function() {
  txt  
}

process_punctuation <- function(txt) {
  gsub("[.!?]+", " _eos_ ", txt) # replace end of sentence punctuation with special marker
}