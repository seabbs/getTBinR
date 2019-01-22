context("summarise_tb_burden")

test_countries <- c("Brazil", "Australia", "Croatia", "France")
test_year <- 2000


test_that("summarise_tb_burden can summarise a variable
          without confidence intervals for a group of countries", {
            sum_tab <- summarise_tb_burden(metric = "e_inc_num",
                                           stat = "mean",
                                           countries = test_countries,
                                           years = test_year,
                                           conf = NULL)
            skip_on_cran()
            expect_known_output(sum_tab, file = "../../tests/test-files/summarise_tb_burden/test-01.rds")
})


test_that("summarise_tb_burden can summarise a variable
          without confidence intervals for a group of countries, comparing within regions", {
            sum_tab <- summarise_tb_burden(metric = "e_inc_num",
                                           stat = "mean",
                                           countries = test_countries,
                                           compare_to_region = TRUE,
                                           years = test_year + 1,
                                           conf = NULL)
            skip_on_cran()
            expect_known_output(sum_tab, file = "../../tests/test-files/summarise_tb_burden/test-02.rds")
          })


test_that("summarise_tb_burden can summarise a variable
          across to all regions", {
            sum_tab <- summarise_tb_burden(metric = "e_inc_num",
                                           stat = "mean",
                                           countries = NULL,
                                           compare_all_regions = TRUE,
                                           years = test_year + 2,
                                           conf = NULL)
            skip_on_cran()
            expect_known_output(sum_tab, file = "../../tests/test-files/summarise_tb_burden/test-03.rds")
          })


test_that("summarise_tb_burden can summarise a variable
          for a custom group of countries", {
            sum_tab <- summarise_tb_burden(metric = "e_inc_num",
                                           countries = NULL,
                                           custom_compare = list(low = c("Germany", "Spain"), 
                                                              hi = c("Nigeria", "India")),
                                           years = test_year + 3,
                                           conf = NULL)
            skip_on_cran()
            expect_known_output(sum_tab, file = "../../tests/test-files/summarise_tb_burden/test-04.rds")
            expect_error(
              summarise_tb_burden(metric = "e_inc_num",
                                  countries = NULL,
                                  custom_compare = c(low = c("Germany", "Spain"), 
                                                     hi = c("Nigeria", "India")),
                                  years = test_year + 2,
                                  conf = NULL)
            )
            expect_error(
              summarise_tb_burden(metric = "e_inc_num",
                                  countries = NULL,
                                  custom_compare = c(c("Germany", "Spain"), 
                                                     hi = c("Nigeria", "India")),
                                  years = test_year + 2,
                                  conf = NULL)
            )
          })


test_that("summarise_tb_burden can summarise a variable
          globally", {
            sum_tab <- summarise_tb_burden(metric = "e_inc_num",
                                           countries = NULL,
                                           compare_to_world = TRUE,
                                           years = test_year + 4,
                                           conf = NULL)
            skip_on_cran()
            expect_known_output(sum_tab, file = "../../tests/test-files/summarise_tb_burden/test-05.rds")
          })


test_that("summarise_tb_burden can summarise a variable
          for all regions, and globally without truncating zero", {
            sum_tab <- summarise_tb_burden(metric = "e_inc_num",
                                           countries = NULL,
                                           compare_all_regions = TRUE,
                                           compare_to_world = TRUE,
                                           truncate_at_zero = FALSE,
                                           years = test_year + 4,
                                           conf = NULL)
            skip_on_cran()
            expect_known_output(sum_tab, file = "../../tests/test-files/summarise_tb_burden/test-06.rds")
          })



test_that("summarise_tb_burden can summarise a variable
          with confidence intervals for all regions and globally", {
            sum_tab <- summarise_tb_burden(metric = "e_inc_num",
                                           samples = 1000,
                                           countries = NULL,
                                           compare_all_regions = TRUE,
                                           compare_to_world = TRUE,
                                           years = test_year + 4)
            skip_on_cran()
            expect_known_output(sum_tab, 
                                file = "../../tests/test-files/summarise_tb_burden/test-07.rds", 
                                tolerance = 10)
          })


test_that("summarise_tb_burden can summarise a variable
          with confidence intervals for all regions and globally then compare to a
          shortlist of countries", {
            sum_tab <- summarise_tb_burden(metric = "e_inc_num",
                                           samples = 1000,
                                           countries = test_countries,
                                           compare_all_regions = TRUE,
                                           compare_to_world = TRUE,
                                           years = test_year + 4)
            skip_on_cran()
            expect_known_output(sum_tab, 
                                file = "../../tests/test-files/summarise_tb_burden/test-08.rds", 
                                tolerance = 10)
          })


test_that("summarise_tb_burden can summarise a variable using the median", {
            sum_tab <- summarise_tb_burden(metric = "e_inc_num",
                                           countries = NULL,
                                           stat = "median",
                                           conf = NULL,
                                           compare_all_regions = TRUE,
                                           compare_to_world = TRUE,
                                           years = test_year + 4)
            skip_on_cran()
            expect_known_output(sum_tab, 
                                file = "../../tests/test-files/summarise_tb_burden/test-09.rds")
          })



test_that("summarise_tb_burden can summarise the annual change of a variable
          with confidence intervals for all regions and globally then compare to a
          shortlist of countries", {
            sum_tab <- summarise_tb_burden(metric = "e_inc_100k",
                                           samples = 1000,
                                           countries = test_countries,
                                           compare_all_regions = TRUE,
                                           compare_to_world = TRUE,
                                           annual_change = TRUE)
            skip_on_cran()
            expect_known_output(sum_tab, 
                                file = "../../tests/test-files/summarise_tb_burden/test-10.rds")
          })


test_that("summarise_tb_burden can generate summarised incidence rates for regions and globally", {
            sum_tab <- summarise_tb_burden(metric = "e_inc_num",
                                           stat = "rate",
                                           countries = test_countries,
                                           compare_all_regions = TRUE,
                                           compare_to_world = TRUE,
                                           annual_change = FALSE)
            skip_on_cran()
            expect_known_output(sum_tab, 
                                file = "../../tests/test-files/summarise_tb_burden/test-11.rds")
          })

test_that("summarise_tb_burden can generate summarised proportions for regions and globally", {
  sum_tab <- summarise_tb_burden(metric = "e_mort_exc_tbhiv_num",
                                 stat = "prop",
                                 denom = "e_inc_num",
                                 countries = test_countries,
                                 compare_all_regions = TRUE,
                                 compare_to_world = TRUE,
                                 annual_change = FALSE)
  skip_on_cran()
  expect_known_output(sum_tab, 
                      file = "../../tests/test-files/summarise_tb_burden/test-12.rds")
})


