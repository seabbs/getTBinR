context("map_tb_burden")


test_that("map_tb_burden produces a plot", {
  
  plot <- map_tb_burden(download_data = TRUE, save = TRUE)
  
  expect_true(!is.null(plot))
  expect_equal("ggplot", class(plot)[2])
})

test_that("map_tb_burden produces a plot when a log transform is used", {
  
  plot <- map_tb_burden(trans = "log")
  
  expect_true(!is.null(plot))
  expect_equal("ggplot", class(plot)[2])
})

test_that("map_tb_burden produces a plot with annual change", {
  
  plot <- map_tb_burden(annual_change = TRUE)
  
  expect_true(!is.null(plot))
  expect_equal("ggplot", class(plot)[2])
})

test_that("map_tb_burden produces when no year is specified", {
  
  plot <- map_tb_burden(annual_change = TRUE, year = NULL)
  
  expect_true(!is.null(plot))
  expect_equal("ggplot", class(plot)[2])
})

test_that("map_tb_burden produces fill type is manually specified and fails when it is misspecifed", {
  
  plot <- map_tb_burden(fill_var_type = "continuous")
  
  expect_true(!is.null(plot))
  expect_equal("ggplot", class(plot)[2])
  expect_error(map_tb_burden(fill_var_type = "test"))
})

test_that("map_tb_burden can have a custom legend specified.", {
  
  test_label <- "test (test - test)"
  plot <- map_tb_burden(metric_label = test_label)
  
  expect_true(!is.null(plot))
  expect_equal(plot$labels$fill, test_label)
})

test_that("map_tb_burden produces an interactive plot", {
  
  plot_int <- map_tb_burden(interactive = TRUE)
  
  expect_true(!is.null(plot_int))
  expect_equal("plotly", class(plot_int)[1])
})

test_that("map_tb_burden produces an error when multiple years are mapped with
          interative = FALSE", {
            expect_error(map_tb_burden(year = c(2000, 2001), interactive = FALSE))
          })