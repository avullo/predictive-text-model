# helper functions for processing, i.e cleaning, the data before tokenisation

library(dplyr)

# special markers to signal the presence of numbers, sentence marks, emails, URLs, twitter tags/names
# using underscores since we're using the tokenizers package which strips most of the non-alphanum
# characters during tokenisation except underscores
markers <- list(number = '_num_', email = '_email_', url = '_url_', hashtag = '_hashtag_', twname = '_twname_', profane = '_strong_', eos = '_eos_')

# list of offensive/profane words
strong_words <- function() {
  fileUrl <- "https://raw.githubusercontent.com/LDNOOBW/List-of-Dirty-Naughty-Obscene-and-Otherwise-Bad-Words/master/en"
  badwords <- readLines(fileUrl)
  badwords[-length(badwords)]  # last element read is empty string
}

strongwords <- strong_words()
  
# TODO
# stemming and stopwords
preprocess <- function(txt, stem = F, stopwords = F) {
  process_numbers(txt)      %>% # TODO
     process_emails()       %>% # TODO
     process_urls()         %>% # TODO
     process_twitter()      %>% # TODO
     process_slang()        %>% 
     process_profanity()    %>% # TODO
     process_contractions() %>% # TODO
     process_punctuation()      # TEST
}

process_numbers <- function(txt) {
  gsub("\\s[0-9]+([,\\.]?[0-9]+)?\\s", " _num_ ", txt)
}

process_emails <- function(txt) {
  # the simplest regex possible, match also invalid email addresses
  gsub("\\s\\w+[-+\\.]*\\[?\\w+@.+\\.\\w+\\]?", " _email_", txt)
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

# Process some common Internet shorthand
# TODO: use complete netlingo dictionary of acronyms and shorthand
process_slang <- function(txt) {
  gsub("\\s2b\\s", " to be ", txt)             %>%
    { gsub("\\s2b@\\s", " to be at ", .) }     %>%
    { gsub("\\s2d4\\s", " to die for ", .) }   %>%
    { gsub("\\s2day\\s", " today ", .) }       %>%
    { gsub("\\s2moro\\s", " tomorrow ", .) }   %>%
    { gsub("\\s2nite\\s", " tonight ", .) }    %>%
    { gsub("\\s4ever\\s", " forever ", .) }    %>%
    { gsub("\\s@\\s", " at ", .) }             %>%
    { gsub("\\sabt\\s", " about ", .) }        %>%
    { gsub("\\sb\\s", " be ", .) }             %>%
    { gsub("\\sb4\\s", " before ", .) }        %>%
    { gsub("\\sbc\\s", " because ", .) }       %>%
    { gsub("\\sc\\s", " see ", .) }            %>%
    { gsub("\\scu\\s", " see you ", .) }       %>%
    { gsub("\\sd8\\s", " date ", .) }          %>%
    { gsub("\\sda\\s", " there ", .) }         %>%
    { gsub("\\severy1\\s", " everyone ", .) }  %>%
    { gsub("\\sgn8\\s", " good night ", .) }   %>%
    { gsub("\\sl8r\\s", " later ", .) }        %>%
    { gsub("\\sn\\s", " and ", .) }            %>%
    { gsub("\\sno1\\s", " no one ", .) }       %>%
    { gsub("\\sr\\s", " are ", .) }            %>%
    { gsub("\\sstr8\\s", " straight ", .) }    %>%
    { gsub("\\su\\s", " you ", .) }            %>%
    { gsub("\\st\\s", " too ", .) }            %>%
    { gsub("\\sy\\s", " yes ", .) }            %>%
    { gsub("\\sya\\s", " you ", .) }
}

# TODO
process_profanity <- function(txt) {
  txt 
}

# TODO
process_contractions <- function(txt) {
  txt
}

# TEST
process_punctuation <- function(txt) {
  gsub("[.!?]+", " _eos_ ", txt) # replace end of sentence punctuation with special marker
}
