context("get_data_dict")

## Data dict summary data
data_dict <- get_data_dict()

ncols_dict <- ncol(data_dict)
nrows_dict <-  nrow(data_dict)
class_dict <- class(data_dict)[1]
## Expected
exp_nrows <- 396
exp_ncols <- 4
exp_class <- "tbl_df"

test_that("Data dictionary has been successfully downloaded", {
  expect_true(!is.null(data_dict))
})
test_that("Data dictionary is a tibble",{
  expect_equal(exp_class, class_dict)
})

test_that("Data dictionary has the expected number of variables", {
  expect_equal(exp_ncols, ncols_dict)
})

test_that("Data dictionary has the expected number of entries", {
  expect_equal(exp_nrows, nrows_dict)
})