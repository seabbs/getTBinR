#' Generic Function to Prepare TB Burden Data for Plotting
#'
#' @description This function is used internally by \code{\link[getTBinR]{plot_tb_burden}}
#' and \code{\link[getTBinR]{plot_tb_burden_overview}} to prepare data for plotting.
#' @param df Dataframe of TB burden data, as sourced by \code{\link[getTBinR]{get_tb_burden}}.
#' If not specified then will source the WHO TB burden data, either locally if available
#' or directly from the WHO (if \code{download_data = TRUE}).
#' @param countries A character string specifying the countries to plot.
#' @param metric Character string specifying the metric to plot
#' @param metric_label Character string specifying the metric label to use. 
#' @param facet Character string, the name of the variable to facet by.
#' @param annual_change Logical, defaults to \code{FALSE}. If \code{TRUE} then the
#' percentage annual change is computed for the specified metric.
#' @param trans A character string specifying the transform to use on the specified metric. Defaults to no 
#' transform ("identity"). Other options include log scaling ("log") and log base 10 scaling
#' ("log10"). For a complete list of options see \code{ggplot2::continous_scale}.
#' @param compare_to_region Logical, defaults to \code{FALSE}. If \code{TRUE} all
#' countries that share a region with those listed in \code{countries} will be plotted.
#' Note that this will override settings for \code{facet}, unless it is set to "country".
#' @param conf Character vector specifying the name variations to use to specify the upper
#' and lower confidence intervals. Defaults to \code{NULL} for which no confidence intervals 
#' are used. Used by \code{annual_change}.
#' @param ... Additional parameters to pass to \code{\link[getTBinR]{get_tb_burden}}.
#' @inheritParams get_tb_burden
#' @inheritParams search_data_dict
#' @import magrittr
#' @importFrom dplyr filter arrange_at mutate mutate_at pull funs lag group_by ungroup arrange slice
#' @importFrom purrr map
#' @seealso plot_tb_burden plot_tb_burden_overview
#' @return A list containing 3 elements, the dataframe to plot, the facet to use and
#' the label to assign to the metric axis.
#' @export
#'
#' @examples
#' 
#' prepare_df_plot(countries = "Guinea", download_data = TRUE, save = TRUE)
#' 
prepare_df_plot <- function(df = NULL,
                            dict = NULL,
                            metric = "e_inc_100k",
                            conf = NULL,
                            metric_label = NULL,
                            countries = NULL,
                            compare_to_region = FALSE,
                            facet = NULL,
                            annual_change = FALSE,
                            trans = "identity",
                            download_data = FALSE, save = FALSE, 
                            burden_save_name = "TB_burden",
                            dict_save_name = "TB_data_dict",
                            verbose = TRUE,
                            ...){

  country <- NULL
  year <- NULL
  g_whoregion <- NULL
  
  if (is.null(df)) {
    df <- get_tb_burden(download_data = download_data,
                        save = save,
                        burden_save_name = burden_save_name,
                        verbose = verbose, ...)
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
    metric_label <- search_data_dict(var = metric, 
                                     dict = dict,
                                     download_data = download_data,
                                     save = save,
                                     dict_save_name = dict_save_name,
                                     verbose = verbose)
    
    metric_label <- metric_label$definition
  }
  
  if (annual_change) {
    
    metrics <- metric
    
    if (!is.null(conf)) {
      metrics <- c(metrics, paste0(metric, conf))
    }
    
    . <- NULL
    
    df_filt <- df_filt %>% 
      group_by(country) %>% 
      mutate_at(.vars = metrics, .funs = funs((lag(.) - .) / lag(.))) %>% 
      arrange(year) %>% 
      slice(-1) %>% 
      ungroup
    
    metric_label <- paste0("Percentage annual change: ", metric_label)
  }
  
  if (trans != "identity") {
    metric_label <- paste0(metric_label, " (", trans, ")")
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