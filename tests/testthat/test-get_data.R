context("get_data")

## TB burden data url for testing
url <- "https://extranet.who.int/tme/generateCSV.asp?ds=estimates"

## Remove local data copy if it exists
if (file.exists("data-raw/test_data.rds")) {
  file.remove("data-raw/test_data.rds")
}

tb_data <- get_data(url = url,
                    save_name = "test_data",
                    save = TRUE, 
                    download_data = TRUE)

tb_data_local <- get_data(save_name = "test_data")


## Expected


test_that("get_data fails to retrieve data when download_data is specified as FALSE", {
  expect_error(get_data(url = url, download_data = FALSE)
  )
})

test_that("get_data retrieves the specified data when download_data is TRUE", {
  expect_true(!is.null(tb_data))
})


test_that("get_data saves a local copy of the data which can then be successfully retrieved", {
  expect_true(!is.null(tb_data_local))
})

