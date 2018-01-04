context("map_tb_burden")


test_that("map_tb_burden produces a plot", {
  
  plot <- map_tb_burden(download_data = TRUE, save = TRUE)
  
  expect_true(!is.null(plot))
  expect_equal("ggplot", class(plot)[2])
})

test_that("map_tb_burden produces a plot when a log transform is used", {
  
  plot <- map_tb_burden(download_data = TRUE, save = TRUE, trans = "log")
  
  expect_true(!is.null(plot))
  expect_equal("ggplot", class(plot)[2])
})

test_that("map_tb_burden produces an interactive plot", {
  
  plot_int <- map_tb_burden(interactive = TRUE)
  
  expect_true(!is.null(plot_int))
  expect_equal("plotly", class(plot_int)[1])
})