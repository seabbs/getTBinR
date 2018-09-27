context("plot_tb_burden_overview")

test_that("plot_tb_burden_overview produces a plot", {
  
  plot <- plot_tb_burden_overview(download_data = TRUE, save = TRUE, years = NULL)
  
  expect_true(!is.null(plot))
  expect_equal("ggplot", class(plot)[2])
  skip_on_cran()
  vdiffr::expect_doppelganger("base-overview", plot)
})

test_that("plot_tb_burden_overview produces a plot with a log10 transform", {
  
  plot <- plot_tb_burden_overview(trans = "log10")
  
  expect_true(!is.null(plot))
  expect_equal("ggplot", class(plot)[2])
  skip_on_cran()
  vdiffr::expect_doppelganger("log-overview", plot)
})

test_that("plot_tb_burden_overview produces a plot when the annual_change option is used", {
  
  plot <- plot_tb_burden_overview(annual_change = TRUE)
  
  expect_true(!is.null(plot))
  expect_equal("ggplot", class(plot)[2])
})


test_that("plot_tb_burden_overview produces an interactive plot", {
  plot_int <- plot_tb_burden_overview(interactive = TRUE)
  
  expect_true(!is.null(plot_int))
  expect_equal("plotly", class(plot_int)[1])
})