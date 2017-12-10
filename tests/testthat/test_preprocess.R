context("Preprocessing text corpus")

test_that("Email filter", {
  # valid email addresses: from https://blogs.msdn.microsoft.com/testing123/2009/02/06/email-address-test-cases
  emails <- c("email@domain.com", "firstname.lastname@domain.com	", "email@subdomain.domain.com", "firstname+lastname@domain.com", "email@123.123.123.123",
              "email@[123.123.123.123]", '"email"@domain.com', "1234567890@domain.com", "email@domain-one.com", "_______@domain.com", "email@domain.name",
              "email@domain.co.jp", "firstname-lastname@domain.com")
  template <- "This is a string with an %s in it"
  
  for (email in emails) {
    expect_that(process_emails(sprintf(template, email)), 
                equals('This is a string with an _email_ in it'))
  }
})

test_that("Slang filter", {
  expect_that(process_slang("Come on u lazy boy, wake up b4 it's t late and don't forget to b nice"),
              equals("Come on you lazy boy, wake up before it's too late and don't forget to be nice"))
})

test_that("Strong words", {
  strong_words <- strong_words()
  
  expect_that(any(str_detect(strong_words, "negro")), is_true())
  expect_that(any(str_detect(strong_words, "neonazi")), is_true())
  expect_that(any(str_detect(strong_words, "nudity")), is_true())
})