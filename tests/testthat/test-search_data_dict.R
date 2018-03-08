context("search_data_dict")


## Test dictionary

## Search for a known variable
test_var <- search_data_dict(var = "country", download_data = TRUE, save = TRUE)

exp_var <- tibble::tibble(variable_name = "country",
                          dataset = "Country identification",
                          code_list = "",
                          definition = "Country or territory name")


## Search for all variables mentioning mortality in their definition
test_def <- search_data_dict(def = "mortality")

exp_def <- c("e_mort_100k", "e_mort_100k_hi", "e_mort_100k_lo",
             "e_mort_exc_tbhiv_100k", "e_mort_exc_tbhiv_100k_hi",
             "e_mort_exc_tbhiv_100k_lo", "e_mort_tbhiv_100k",
             "e_mort_tbhiv_100k_hi", "e_mort_tbhiv_100k_lo")

## Search for both a known variable and for mortality being mentioned in there definition
## Duplicate entries will be omitted.
test_var_def <- search_data_dict(var = "e_mort_100k", def = "mortality")

test_that("Variable search for a known variable returns expected results", {
  expect_equal(exp_var, test_var)
})

test_that("Definition search for an unknown variable returns expected results", {
  expect_true(!is.null(test_def))
  expect_equal("tbl_df", class(test_def)[1])
  expect_true(1 <= nrow(test_def))
  expect_true(1 <= ncol(test_def))
  expect_equal(exp_def, test_def$variable_name)
})

test_that("Combined variable and definition search returns expected results", {
  expect_true(!is.null(test_var_def))
  expect_equal("tbl_df", class(test_var_def)[1])
  expect_true(1 <= nrow(test_var_def))
  expect_true(1 <= ncol(test_var_def))
  expect_equal(exp_def, test_var_def$variable_name)
})
