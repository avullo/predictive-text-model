context("Various helper functions")

test_that("Internet jargon", {
  jargon <- jargon_dictionary()
  
  # test common expressions
  expect_that(jargon[which(jargon$attr == '2b'),"value"], equals("to be"))
  expect_that(jargon[which(jargon$attr == '2nite'),"value"], equals("tonight"))
  expect_that(jargon[which(jargon$attr == '2day'),"value"], equals("today"))
  expect_that(jargon[which(jargon$attr == 'b4'),"value"], equals("before"))
  expect_that(jargon[which(jargon$attr == 'str8'),"value"], equals("straight"))
  expect_that(jargon[which(jargon$attr == 'u'),"value"], equals("you"))
  
  # test edge cases are not included
  expect_that(jargon[which(jargon$attr == '!'),"value"], equals(character(0)))
  expect_that(jargon[which(jargon$attr == '?'),"value"], equals(character(0)))
  expect_that(jargon[which(jargon$attr == '@'),"value"], equals(character(0)))
  
  # test elements are lower case
  expect_that(jargon[which(jargon$attr == 'U'),"value"], equals(character(0)))
})

