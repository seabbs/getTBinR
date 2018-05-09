
#' Summarise TB Burden
#'
#' @param years Numeric vector of years. Defaults to \code{NULL} which includes all years in the data. 
#' @param samples Numeric, the number of samples to use to generate confidence 
#' intervals (only used when \code{conf} are present)
#' @param compare_to_world Logical, defaults to \code{FALSE}. Should a comparision be made to 
#' the metric of interests global value.
#' @param custom_compare Logical, defaults to \code{NULL}. A named list of custom countries.
#' @param compare_all_regions Logical, defaults to \code{FALSE}. Should all regions be compared.
#' @param compute_rate Logical, defaults to \code{FALSE}. Should the rate be calculated using the 
#' summarised population.
#' @param compute_rate_with Character, the variable to compute the rate with. Defaults to the 
#' using the total population (\code{"e_pop_num"}).
#' @param rate_scaling Numeric, scaling to apply to the calculate rate. Defaults to 100,000.
#' @param truncate_at_zero Logical, defaults to \code{TRUE}. Should lower bounds be truncated at zero?
#' @inheritParams prepare_df_plot
#' @return A tibble containing summarised values (with 95% confidence intervals) for the metric of choice
#' stratified by area and year.
#' @export
#'
#' @import magrittr
#' @importFrom dplyr mutate group_by ungroup select select_at mutate_at funs left_join bind_rows summarise summarise_at
#' @importFrom purrr map map2_dfr compact reduce map_lgl
#' @importFrom tibble as_tibble
#' @importFrom tidyr nest unnest
#' @importFrom stats qnorm sd
#' @examples
#' 
#' 
#' ## Get summary of the e_mdr_pct_rr_new cases in 2016
#' summarise_tb_burden(metric = "e_mdr_pct_rr_new",
#'                     years = 2016,
#'                     samples = 100,
#'                     compare_all_regions = TRUE,
#'                     compare_to_world = TRUE,
#'                     verbose = TRUE)
#' 
#' ## Get summary of the case fatality rate for regions and the world in 2016
#' ## Boostrapping CI's
#' summarise_tb_burden(metric = "cfr",
#'                     years = 2016,
#'                     samples = 100,
#'                     compare_all_regions = TRUE,
#'                     compare_to_world = TRUE,
#'                     verbose = FALSE)
#' 
#' 
#' ## Get summary data for the UK, Europe and the world
#' ## Bootstrapping CI's and calculating the incidence rate
#' summarise_tb_burden(metric = "e_inc_num",
#'                     samples = 100,
#'                     countries = "United Kingdom", 
#'                     compare_to_world = TRUE, 
#'                     compare_to_region = TRUE,
#'                     compute_rate = TRUE,
#'                     verbose = FALSE)
#'                     
summarise_tb_burden <- function(df = NULL,
                                dict = NULL, 
                                metric = "e_inc_100k",
                                metric_label = NULL,
                                conf = c("_lo", "_hi"),
                                years = NULL,
                                samples = 1000,
                                countries = NULL,
                                compare_to_region = FALSE,
                                compare_to_world = FALSE,
                                custom_compare = NULL,
                                compare_all_regions = FALSE,
                                compute_rate = FALSE,
                                compute_rate_with = "e_pop_num",
                                rate_scaling = 100000,
                                truncate_at_zero = TRUE,
                                annual_change = FALSE,
                                download_data = TRUE,
                                save = TRUE,
                                burden_save_name = "TB_burden",
                                dict_save_name = "TB_data_dict",
                                verbose = TRUE) {

  ## Deal with undefined global function notes
  . <- NULL; Area <- NULL; Year <- NULL; country <- NULL; data <- NULL; e_pop_num <- NULL;
  g_whoregion <- NULL; id <- NULL; mean_hi <- NULL; mean_lo <- NULL; n <- NULL; pop <- NULL;
  
  if (!is.null(countries)) {
    
    if (verbose) {
      message("Extracting data for specified countries")
    }
    
    countries_df <- prepare_df_plot(df = df,
                                    dict = dict,
                                    metric = metric,
                                    metric_label = metric_label,
                                    conf = conf,
                                    countries = countries,
                                    compare_to_region = FALSE,
                                    annual_change = annual_change,
                                    download_data = download_data,
                                    save = save,
                                    burden_save_name = burden_save_name,
                                    dict_save_name = dict_save_name,
                                    verbose = verbose )$df
    
    countries_df <- mutate(countries_df, Area = as.character(country))
  }else{
  countries_df <- NULL
  }
  
  if (compare_to_region | compare_all_regions) {
  
    if (compare_all_regions) {
      countries_region <- NULL
    }else{
      countries_region <- countries
    }
    
    regions_df <- prepare_df_plot(df = df,
                                  dict = dict,
                                  metric = metric,
                                  metric_label = metric_label,
                                  conf = conf,
                                  countries = countries_region,
                                  compare_to_region = FALSE,
                                  annual_change = annual_change,
                                  download_data = download_data,
                                  save = save,
                                  burden_save_name = burden_save_name,
                                  dict_save_name = dict_save_name,
                                  verbose = verbose )$df
    
    regions_df <- mutate(regions_df, Area = as.character(g_whoregion))
  }else{
    regions_df <- NULL
  }

  if (compare_to_world) {
    
    world_df <- prepare_df_plot(df = df,
                                dict = dict,
                                metric = metric,
                                metric_label = metric_label,
                                conf = conf,
                                countries = NULL,
                                compare_to_region = FALSE,
                                annual_change = annual_change,
                                download_data = download_data,
                                save = save,
                                burden_save_name = burden_save_name,
                                dict_save_name = dict_save_name,
                                verbose = verbose )$df
    
    world_df <- mutate(world_df, Area = "Global")
    
  }else{
    world_df <- NULL
  }
  
  
  
  if (!is.null(custom_compare)) {
    
    if (!is.list(custom_compare)) {
      stop("custom_compare must be a named list of 1 or more groups of countries")
    }
    
    if (!length(names(custom_compare)) == length(custom_compare)) {
      stop("Each group must have an associated name")
    }
    
    custom_group_df <- suppressWarnings(
      map2_dfr(custom_compare,
               names(custom_compare), ~ prepare_df_plot(df = df,
                                                        dict = dict,
                                                        metric = metric,
                                                        metric_label = metric_label,
                                                        conf = conf,
                                                        countries = .x,
                                                        compare_to_region = FALSE,
                                                        annual_change = annual_change,
                                                        download_data = download_data,
                                                        save = save,
                                                        burden_save_name = burden_save_name,
                                                        dict_save_name = dict_save_name,
                                                        verbose = verbose)$df %>% 
                 mutate(Area = .y)
               )
    )
    
  }else{
    custom_group_df <- NULL
  }
  
  
  
  ## Combine into a single data-set
  all_df <- list(countries_df, regions_df, custom_group_df, world_df) 
  all_df <- compact(all_df)
  all_df <- suppressWarnings(reduce(all_df, bind_rows))
  
  ## Filter for require years
  if (!is.null(years)) {
    if (verbose) {
      message("Filtering to use only data from: ", paste(years, collapse = ", "))
    }
    all_df <- filter(all_df, year %in% years)
  }
  ## Get list of areas
  area_list <- c(unique(countries_df$Area),
                 names(custom_compare),
                 unique(regions_df$Area)[order(unique(regions_df$Area))],
                 "Global")
  
  
  all_df <- mutate(all_df, Area = factor(Area,
                                         levels = area_list)) 
  ## Get summarised estimate for points values
  
  sim_to_metric <- names(all_df)[grepl(metric, names(all_df))]
  
  conf_present <- map_lgl(conf, ~ any(grepl(., sim_to_metric))) %>% 
    all
  
  if (!conf_present) {
    if (verbose) {
      message("Confidence intervals were not found using your specified conf, so defaulting to estimating
              only based on the point estimate.")
    }
    conf <- NULL
  }
  
  if (is.null(conf)) {
    summarised_df <- all_df %>% 
      group_by(Area, Year) %>% 
      summarise_at(.vars = metric, 
                   .funs = funs(mean = mean(., na.rm = TRUE),
                                sd = sd(., na.rm =TRUE))) %>% 
      ungroup()
  }else{
    
    metrics <- c(metric, paste0(metric, conf))
    
    ## If the data comes with confidence intervals attached
    summarised_df <- all_df %>% 
      mutate_at(.vars = metrics, 
                .funs = funs(ifelse(is.na(.), all_df[[metric]], .))) %>% 
      group_by(Area, Year) %>% 
      select_at(.vars = metrics)
      
    summarised_df$sd <- (summarised_df[[metrics[3]]] - summarised_df[[metrics[2]]]) / (2*1.96)
    
    summarised_df <- summarised_df %>%
      ungroup %>% 
      mutate(id = 1:n()) %>% 
      group_by(Area, Year, id) %>% 
      tidyr::nest() %>% 
      mutate(sample = map(data, ~ data.frame(samples = suppressWarnings(
                                                          rnorm(samples,
                                                                .[[metrics[1]]],
                                                                .$sd)
                                                         )
                                                       ) %>% 
                                   as_tibble
                                 )
                    ) %>% 
      tidyr::unnest(sample) %>% 
      group_by(Area, Year) %>% 
      summarise(mean = mean(samples, na.rm = TRUE),
                sd = sd(samples, na.rm = TRUE)) %>% 
      ungroup
  }

  ## Get upper and lower confidence intervals
  summarised_df <- summarised_df %>% 
    mutate(mean_lo = qnorm(0.025, mean, sd),
           mean_hi = qnorm(0.975, mean, sd)) %>% 
    mutate_at(.vars = c("mean", "mean_lo", "mean_hi"),
              .funs = funs(ifelse(. %in% NaN, NA, .)))
  
  if (compute_rate) {
    
   area_pop <- all_df %>% 
      group_by(Area, Year) %>% 
      summarise_at(.vars = compute_rate_with, 
                   .funs = funs(pop = sum(as.numeric(.), na.rm = TRUE)))
   
    summarised_df <- summarised_df %>% 
      left_join(area_pop) %>% 
      mutate_at(.vars = c("mean", "mean_lo", "mean_hi"), .funs = funs(. / pop * rate_scaling))
  }
  
  ## Clean up summarised results
  summarised_df <- summarised_df %>% 
    select(Area, Year, mean, mean_lo, mean_hi)
  
  if (truncate_at_zero) {
    summarised_df <- summarised_df %>% 
      mutate_at(.vars = c("mean", "mean_lo", "mean_hi"),
                .funs = funs(ifelse(. < 0, 0, .)))
  }
  
  colnames(summarised_df) <- c("area", "year", paste0(metric, c("", "_lo", "_hi")))
  
  return(summarised_df)
}
  
  
  
  