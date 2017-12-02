#' Generic Function to Prepare TB Burden Data for Plotting
#'
#' @description This function is used internally by \code{\link[getTBinR]{plot_tb_burden}}
#' and \code{\link[getTBinR]{plot_tb_burden_overview}} to prepare data for plotting.
#' @param df Dataframe of TB burden data, as sourced by \code{\link[getTBinR]{get_tb_burden}}.
#' If not specified then will automatically source the WHO TB burden data, either locally if available
#' or directly from the WHO.
#' @param countries A character string specifying the countries to plot.
#' @param metric Character string specifying the metric to plot
#' @param metric_label Character string specifying the metric label to use. 
#' @param facet Character string, the name of the variable to facet by.
#' @param compare_to_region Logical, defaults to \code{FALSE}. If \code{TRUE} all
#' countries that share a region with those listed in \code{countries} will be plotted.
#' Note that this will override settings for \code{facet}, unless it is set to "country".
#' @param ... Additional parameters to pass to \code{\link[getTBinR]{get_tb_burden}}.
#' @import magrittr
#' @importFrom dplyr filter arrange_at mutate pull
#' @importFrom purrr map
#' @seealso plot_tb_burden plot_tb_burden_overview
#' @return A list containing 3 elements, the dataframe to plot, the facet to use and
#' the label to assign to the metric axis.
#' @export
#'
#' @examples
#' 
#' prepare_df_plot(countries = "Guinea")
#' 
prepare_df_plot <- function(df = NULL,
                            metric = "e_inc_100k",
                            metric_label = NULL,
                            countries = NULL,
                            compare_to_region = FALSE,
                            facet = NULL,
                            ...){

  country <- NULL
  year <- NULL
  g_whoregion <- NULL
  
  if (is.null(df)) {
    df <- get_tb_burden(...)
  }
  
  if (is.null(countries)) {
    country_sample <- unique(df$country)
    
    df_filt <- df
  }else{
    country_sample <- countries
    
    df_filt <- df %>% 
      dplyr::filter(country %in% country_sample)
    
    if (length(unique(df_filt$country)) != length(countries)) {
      country_matches <- purrr::map(countries, ~grep(., df$country, fixed = FALSE))
      country_matches <- unlist(country_matches)
      
      df_filt <- df[country_matches, ]
    }
  }
  
  if (compare_to_region) {
    if (!(facet %in% "country") || is.null(facet)) {
      facet <- "g_whoregion"
    }
    
    df_filt <- df %>% 
      filter(g_whoregion %in% unique(df_filt$g_whoregion))
  }
  
  if(is.null(metric_label)) {
    metric_label <- search_data_dict(var = metric, verbose = FALSE)
    metric_label <- metric_label$definition
  }
  
  df_filt <- df_filt %>% 
    mutate(country = country %>% 
             factor(levels = df_filt %>% 
                      arrange_at(.vars = metric) %>% 
                      pull(country) %>% 
                      unique)) %>% 
    mutate(Year = year)
  
  df_prep_list <- list(df_filt, facet, metric_label)
  names(df_prep_list) <- c("df", "facet", "metric_label")
  
  return(df_prep_list)
}