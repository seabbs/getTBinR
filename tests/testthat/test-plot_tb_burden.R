context("plot_tb_burden")

test_that("plot_tb_burden produces a plot", {
  plot <- plot_tb_burden(download_data = TRUE, save = TRUE)
  
  expect_true(!is.null(plot))
  expect_equal("ggplot", class(plot)[2])
})

test_that("plot_tb_burden produces an interactive plot", {
  plot_int <- plot_tb_burden(interactive = TRUE)
  
  expect_true(!is.null(plot_int))
  expect_equal("plotly", class(plot_int)[1])
})