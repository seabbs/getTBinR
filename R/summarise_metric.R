#' Summarise a TB Metric - A Quick Look Summary
#'
#'
#' @description This function provides a curated list of summary measures for a given TB metric in countries of interest.
#'  It can been used to facilitate reporting and is used extensively in the TB report included in the package
#'  (see \code{\link[getTBinR]{render_country_report}}). It outputs the most recent year of data in the target country for
#'  a given metric, along with the year this data was recorded, the regional and global rank and the average change 
#'  in the last decade. For a more customisable metric summary see \code{\link[getTBinR]{summarise_tb_burden}} as a starting point.
#' @param conf Character vector specifying the name variations to use to specify the upper
#' and lower confidence intervals. Defaults to c("_lo", "_hi"), if set to \code{NULL}
#' then no confidence intervals are shown.
#' @inheritParams summarise_tb_burden
#' @inheritParams  prepare_df_plot
#' @importFrom dplyr filter select mutate arrange pull summarise first desc
#' @importFrom tibble tibble
#' @importFrom tidyr drop_na
#' @importFrom rlang sym quo_name !!
#' @importFrom purrr map_dfr map_dfc
#' @return A tibble containing the name of the target country, the year of the most recent data available, the most recent 
#' value for the metric, the regional rank, the global rank and the average change in the previous decade.
#' @export
#'
#' @examples
#' 
#' ## Get a summary of TB incidence rates for the united kingdom and germany
#' summarise_metric(metric = "e_inc_100k", countries = c("United Kingdom", "Germany"))
#' 
#' ## Get a summary of case detection rates in France
#' summarise_metric(metric = "c_cdr", countries = "France")
#' 
#' ## Get a summary of case detection rates in France - without confidence intervals
#' summarise_metric(metric = "c_cdr", countries = "France", conf = NULL)
#' 
#' ## Provide a dataset and get summary measures from it. 
#' tb <- get_tb_burden()
#' summarise_metric(df = tb, metric = "c_cdr", countries = "France")
summarise_metric <- function(df = NULL,  metric = NULL,
                             countries = NULL, conf = c("_lo", "_hi"),
                             download_data = TRUE, save = TRUE, 
                             verbose = TRUE, ...) {
  
  
  if (is.null(df)) {
    df <- get_tb_burden(download_data = download_data,
                        save = save,
                        burden_save_name = burden_save_name,
                        verbose = verbose, ...)
  }
  
  ##  Set up metric with confidence intervals
  metric <- sym(metric)
  metric_lo <- sym(paste0(quo_name(metric), conf[1]))
  metric_hi <- sym(paste0(quo_name(metric), conf[2]))
  
  internal_summarise_metric <- function(target_country) {
    
    country <- NULL; year <- NULL; g_whoregion <- NULL; change <- NULL;
    . <- NULL
    target_country_in_df <- df$country[grepl(target_country, df$country)] %>% 
      unique %>% 
      first
    
    ## Filter for the country of interest
    country_df <- df %>% 
      filter(country %in% target_country_in_df) %>% 
      mutate(country = target_country)
    
    ## Most up to date year of incidence data
    recent_inc <- country_df %>% 
      drop_na(!!metric) %>% 
      filter(year == max(year))
    
    if(!is.null(conf)){
      recent_inc <- recent_inc %>% 
        select(!!metric, !!metric_lo, !!metric_hi, year, g_whoregion) %>% 
        mutate(inc_rate = paste0(!!metric, " (", !!metric_lo, " - ", !!metric_hi, ")"))
    }else{
    recent_inc <- recent_inc %>% 
      mutate(inc_rate = !!metric)
    }

    
    if (nrow(recent_inc) >= 1) {
      ## Country rank
      ranked_countries_inc <- df %>% 
        filter(year == recent_inc$year) %>% 
        arrange(desc(!!metric)) %>% 
        mutate(rank = 1:n())
      
      ## World rank
      target_rank_world <- ranked_countries_inc %>% 
        filter(country == target_country_in_df) %>% 
        pull(rank)
      
      ## Region rank
      target_rank_region <- ranked_countries_inc %>% 
        filter(g_whoregion %in% recent_inc$g_whoregion) %>% 
        mutate(rank = 1:n()) %>% 
        filter(country == target_country_in_df) %>%
        pull(rank)
      
      
      ## Summarise annual change
      country_change <- summarise_tb_burden(metric = quo_name(metric),
                                            stat = "mean",
                                            countries = target_country,
                                            compare_to_region = FALSE,
                                            compare_to_world = FALSE,
                                            compare_all_regions = FALSE,
                                            annual_change = TRUE,
                                            verbose = FALSE) %>% 
        filter(year > (max(year) - 10)) %>% 
        summarise(change = mean(!!metric, na.rm = FALSE)) %>%
        mutate(change = round(change * 100, 1) %>% 
                 paste0(., "%")) %>% 
        pull(change)
      
      out <- tibble(country = target_country,
                    year = recent_inc$year[1], 
                    metric = recent_inc$inc_rate[1],
                    world_rank =  target_rank_world, 
                    region_rank = target_rank_region,
                    avg_change = country_change)
    }else{
    out <- tibble(country = target_country,
                  year = NA, 
                  metric = NA,
                  world_rank =  NA, 
                  region_rank = NA,
                  avg_change = NA)
    }
   
    
 return(out)
  }
  
  out <- map_dfr(countries, internal_summarise_metric)
  
 
  out <- map_dfc(out, ~ ifelse(is.na(.), "(Missing)", .))
  
  return(out)
}