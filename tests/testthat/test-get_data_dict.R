context("get_data_dict")

## Data dict summary data
data_dict <- get_data_dict(download_data = TRUE, 
                           save = TRUE)

ncols_dict <- ncol(data_dict)
nrows_dict <-  nrow(data_dict)
class_dict <- class(data_dict)[1]
## Expected
exp_nrows <- 1
exp_ncols <- 1
exp_class <- "tbl_df"

test_that("Data dictionary has been successfully downloaded", {
  expect_true(!is.null(data_dict))
})
test_that("Data dictionary is a tibble",{
  expect_equal(exp_class, class_dict)
})

test_that("Data dictionary has at least the expected number of variables", {
  expect_true(exp_ncols <= ncols_dict)
})

test_that("Data dictionary has at least the expected number of entries", {
  expect_true(exp_nrows <= nrows_dict)
})

test_that("Data dictionary is the same when downloaded using utils::read.csv.
          Not testing definitions as encoded differently", {
  skip_on_cran()
  expect_equal(data_dict[-ncol(data_dict)], 
               get_data_dict(download_data = TRUE, 
                             use_utils = TRUE,
                             dict_save_name = "dict_with_utils")[,-ncol(data_dict)])
  
})