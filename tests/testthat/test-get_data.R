context("get_data")

## TB burden data url for testing
url <- "https://extranet.who.int/tme/generateCSV.asp?ds=estimates"


test_that("get_data fails to retrieve data when download_data is specified as FALSE", {
  expect_error(get_data(url = url, save_name = "not_present", download_data = FALSE))
})

test_that("get_data retrieves the specified data when download_data is TRUE", {
  tb_data <- get_data(url = url,
                      save_name = "test_data",
                      save = TRUE, 
                      download_data = TRUE)
  
  expect_true(!is.null(tb_data))
})


test_that("get_data saves a local copy of the data which can then be successfully retrieved", {
  tb_data_local <- get_data(save_name = "test_data", download_data = FALSE)
  
  expect_true(!is.null(tb_data_local))
})

test_that("get_data can download data using utils alternative", {
  
  skip_on_cran()
  expect_true(!is.null(get_data(url = url, 
                                download_data = TRUE,
                                use_utils = TRUE)))
})


test_that("get_data fails to download the data when an incorrect URL is given.", {
  expect_error(suppressWarnings(get_data(url = NA,
                        download_data = TRUE,
                        retry_download = FALSE,
                        save_name = "test_no_url")))
})


test_that("get_data can download data using direct download alternative.", {

  skip_on_cran()
  expect_true(!is.null(get_data(url = url, 
                                download_data = TRUE,
                                use_direct_download = TRUE,
                                save_name = "direct_test")))
})