library(stringr)

test.email <- function() {
  # valid email addresses: from https://blogs.msdn.microsoft.com/testing123/2009/02/06/email-address-test-cases
  emails <- c("email@domain.com	", "firstname.lastname@domain.com	", "email@subdomain.domain.com", "firstname+lastname@domain.com", "email@123.123.123.123",
              "email@[123.123.123.123]", '"email"@domain.com', "1234567890@domain.com", "email@domain-one.com", "_______@domain.com", "email@domain.name",
              "email@domain.co.jp", "firstname-lastname@domain.com")
  
  template <- "This is an email %s template"
  for (email in emails) {
    checkTrue(str_detect(process_emails(sprintf(template, email)), '_email_'), 'Email detected')
  }
  
  # checkEquals(6, 7)
  # checkEqualsNumeric(6, factorial(3))
  # checkIdentical(6, factorial(3))
  # checkTrue(2 + 2 == 4, 'Arithmetic works')
  # checkException(log('a'), 'Unable to take the log() of a string')
}

test.deactivation <- function() {
  DEACTIVATED('Deactivating this test function')
}