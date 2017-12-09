# helper functions for processing, i.e cleaning, the data before tokenisation

library(dplyr)

# special markers to signal the presence of numbers, sentence marks, emails, URLs, twitter tags/names
# using underscores since we're using the tokenizers package which strips most of the non-alphanum
# characters during tokenisation except underscores
markers <- list(number = '_num_', email = '_email_', url = '_url_', hashtag = '_hashtag_', twname = '_twname_', profane = '_profane_', eos = '_eos_')

# TODO
# stemming and stopwords
preprocess <- function(txt, stem = F, stopwords = F) {
   txt %>% 
     process_numbers()     %>% 
     process_emails()      %>% 
     process_urls()        %>% 
     process_twitter()     %>% 
     process_slang()       %>%      # TODO
     process_profanity()   %>%  # TODO
     process_punctuation()    # TODO
}

process_numbers <- function(txt) {
  gsub("(^\\s*?|[.!?]+\\s*?|\\s)[0-9]+([,\\.]?[0-9]+)?\\s", " _num_ ", txt)
}

process_emails <- function(txt) {
  # the simplest regex possible, match also invalid email addresses
  gsub("\\w+[-+.]*\\w+@.+\\.\\w+", "_email_", txt)
  # gsub("\\w*@\\w*\\.\\w*", " _email_ ", txt, perl = TRUE)
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
  
  gsub("(\\#[[:alnum:]]+)", "_hashtag_", txt)         %>% # hash tags
    { gsub("\\@\\w*[[:alnum]]+\\w*", "_twname_", .) } %>% # twitter names
    { gsub("\\b(rt|RT)\\b", " ", .) }                     # remove retweets
}

# TODO
process_slang <- function(txt) {
  gsub("\\s[b]\\s", " be ", txt)            %>%
     { gsub("\\s[n]\\s", " and ", .) }      %>%
     { gsub("\\s[u]\\s", " you ", .) }      %>%
     { gsub("\\s[t]\\s", " too ", .) }      %>%
     { gsub("\\sb4\\s",  " before ", .) }
}

# TODO
process_profanity <- function() {
  txt  
}

# TODO
process_punctuation <- function(txt) {
  gsub("[.!?]+", " _eos_ ", txt) # replace end of sentence punctuation with special marker
}