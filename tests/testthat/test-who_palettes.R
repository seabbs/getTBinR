context("who_palettes")

test_that("who_palettes cannot take n larger than palettes", {
  expect_error(who_palettes(palette = "main", n = 100))
})


test_that("who_palettes fails if a unrecognised palette is supplied", {
  expect_error(who_palettes(palette = "dark"))
})
