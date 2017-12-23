context("Preprocessing text corpus")

test_that("Number Filtering", {
  with_numbers <- c("Simple number 50 in the middle", "100.26 is at the start", "And this one is at the end 34,6")
  
  for (string in with_numbers) {
    expect_that(str_detect(process_numbers(string), " _num_ "), is_true())
  }
})

test_that("Email Filtering", {
  # valid email addresses: from https://blogs.msdn.microsoft.com/testing123/2009/02/06/email-address-test-cases
  emails <- c("email@domain.com", "firstname.lastname@domain.com", "email@subdomain.domain.com", "firstname+lastname@domain.com",
              "email@123.123.123.123", "1234567890@domain.com", "email@domain-one.com", "_______@domain.com", "email@domain.name", 
              "email@domain.co.jp", "firstname-lastname@domain.com",  "email@[123.123.123.123]") 
              # This become too expensive to match --> '"email"@domain.com'
  template <- "This is a string with an %s in it"
  
  # test it detects emails
  for (email in emails) {
    expect_that(process_emails(sprintf(template, email)), 
                equals('This is a string with an  _email_  in it'))
  }
  
  # test can do that in any position
  email <- emails[1]
  templates <- c("%s at the beginning", "at the end %s", "with punctuation :%s", "another with puctuation %s!")
  for (template in templates) {
    expect_that(str_detect(process_emails(sprintf(template, email)), "_email_"), is_true())
  }
})

test_that("URLs Filtering", {
  with_urls <- c("download file from http://example.com", "this is the link to my website https://www.google.com/ for more info",
                 "this link to ftp://www.example.org/community/mail/view.php?f=db/6463 gives more info")
  for (with_url in with_urls) {
    expect_that(str_detect(process_urls(with_url), " _url_ "), is_true())
  }
})

test_that("Twitter Filtering", {
  msgs <- c("Yeah buddy! #800!", "Flippin' excited to see at the #HollywoodBowl tonight!", 
            "#marketingFAIL RT : looks like we're on the same page", "This contains aRT and crta confusing RT: rt : so watch out")
  expect_that(process_twitter(msgs[1]), equals("Yeah buddy! _hashtag_!"))
  expect_that(process_twitter(msgs[2]), equals("Flippin' excited to see at the _hashtag_ tonight!"))
  expect_that(process_twitter(msgs[3]), equals("_hashtag_   : looks like we're on the same page"))
  expect_that(process_twitter(msgs[4]), equals("This contains aRT and crta confusing  :   : so watch out"))
})

test_that("Slang Filtering", {
  expect_that(process_slang("Come on u lazy boy, wake up b4 it's t late and don't forget to b nice"),
              equals("Come on you lazy boy, wake up before it's too late and don't forget to be nice"))
})

test_that("Contraction Filtering", {
  expect_that(process_contractions("i'd rather go for what aren't things normally experienced. who'd've known that? you know, we'll go there"),
              equals("i would rather go for what are not things normally experienced. who would have known that? you know, we will go there"))
})

test_that("Strong words", {
  strong_words <- strong_words()
  
  expect_that(any(str_detect(strong_words, "negro")), is_true())
  expect_that(any(str_detect(strong_words, "neonazi")), is_true())
  expect_that(any(str_detect(strong_words, "nudity")), is_true())
})

test_that("Strong Words Filtering", {
  
})

test_that("Contractions Filtering", {
  
})

test_that("Punctuation Filtering", {
  
})