#' Plot TB Burden by Country
#'
#' @description Plot measures of TB burden by country. Currently only supports plotting of incidence rates. 
#' In development so use with caution.
#' @param df Dataframe of TB burden data, as sourced by \code{\link[getTBinR]{get_tb_burden}}.
#' @param no_countries Numeric, the number of countries to plot
#' @param facet Character string, the name of the variable to facet by.
#' @param scales Character string, see ?ggplot2::facet_wrap for details. Defaults to "fixed",
#' alternatives are "free_y", "free_x", or "free".
#'
#' @return A plot of TB Incidence Rates by Country
#' @export
#' @import ggplot2
#' @import magrittr
#' @importFrom dplyr filter
#' @examples
#' 
#' tb_burden <- get_tb_burden()
#' 
#' plot_tb_burden(tb_burden, no_countries = 9, facet = "country")
#' 
plot_tb_burden <- function(df, no_countries = NULL, 
                           facet = NULL, scales = "fixed") {
  
  if (is.null(no_countries)) {
    country_sample <- unique(df$country)
  }else{
    country_sample <- sample(unique(df$country), no_countries)
  }
  
  plot <- df %>% 
    filter(country %in% country_sample) %>% 
    ggplot(aes_string(x = "year", y = "e_inc_100k", col = "country", fill = "country")) +
    geom_line() +
    geom_ribbon(aes_string(ymin = "e_inc_100k_lo", ymax =  "e_inc_100k_hi", col = NULL), alpha = 0.2) +
    scale_colour_viridis_d(end = 0.9) +
    scale_fill_viridis_d(end = 0.9) +
    theme_minimal() +
    theme(legend.position = "none") +
    labs(x = "Year", y = "Incidence rates (per 100k population)")
  
  if (!is.null(facet)) {
    plot <- plot + 
      facet_wrap(facet, scales = scales)
  }
  
  return(plot)
}