library(tokenizers)
library(tidyverse)
library(tidytext)
# library(R.utils)
# library(data.table)

ngram_table <- function(data, size = 1) {
  stopifnot(!is.null(data$text))
  stopifnot(size >= 1 & size <= 4)
  
  table <- 
    tokenise(data, size) %>%
    count(w, sort = TRUE) %>%
    mutate(w = reorder(w,n))
  
  # return in the simplest (unigram) case,
  # rename tok col for consistency with other cases
  if(size == 1) { return(table %>% rename(w1 = w)) }
  
  # split ngrams (n > 1) token column into one column for each word
  cols <- c()
  for (i in seq(size)) {
    cols <- c(cols, paste("w", i, sep = ""))
  }
  table %>%
    separate(w, cols, sep = " ")
} 

tokenise <- function(data, size) {
  if(size == 1) {
    return(data %>% unnest_tokens(w, text))
  }
  
  data %>%
    unnest_tokens(w, text, token = "ngrams", n = size)
}

#' create an Ngram tokenizer
#' @param ng, an integer, indicates length of the ngrams, i.e., for ng = 2, the
#' text will be splitted in bigrams, for ng = 3, in trigrams, etc.
#' @return a function that accepts text as input and returns a vector of ngrams
tokenizer <- function(ng) {
  #' splits a string in ngrams
  #' @param x the string to be tokenized
  #' @return a vector containing the ngrams
  t <- function(x)
    unlist(tokenize_ngrams(x, n = ng))
}
