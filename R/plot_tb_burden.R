#' Plot TB Burden by Country
#'
#' @description Plot measures of TB burden by country. Currently only supports plotting of incidence rates. 
#' In development so use with caution.
#' @param df Dataframe of TB burden data, as sourced by \code{\link[getTBinR]{get_tb_burden}}.
#' If not specified then will automatically source the WHO TB burden data, either locally if available
#' or directly from the WHO.
#' @param countries A character string specifying the countries to plot.
#' @param metric Character string specifying the metric to plot
#' @param metric_label Character string specifying the metric label to use. 
#' Defaults to \code{NULL}, which then uses the metric's definition as the label.
#' @param conf Character vector specifying the name variations to use to specify the upper
#' and lower confidence intervals. Defaults to c("_lo", "_hi"), if set to \code{NULL}
#' then no confidence intervals are shown.
#' @param facet Character string, the name of the variable to facet by.
#' @param scales Character string, see ?ggplot2::facet_wrap for details. Defaults to "fixed",
#' alternatives are "free_y", "free_x", or "free".
#' @param ... Additional parameters to pass to \code{\link[getTBinR]{get_tb_burden}}.
#' @seealso get_tb_burden search_data_dict
#' @return A plot of TB Incidence Rates by Country
#' @export
#' @import ggplot2
#' @import magrittr
#' @importFrom dplyr filter
#' @importFrom purrr map
#' @examples
#' 
#' tb_burden <- get_tb_burden()
#' 
#' sample_countries <- sample(unique(tb_burden$country), 9)
#' 
#' plot_tb_burden(tb_burden, facet = "country",
#'  countries = sample_countries, scales = "free_y")
#' 
plot_tb_burden <- function(df = NULL, metric = "e_inc_100k",
                           metric_label = NULL,
                           conf = c("_lo", "_hi"), countries = NULL, 
                           facet = NULL, scales = "fixed", ...) {
  
  if (is.null(df)) {
    df <- get_tb_burden(...)
  }
  
  if (is.null(countries)) {
    country_sample <- unique(df$country)
  }else{
    country_sample <- countries
    
    df_filt <- df %>% 
      filter(country %in% country_sample)
    
    if (nrow(df_filt) != length(countries)) {
      country_matches <- purrr::map(countries, ~grep(., df$country, fixed = FALSE))
      country_matches <- unlist(country_matches)
      
      df_filt <- df[country_matches, ]
    }
  }
  
  if(is.null(metric_label)) {
    metric_label <- search_data_dict(var = metric, verbose = FALSE)
    metric_label <- metric_label$definition
  }
  country <- NULL
  
  plot <- df_filt %>% 
    ggplot(aes_string(x = "year", y = metric, col = "country", fill = "country")) +
    geom_line()
  
  if (!is.null(conf)) {
    plot <- plot +
      geom_ribbon(aes_string(ymin = paste0(metric, conf[1]),
                             ymax =  paste0(metric, conf[2]), 
                             col = NULL), alpha = 0.2) 
  }
  
  plot <- plot +
    scale_colour_viridis_d(end = 0.9) +
    scale_fill_viridis_d(end = 0.9) +
    theme_minimal() +
    theme(legend.position = "none") +
    labs(x = "Year", y = metric_label)
  
  if (!is.null(facet)) {
    plot <- plot + 
      facet_wrap(facet, scales = scales)
  }
  
  return(plot)
}