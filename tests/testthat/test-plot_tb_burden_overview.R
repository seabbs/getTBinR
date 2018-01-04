context("plot_tb_burden_overview")

test_that("plot_tb_burden_overview produces a plot", {
  
  plot <- plot_tb_burden_overview(download_data = TRUE, save = TRUE)
  
  expect_true(!is.null(plot))
  expect_equal("ggplot", class(plot)[2])
})

test_that("plot_tb_burden_overview produces an interactive plot", {
  plot_int <- plot_tb_burden_overview(interactive = TRUE)
  
  expect_true(!is.null(plot_int))
  expect_equal("plotly", class(plot_int)[1])
})