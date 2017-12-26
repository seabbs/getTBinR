#' Plot an overview of TB Burden for Multiple Countries
#' 
#' @description This functions returns a dot plot for a given metric over a specified
#' list of countries. If \code{compare_to_region} is specified then a given country will
#' be compared to others in its region. This enables the user to rapidly understand trends in
#' Tuberculosis over time and the progress towards global elimination.
#' @inheritParams plot_tb_burden
#' @seealso get_tb_burden search_data_dict
#' @return A dot plot of any numeric metric by country.
#' @export 
#' @import ggplot2
#' @importFrom plotly ggplotly
#' @examples
#' 
#' plot_tb_burden_overview(countries = c("United Kingdom", "Botswana"), compare_to_region = TRUE)
#' 
plot_tb_burden_overview <- function(df = NULL, metric = "e_inc_100k",
                           metric_label = NULL,
                           countries = NULL,
                           compare_to_region = FALSE,
                           facet = NULL, scales = "free_y",
                           interactive = FALSE, ...) {
 
  df_prep <- prepare_df_plot(df = df,
                             metric = metric,
                             metric_label = metric_label,
                             countries = countries,
                             compare_to_region = compare_to_region,
                             facet = facet)
  country <- NULL
  
  plot <- ggplot(df_prep$df, aes_string(x = "country", y = metric, col = "Year")) +
    geom_point(alpha = 0.6, size = 1.5)
  
  plot <- plot +
    scale_colour_viridis_c(end = 0.9, direction = -1) +
    theme_minimal() +
    labs(x = "Country", y = df_prep$metric_label) + 
    coord_flip()
  
  if (!is.null(df_prep$facet)) {
    plot <- plot + 
      facet_wrap(df_prep$facet, scales = scales)
  }
  
  if (interactive) {
    plot <- plotly::ggplotly(plot)
  }
  
  return(plot)
}