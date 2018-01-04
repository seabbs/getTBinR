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
#' @importFrom viridis scale_colour_viridis
#' @importFrom plotly ggplotly
#' @examples
#' 
#' ## Plot incidence rates over time for both the United Kingdom and Botswana
#' plot_tb_burden_overview(countries = c("United Kingdom", "Botswana"), 
#'                         compare_to_region = FALSE, download_data = TRUE, save = TRUE)
#'                         
#' ## Compare incidence rates in the UK and Botswana to incidence rates in their regions
#' plot_tb_burden_overview(countries = c("United Kingdom", "Botswana"), 
#'                         compare_to_region = TRUE)
#'    
#' ## Find variables relating to mortality in the WHO dataset
#' search_data_dict(def = "mortality")
#'                    
#' ## Compare mortality rates (exc HIV) in the UK and Botswana to mortality rates in their regions
#' ## Do not show progress messages
#' plot_tb_burden_overview(metric = "e_mort_exc_tbhiv_100k",
#'                         countries = c("United Kingdom", "Botswana"), 
#'                         compare_to_region = TRUE, verbose = FALSE)
plot_tb_burden_overview <- function(df = NULL, dict = NULL,
                                    metric = "e_inc_100k",
                                   metric_label = NULL,
                                   countries = NULL,
                                   compare_to_region = FALSE,
                                   facet = NULL, scales = "free_y",
                                   interactive = FALSE, 
                                   download_data = FALSE,
                                   save = FALSE,
                                   burden_save_name = "TB_burden",
                                   dict_save_name = "TB_data_dict",
                                   path = "data-raw", 
                                   verbose = TRUE, 
                                   ...) {
 
  df_prep <- prepare_df_plot(df = df,
                             dict = dict,
                             metric = metric,
                             metric_label = metric_label,
                             countries = countries,
                             compare_to_region = compare_to_region,
                             facet = facet,
                             download_data = download_data,
                             save = save,
                             burden_save_name = burden_save_name,
                             dict_save_name = dict_save_name,
                             path = path, 
                             verbose = verbose)
  country <- NULL
  
  plot <- ggplot(df_prep$df, aes_string(x = "country", y = metric, col = "Year")) +
    geom_point(alpha = 0.6, size = 1.5)
  
  plot <- plot +
    scale_colour_viridis(end = 0.9, direction = -1, discrete = FALSE) +
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