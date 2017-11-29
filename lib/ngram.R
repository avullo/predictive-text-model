library(tokenizers)
# library(R.utils)
# library(data.table)

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