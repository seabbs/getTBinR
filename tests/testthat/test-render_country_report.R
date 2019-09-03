context("render_country_report")


test_that("render_country_report completes successfully", {
  skip_on_cran()
  expect_true(grepl("country-report.html", render_country_report()))
})
