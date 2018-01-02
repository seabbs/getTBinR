context("plot_tb_burden")

plot <- plot_tb_burden(download_data = TRUE, save = TRUE)

plot_int <- plot_tb_burden(interactive = TRUE)

test_that("plot_tb_burden produces a plot", {
  expect_true(!is.null(plot))
  expect_equal("ggplot", class(plot)[2])
})

test_that("plot_tb_burden produces an interactive plot", {
  expect_true(!is.null(plot_int))
  expect_equal("plotly", class(plot_int)[1])
})