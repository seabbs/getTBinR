context("get_data")

## TB burden data url for testing
url <- "https://extranet.who.int/tme/generateCSV.asp?ds=estimates"


test_that("get_data fails to retrieve data when download_data is specified as FALSE", {
  expect_error(get_data(url = url, download_data = FALSE)
  )
})

test_that("get_data retrieves the specified data when download_data is TRUE", {
  tb_data <- get_data(url = url,
                      save_name = "test_data",
                      save = TRUE, 
                      download_data = TRUE)
  
  expect_true(!is.null(tb_data))
})


test_that("get_data saves a local copy of the data which can then be successfully retrieved", {
  tb_data_local <- get_data(save_name = "test_data")
  
  expect_true(!is.null(tb_data_local))
})

test_that("get_data can download data using utils alternative", {
  tb_data_utils <- get_data(url = url,
                            download_data = TRUE,
                            use_utils = TRUE)
  
  expect_true(!is.null(tb_data_utils))
})
