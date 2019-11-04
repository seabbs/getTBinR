context("theme_who")

test_that("theme_who can be used with package plotting functions", {
  
  plot <- plot_tb_burden_summary(conf = NULL, verbose = FALSE) +
    theme_who()
  
  expect_true(!is.null(plot))
  expect_equal("ggplot", class(plot)[2])
  skip_on_cran()
  vdiffr::expect_doppelganger("who-summary", plot)
})
