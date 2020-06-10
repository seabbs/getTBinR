context("summarise_metric")

test_countries <- c("Brazil", "Australia", "Croatia", "France")


test_df <- get_tb_burden()
test_df <- dplyr::filter(test_df, year <= 2017)
test_df <- dplyr::mutate(test_df, e_inc_num = NA)

test_that("summarise_metric can summarise incidence rates for a list of countries", {
  sum_tab <- summarise_metric(test_df,
    metric = "e_inc_100k",
    countries = test_countries
  )
  skip_on_cran()
  expect_known_output(sum_tab, file = "../../tests/test-files/summarise_metric/test-01.rds")
})

test_that("summarise_metric can summarise incidence rates for a single country", {
  sum_tab <- summarise_metric(test_df,
    metric = "e_inc_100k",
    countries = test_countries[1]
  )
  skip_on_cran()
  expect_known_output(sum_tab, file = "../../tests/test-files/summarise_metric/test-02.rds")
})


test_that("summarise_metric can fail gracefully when extensive missing data is present.", {
  sum_tab <- suppressWarnings(summarise_metric(test_df,
    metric = "e_inc_num",
    countries = test_countries[1]
  ))
  skip_on_cran()
  expect_known_output(sum_tab, file = "../../tests/test-files/summarise_metric/test-03.rds")
})

test_that("summarise_metric can provide its own data when not supplied", {
  sum_tab <- summarise_metric(
    metric = "e_inc_100k",
    countries = test_countries[1]
  )
  skip_on_cran()
  expect_true(!is.null(sum_tab))
})


test_that("summarise_metric can produce results when confidence intervals are not wanted", {
  sum_tab <- summarise_metric(test_df,
    metric = "e_inc_100k",
    countries = test_countries[1],
    conf = NULL
  )
  skip_on_cran()
  expect_known_output(sum_tab, file = "../../tests/test-files/summarise_metric/test-04.rds")
})
