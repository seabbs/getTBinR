context("plot_tb_burden_summary")

test_that("plot_tb_burden_summary produces a plot", {
  
  plot <- plot_tb_burden_summary()
  
  expect_true(!is.null(plot))
  expect_equal("ggplot", class(plot)[2])
  skip_on_cran()
  vdiffr::expect_doppelganger("base-summary", plot)
})

test_that("plot_tb_burden_overview produces a plot with a log10 transform", {
  
  plot <- plot_tb_burden_summary(trans = "log10")
  
  expect_true(!is.null(plot))
  expect_equal("ggplot", class(plot)[2])
  skip_on_cran()
  vdiffr::expect_doppelganger("log-summary", plot)
})

test_that("plot_tb_burden_summary produces an interactive plot", {
  plot_int <- plot_tb_burden_summary(interactive = TRUE)
  
  expect_true(!is.null(plot_int))
  expect_equal("plotly", class(plot_int)[1])
})


test_that("plot_tb_burden_summary produces a plot when the metric label is NULL", {
  
  plot <- plot_tb_burden_summary(metric_label = NULL, facet = "Area")
  
  expect_true(!is.null(plot))
  expect_equal("ggplot", class(plot)[2])
  skip_on_cran()
  vdiffr::expect_doppelganger("label-summary", plot)
})

test_that("plot_tb_burden_summary produces a plot when the metric label is given", {
  
  plot <- plot_tb_burden_summary(metric_label = "", facet = "Area")
  
  expect_true(!is.null(plot))
  expect_equal("ggplot", class(plot)[2])
  skip_on_cran()
  vdiffr::expect_doppelganger("label-given-summary", plot)
})