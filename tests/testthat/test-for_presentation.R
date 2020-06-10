context("for_presentation")

test_that("presentation adjustments work", {
  
  plot <- plot_tb_burden_summary(countries = "United Kingdom",
                               compare_all_regions = FALSE, compare_to_region = TRUE)
  fp <- for_presentation(plot)
  
  expect_true(!is.null(plot))
  expect_equal("ggplot", class(fp)[2])
  skip_on_cran()
  vdiffr::expect_doppelganger("presentation", plot)
  
})