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
  stri_trans_tolower(txt)  %>% # lower case 
    process_numbers()      %>% 
    process_emails()       %>%
    process_urls()         %>%
    process_twitter()      %>%
    process_slang()        %>% 
    process_profanity()    %>% # TODO
    process_contractions() %>% # TODO
    process_punctuation()      # TEST
}

process_numbers <- function(txt) {
  gsub("([0-9]+([,\\.]?[0-9]+)?)", " _num_ ", txt)
}

process_emails <- function(txt) {
  # the simplest regex possible, match also invalid email addresses
  gsub("\\w+[-+\\.]*\\[?\\w+@.+\\.\\w+\\]?", " _email_ ", txt)
}

process_urls <- function(txt) {
  gsub('(f|ht)tp\\S+\\s*'," _url_ ", txt)
}

process_twitter <- function(txt) {
  # NOTE:
  # With pipe your data are passed as a first argument to the next function, 
  # so if you want to use it somewhere else you need to wrap the next line in 
  # {} and use . as a data "marker".
  # https://stackoverflow.com/questions/39997273/r-combine-several-gsub-function-ina-pipe
  
  gsub("\\#[[:alnum:]]+", "_hashtag_", txt) %>% # hash tags
    # { gsub("(^|[[:blank:]])\\@[[:alnum:]]+[[:blank:]]", "_twitter_", .) } %>% # twitter names
    { gsub("\\b(rt|RT)\\b", " ", .) }           # remove retweets
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

# TODO: process possessive forms 
process_contractions <- function(txt) {
  # List of English contractions: https://en.wikipedia.org/wiki/Wikipedia:List_of_English_contractions
  gsub("ain't", "am not", txt) %>%
  { gsub("aren't", "are not", .) } %>% { gsub("can't", "cannot", .) } %>% { gsub("could've", "could have", .) } %>%
  { gsub("couldn't", "could not", .) } %>% { gsub("could of", "could have", .) } %>% { gsub("didn't", "did not", .) } %>% { gsub("doesn't", "does not", .) } %>%
  { gsub("don't ", "do not", .) } %>% { gsub("gonna", "going to", .) } %>% { gsub("gotta", "got to", .) } %>% { gsub("hadn't", "had not", .) } %>%
  { gsub("hasn't", "has not", .) } %>% { gsub("haven't", "have not", .) } %>% { gsub("he'd", "he would", .) } %>% { gsub("he'll", "he will", .) } %>%
  { gsub("he's", "he is", .) } %>% { gsub("how'd ", "how would", .) } %>% { gsub("how'll", "how will", .) } %>% { gsub("how's", "how has", .) } %>%
  { gsub("i'd", "i would", .) } %>% { gsub("i'll", " i will", .) } %>% { gsub("i'm", "i am", .) } %>% { gsub("i've", "i have", .) } %>%
  { gsub("isn't", "is not", .) } %>% { gsub("it'd", "it would", .) } %>% { gsub("it'll", "it will", .) } %>% { gsub("it's", "it is", .) } %>%
  { gsub("let's", "let us", .) } %>% { gsub("mayn't", "may not", .) } %>% { gsub("may've", "may have", .) } %>% { gsub("mightn't", "might not", .) } %>%
  { gsub("might've", "might have", .) } %>% { gsub("mustn't", "must not", .) } %>% { gsub("must've", "must have", .) } %>% { gsub("needn't", "need not", .) } %>%
  { gsub("o' clock", "of the clock", .) } %>% { gsub("ol'", "old", .) } %>% { gsub("oughtn't", "ought not", .) } %>% { gsub("shan't", "shall not", .) } %>%
  { gsub("she'd", "she would", .) } %>% { gsub("should've", "should have", .) } %>% { gsub("shouldn't", "should not", .) } %>% { gsub("should of", " should have", .) } %>%
  { gsub("somebody's", "somebody is", .) } %>% { gsub("someone's", "someone has", .) } %>% { gsub("something's", "something is", .) } %>% { gsub("that'll", "that will", .) } %>%
  { gsub("that're", "that are", .) } %>% { gsub("that's", "that is", .) } %>% { gsub("that'd", "that would", .) } %>% { gsub("there'd", "there would", .) } %>%
  { gsub("there're", "there are", .) } %>% { gsub("there's", "there is", .) } %>% { gsub("these're", "these are", .) } %>% { gsub("they'd", "they would", .) } %>%
  { gsub("they'll", "they will", .) } %>% { gsub("they're", "they are", .) } %>% { gsub("they've", "they have", .) } %>% { gsub("this's", "this is", .) } %>%
  { gsub("those're", "those are", .) } %>% { gsub("'tis", "it is", .) } %>% { gsub("'twas", "it was", .) } %>% { gsub("'twasn't", "it was not", .) } %>%
  { gsub("wasn't", "was not", .) } %>% { gsub("we'd", "we would", .) } %>% { gsub("we'd've", "we would have", .) } %>% { gsub("we'll", "we will", .) } %>%
  { gsub("we're", "we are", .) } %>% { gsub("we've", "we have", .) } %>% { gsub("weren't", "were not", .) } %>% { gsub("what'd", "what did", .) } %>%
  { gsub("what'll", "what will", .) } %>% { gsub("what're", "what are", .) } %>% { gsub("what's", "what is", .) } %>% { gsub("what've", "what have", .) } %>%
  { gsub("when's", "when is", .) } %>% { gsub("where'd", "where did", .) } %>% { gsub("where're", "where are", .) } %>% { gsub("where's ", "where is", .) } %>%
  { gsub("where've", "where have", .) } %>% { gsub("which's", "which is", .) } %>% { gsub("who'd", "who would", .) } %>% { gsub("who'd've", "who would have", .) } %>%
  { gsub("who'll", "who will", .) } %>% { gsub("who're", "who are", .) } %>% { gsub("who's", "who is", .) } %>% { gsub("who've", "who have", .) } %>%
  { gsub("why'd", "why did", .) } %>% { gsub("why're", "why are", .) } %>% { gsub("why's", "why is", .) } %>% { gsub("won't", "will not", .) } %>%
  { gsub("would've", "would have", .) } %>% { gsub("wouldn't", "would not", .) } %>% { gsub("y'all", "you all", .) } %>% { gsub("you'd", "you would", .) } %>%
  { gsub("you'll", "you will", .) } %>% { gsub("you're", "you are", .) } %>% { gsub("you've", "you have", .) }
}

# TEST
process_punctuation <- function(txt) {
  gsub("[.!?]+", " _eos_ ", txt) # replace end of sentence punctuation with special marker
}
