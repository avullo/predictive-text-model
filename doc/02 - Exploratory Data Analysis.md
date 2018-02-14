# Introduction

The basic goal here is to develop an understanding of the various
 statistical properties of the data set so
 that you can build a good prediction model down the road.
 And so two key questions to consider here are, how frequently do certain words
 appear in the data set and how frequently do certain pairs of words appear together?
 Once you've considered these basic questions you can move on to kind of
 more complex ones like, how do triplets of words appear together

Thinking is important, and the reason is because it helps you build expectations about the data set. And that's important, because when you have expectations about a data set it helps you to know when certain features or certain observations are unexpected. Now, these unexpected things might be, errors or anomalies in the data set, or they might be really interesting features that you have to account for. Now, your initial expectations might be wrong of course, but  as you look at the data and you see observations, you can kind of calibrate and refine your expectations as you go. Now, the key thing is that when you do not have any expectations about a data set, then when you start looking at the data, everything will kind of seem correct. And it can be difficult to sort out what's useful and what's not useful in the data.

So, this is a key task in developing our prediction model for this project.

# The Task

The first step in building a predictive model for text is understanding the distribution and relationship between the words, tokens, and phrases in the text. The goal of this task is to understand the basic relationships you observe in the data and prepare to build your first linguistic models.

Tasks to accomplish

    Exploratory analysis - perform a thorough exploratory analysis of the data, understanding the distribution of words and relationship between the words in the corpora.
    Understand frequencies of words and word pairs - build figures and tables to understand variation in the frequencies of words and word pairs in the data.

Questions to consider

    Some words are more frequent than others - what are the distributions of word frequencies?
    What are the frequencies of 2-grams and 3-grams in the dataset?
    How many unique words do you need in a frequency sorted dictionary to cover 50% of all word instances in the language? 90%?
    How do you evaluate how many of the words come from foreign languages?
    Can you think of a way to increase the coverage -- identifying words that may not be in the corpora or using a smaller number of words in the dictionary to cover the same number of phrases?