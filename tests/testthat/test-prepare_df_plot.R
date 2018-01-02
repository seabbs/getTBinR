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
  expect_equal(3, length(df_all))
  expect_null(df_all$facet)
  expect_equal("Estimated incidence (all forms) per 100 000 population",
               df_all$metric_label)
  expect_equal("tbl_df", class(df_all$df)[1])
  expect_equal(3651, nrow(df_all$df))
  expect_equal(72, ncol(df_all$df))
  expect_equal(0, sum(is.na(df_all$df$country)))
})

test_that("TB burden data is correctly proccessed when using local data", {
  expect_equal(df_all, df_supp_all)
})


test_that("TB burden data is correctly proccessed when using a single country", {
  expect_equal(3, length(df_exact_country))
  expect_null(df_exact_country$facet)
  expect_equal("Estimated incidence (all forms) per 100 000 population",
               df_exact_country$metric_label)
  expect_equal("tbl_df", class(df_exact_country$df)[1])
  expect_equal(17, nrow(df_exact_country$df))
  expect_equal(72, ncol(df_exact_country$df))
  expect_equal("United Kingdom of Great Britain and Northern Ireland", 
               as.character(unique(df_exact_country$df$country)))
})

test_that("Fuzzy conutry matching correctly selects a country", {
  expect_equal(df_exact_country, df_fuzzy_country)
})


test_that("TB burden data is correctly proccessed when comparing to the region", {
  expect_equal(3, length(df_region))
  expect_equal("g_whoregion", df_region$facet)
  expect_equal("Estimated incidence (all forms) per 100 000 population",
               df_region$metric_label)
  expect_equal("tbl_df", class(df_region$df)[1])
  expect_equal(913, nrow(df_region$df))
  expect_equal(72, ncol(df_region$df))
  expect_equal(eur_countries, 
               as.character(unique(df_region$df$country))[1:10])
})

test_that("Add a facet works correctly", {
  expect_equal("g_whoregion", df_country_facet$facet)
})
