context("get_tb_burden")

## Data dict summary data
tb_data <- get_tb_burden(
  download_data = TRUE,
  save = TRUE
)

ncols_tb_data <- ncol(tb_data)
nrows_tb_data <- nrow(tb_data)
class_tb_data <- class(tb_data)[1]

## Expected
exp_nrows <- 1
exp_ncols <- 1
exp_class <- "tbl_df"

test_that("TB burden data has been successfully downloaded", {
  expect_true(!is.null(tb_data))
})

test_that("TB burden data is a tibble", {
  expect_equal(exp_class, class_tb_data)
})

test_that("TB burden data has at least the expected number of variables", {
  expect_true(exp_ncols <= ncols_tb_data)
})

test_that("TB burden has at least the expected number of entries", {
  expect_true(exp_nrows <= nrows_tb_data)
})

test_that("TB burden has no columns that are misjoined", {
  mdr_tb_data <- get_tb_burden(
    download_data = TRUE,
    save = TRUE,
    add_mdr_data = TRUE
  )

  expect_equal(
    ncol(dplyr::select(
      mdr_tb_data,
      dplyr::ends_with(".x"),
      dplyr::ends_with(".y")
    )),
    c(as.integer(0))
  )
})

test_that("When TB burden data can be correctly downloaded when MDR is not also downloaded", {
  tb_burden_with_mdr <- get_tb_burden(add_mdr_data = TRUE)
  tb_burden_no_mdr <- get_tb_burden(add_mdr_data = FALSE)

  expect_true(ncol(tb_burden_with_mdr) > ncol(tb_burden_no_mdr))
})


test_that("Additional datasets can all be downloaded", {
  skip_on_cran()
  expect_true(ncol(tb_data) < ncol(get_tb_burden(additional_datasets = "all")))
})

test_that("Additional datasets have no columns that are  misjoined", {
  skip_on_cran()
  expect_equal(
    ncol(dplyr::select(
      get_tb_burden(additional_datasets = "all"),
      dplyr::ends_with(".x"),
      dplyr::ends_with(".y")
    )),
    c(as.integer(0))
  )
})

test_that("A single additional dataset can be downloaded", {
  skip_on_cran()
  expect_true(ncol(tb_data) <
    ncol(get_tb_burden(
      additional_datasets = available_datasets$dataset[3]
    )))
})


test_that("Downloading fails when an unsupported dataset name is given", {
  skip_on_cran()
  expect_error(get_tb_burden(additional_datasets = "gwegwefgw"))
})
