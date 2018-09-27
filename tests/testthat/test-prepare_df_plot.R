context("prepare_df_plot")

##No country
df_all <- prepare_df_plot(download_data = TRUE, save = TRUE)

##Supply data
tb_data <- get_tb_burden()
df_supp_all <- prepare_df_plot(tb_data)

## Single country exact match
df_exact_country <- prepare_df_plot(countries = "United Kingdom of Great Britain and Northern Ireland")

## Single country fuzzy matching
df_fuzzy_country <- prepare_df_plot(countries = "United Kingdom")

##Compare to region
df_region <- prepare_df_plot(countries = "United Kingdom",
                             compare_to_region = TRUE)

##Add country facet
df_country_facet <- prepare_df_plot(facet = "g_whoregion")


eur_countries <-  c("Albania", "Andorra",
                    "Armenia", "Austria", 
                    "Azerbaijan", "Belarus", 
                    "Belgium", "Bosnia and Herzegovina",
                    "Bulgaria", "Croatia")                                         
                                            
test_that("TB burden data is correctly processed ready for plotting", {
  skip_on_cran()
  expect_equal(3, length(df_all))
  expect_null(df_all$facet)
  expect_equal("Estimated incidence (all forms) per 100 000 population",
               df_all$metric_label)
  expect_equal("tbl_df", class(df_all$df)[1])
  expect_true(1 <= nrow(df_all$df))
  expect_true(1 <= ncol(df_all$df))
  expect_equal(0, sum(is.na(df_all$df$country)))
  expect_true(!any(duplicated(colnames(df_all$df))))
})

test_that("TB burden data is correctly proccessed when using local data", {
  expect_equal(df_all, df_supp_all)
})


test_that("TB burden data is correctly proccessed when using a single country", {

  expect_true(1 <= length(df_exact_country))
  expect_null(df_exact_country$facet)
  expect_equal("Estimated incidence (all forms) per 100 000 population",
               df_exact_country$metric_label)
  expect_equal("tbl_df", class(df_exact_country$df)[1])
  expect_true(1 <= nrow(df_exact_country$df))
  expect_true(1 <= ncol(df_exact_country$df))
  expect_equal("United Kingdom of Great Britain and Northern Ireland", 
               as.character(unique(df_exact_country$df$country)))
})

test_that("Fuzzy country matching correctly selects a country", {
  expect_equal(df_exact_country, df_fuzzy_country)
})


test_that("TB burden data is correctly proccessed when comparing to the region", {
 
  expect_true(1 <= length(df_region))
  expect_equal("g_whoregion", df_region$facet)
  expect_equal("Estimated incidence (all forms) per 100 000 population",
               df_region$metric_label)
  expect_equal("tbl_df", class(df_region$df)[1])
  expect_true(1 <= nrow(df_region$df))
  expect_true(1 <= ncol(df_region$df))
  expect_equal(eur_countries, 
               as.character(unique(df_region$df$country))[1:10])
})

test_that("Add a facet works correctly", {
  expect_equal("g_whoregion", df_country_facet$facet)
})

test_that("Adding a transform label to the metric label works correctly", {
  df_lab <- prepare_df_plot(metric_label = "test", trans = "suffix")
  
  exp_lab <- "test (suffix)"
  
  expect_equal(exp_lab, df_lab$metric_label)
})

## Tests using dummy data
test_df <- tibble::tibble(country = "test", year = 2000:2001, 
                          e_inc_100k = c(10, 12), e_inc_100k_lo = c(8, 10),
                          e_inc_100k_hi = c(20, 22))

result_df <- test_df
result_df$Year <- result_df$year
result_df$country <- factor(result_df$country)
result_df$`Estimated incidence (all forms) per 100 000 population` <- result_df$e_inc_100k


test_that("prepare_df_plot correctly formats the input data.", {
  skip_on_cran()
  expect_equal(result_df, prepare_df_plot(metric = "e_inc_100k", 
                                          conf = c("_lo", "_hi"),
                                          df = test_df, 
                                          annual_change = FALSE)$df)
})



test_that("annual_change correctly transforms metric and confidence intervals", {

  result_df <- result_df[-1, ]
  result_df <- result_df[, -ncol(result_df)]
  result_df$e_inc_100k <- 0.2
  result_df$e_inc_100k_lo <- 0.25
  result_df$e_inc_100k_hi <- 0.1
  result_df$`Percentage annual change: Estimated incidence (all forms) per 100 000 population` <- 0.2
  
  df_annual_change <- prepare_df_plot(metric = "e_inc_100k", conf = c("_lo", "_hi"),
                                      df = test_df, annual_change = TRUE)
  skip_on_cran()
  expect_equal(result_df, prepare_df_plot(metric = "e_inc_100k", 
                                          conf = c("_lo", "_hi"),
                                          df = test_df, 
                                          annual_change = TRUE)$df)
})

test_that("years are correctly filtered for.", {
  
  result_df <- dplyr::filter(result_df, year == 2000)
  
  skip_on_cran()
  expect_equal(result_df, prepare_df_plot(metric = "e_inc_100k", 
                                          conf = c("_lo", "_hi"),
                                          years = 2000,
                                          df = test_df, 
                                          annual_change = FALSE)$df)
})

