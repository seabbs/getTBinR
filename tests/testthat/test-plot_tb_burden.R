context("plot_tb_burden")

test_that("plot_tb_burden produces a plot", {
  plot <- plot_tb_burden(download_data = TRUE, save = TRUE)
  
  expect_true(!is.null(plot))
  expect_equal("ggplot", class(plot)[2])
  skip_on_cran()
  vdiffr::expect_doppelganger("base-plot", plot)
})

test_that("plot_tb_burden produces a plot with smoothed data", {
  plot <- plot_tb_burden(download_data = TRUE, save = TRUE, smooth = TRUE)
  
  expect_true(!is.null(plot))
  expect_equal("ggplot", class(plot)[2])
  skip_on_cran()
  vdiffr::expect_doppelganger("smooth-plot", plot)
})

test_that("plot_tb_burden produces a plot with a log10 transform", {
  plot <- plot_tb_burden(trans = "log10")
  
  expect_true(!is.null(plot))
  expect_equal("ggplot", class(plot)[2])
  skip_on_cran()
  vdiffr::expect_doppelganger("log-plot", plot)
})

test_that("plot_tb_burden produces a plot with the annual_change option", {
  plot <- plot_tb_burden(annual_change = TRUE)
  
  expect_true(!is.null(plot))
  expect_equal("ggplot", class(plot)[2])
  skip_on_cran()
  vdiffr::expect_doppelganger("annual-plot", plot)
})

test_that("plot_tb_burden produces an interactive plot", {
  plot_int <- plot_tb_burden(interactive = TRUE)
  
  expect_true(!is.null(plot_int))
  expect_equal("plotly", class(plot_int)[1])
})