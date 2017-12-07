# helper functions for processing, i.e cleaning, the data before tokenisation
# this is is line with the workings of the tokenizers package

# special markers to signal the presence of numbers, sentence marks, emails, URLs, twitter tags/names
markers <- c('n', 's', 'e', 'u', 't')

preprocess <- function(txt) {
  # remove single characters which conflicts with special markers
  gsub("\\s[nseut]\\s", " ", txt)
  
  #
  # replace numbers, emails, URLS, twitter signs
  # and end of sentence punctuation with special marks
  #
  
  # numbers
  gsub("[0-9]+([,\\.]?[0-9]+)?", "n", txt)
  
  # emails
  
  # URLs
  
  # twitter hash tags and names
  
  # end of sentence punctuation
  
}
