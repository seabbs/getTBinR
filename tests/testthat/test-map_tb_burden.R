context("map_tb_burden")

plot <- map_tb_burden(download_data = TRUE, save = TRUE)

plot_int <- map_tb_burden(interactive = TRUE)

test_that("map_tb_burden produces a plot", {
  expect_true(!is.null(plot))
  expect_equal("ggplot", class(plot)[2])
})

test_that("map_tb_burden produces an interactive plot", {
  expect_true(!is.null(plot_int))
  expect_equal("plotly", class(plot_int)[1])
})