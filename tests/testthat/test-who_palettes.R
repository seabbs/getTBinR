context("who_palettes")

test_that("who_palettes cannot take n larger than palettes or theme not provided", {
  
  large_n <- who_palettes(palette = "main", n = 100)
  expect_error(large_n, "n is larger than number of available colours for chosen palette")
  
  wrong_col <- who_palettes(palette = "dark")
  expect_error(wrong_col, "chosen palette not available")
})
