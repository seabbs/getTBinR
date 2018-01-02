context("plot_tb_burden_overview")

plot <- plot_tb_burden_overview(download_data = TRUE, save = TRUE)

plot_int <- plot_tb_burden_overview(interactive = TRUE)

test_that("plot_tb_burden_overview produces a plot", {
  expect_true(!is.null(plot))
  expect_equal("ggplot", class(plot)[2])
})

test_that("plot_tb_burden_overview produces an interactive plot", {
  expect_true(!is.null(plot_int))
  expect_equal("plotly", class(plot_int)[1])
})