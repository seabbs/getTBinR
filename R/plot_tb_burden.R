#' Plot TB Burden by Country
#'
#' @description Plot measures of TB burden by country by specifying a metric from the TB burden data.
#' Specify a country or vector of countries in order to plot them (by default plots all countries).
#' Various other options are available for tuning the plot further.
#' @param conf Character vector specifying the name variations to use to specify the upper
#' and lower confidence intervals. Defaults to c("_lo", "_hi"), if set to \code{NULL}
#' then no confidence intervals are shown. When \code{annual_change = TRUE} the confidence 
#' intervals represent the annual percentage change in the metrics confidence intervals.
#' @param scales Character string, see ?ggplot2::facet_wrap for details. Defaults to "fixed",
#' alternatives are "free_y", "free_x", or "free".
#' @param smooth Logical, defaults to \code{FALSE}. Should the data be smoothed (using `ggplot2::geom_smooth`)
#' prior to plotting. If set to \code{TRUE} then the confidence intervals shown are derived from the smooth
#' and do not represent the underlying uncertainty in the data.
#' @param interactive Logical, defaults to \code{FALSE}. If \code{TRUE} then an interactive plot is 
#' returned.
#' @param viridis_palette Character string indicating the \code{viridis} colour palette to use. Defaults
#' to "viridis". Options include "cividis", "magma", "inferno", "plasma", and "viridis". For additional details 
#' see \code{\link[viridis]{viridis_pal}} for additional details.
#' @param viridis_direction Numeric, indicating the direction for the colour palette (1 or -1), defaults to -1. 
#' See \code{\link[viridis]{scale_color_viridis}} for additional details.
#' @param viridis_end Numeric between 0 and 1, defaults to 0.9. The end point of the viridis scale to use.
#' #' See \code{\link[viridis]{scale_color_viridis}} for additional details.
#' @inheritParams prepare_df_plot 
#' @seealso get_tb_burden search_data_dict
#' @return A plot of TB Incidence Rates by Country
#' @export
#' @import ggplot2
#' @import magrittr
#' @importFrom dplyr filter
#' @importFrom scales percent
#' @importFrom purrr map
#' @importFrom plotly ggplotly style
#' @importFrom viridis  scale_fill_viridis  scale_colour_viridis
#' @examples
#' 
#' ## Get the WHO TB burden data and the data dictionary
#' tb_burden <- get_tb_burden()
#' dict <- get_data_dict()
#' 
#' ## Get a random sample of 9 countries
#' sample_countries <- sample(unique(tb_burden$country), 9)
#' 
#' ## Plot incidence rates in these countries
#' plot_tb_burden(df = tb_burden, dict = dict, facet = "country", countries = sample_countries)
#' 
#'\dontrun{
#' ## Plot smoothed incidence rates in these countries
#' plot_tb_burden(df = tb_burden, dict = dict, facet = "country", smooth = TRUE,
#'                countries = sample_countries)
#' ## Use data caching to plot incidence rates with free y scales
#' plot_tb_burden(facet = "country", countries = sample_countries, scales = "free_y")
#'  
#' ## Plot annual percentage change in incidence rates in selected countries
#' plot_tb_burden(df = tb_burden, dict = dict, facet = "country", scales = "free_y", 
#'                countries = sample_countries, annual_change = TRUE, conf = NULL)
#'                
#' ## Find variables relating to mortality in the WHO dataset
#' search_data_dict(def = "mortality")
#' ## Plot mortality rates (exc HIV) - without progress messages
#' plot_tb_burden(metric = "e_mort_exc_tbhiv_100k", facet = "country", 
#'                countries = sample_countries, scales = "free_y", verbose = FALSE)
#'}  
plot_tb_burden <- function(df = NULL, dict = NULL, 
                           metric = "e_inc_100k",
                           metric_label = NULL,
                           smooth = FALSE,
                           conf = c("_lo", "_hi"), countries = NULL,
                           years = NULL,
                           compare_to_region = FALSE,
                           facet = NULL, annual_change = FALSE,
                           trans = "identity",
                           scales = "fixed",
                           interactive = FALSE,
                           download_data = TRUE,
                           save = TRUE,
                           burden_save_name = "TB_burden",
                           dict_save_name = "TB_data_dict",
                           viridis_palette = "viridis",
                           viridis_direction = -1,
                           viridis_end = 0.9,
                           verbose = TRUE, ...) {

  df_prep <- prepare_df_plot(df = df,
                             dict = dict,
                             metric = metric,
                             conf = conf,
                             metric_label = metric_label,
                             countries = countries,
                             years = years,
                             compare_to_region = compare_to_region,
                             facet = facet,
                             trans = trans,
                             annual_change = annual_change,
                             download_data = download_data,
                             save = save,
                             burden_save_name = burden_save_name,
                             dict_save_name = dict_save_name,
                             verbose = verbose)
  
  country <- NULL
  
  plot <- ggplot(df_prep$df, aes_string(x = "year", 
                                        y = paste0("`", df_prep$metric_label, "`"),
                                        col = "country", fill = "country"))
  
  if (smooth) {
    plot <- plot + 
      geom_smooth(se = !is.null(conf), size = 1.2)
    
    conf <- NULL
    
  }else{
    plot <- plot + 
      geom_line(na.rm = TRUE, size = 1.1)
  }

  
  if (!is.null(conf)) {
    plot <- plot +
      geom_ribbon(aes_string(ymin = paste0(metric, conf[1]),
                             ymax =  paste0(metric, conf[2]), 
                             col = NULL), alpha = 0.2, na.rm = TRUE) 
  }
  
  plot <- plot +
    scale_colour_viridis(end = viridis_end, direction = viridis_direction, discrete = TRUE,
                         option = viridis_palette) +
    scale_fill_viridis(end = viridis_end, direction = viridis_direction, discrete = TRUE,
                       option = viridis_palette) +
    theme_minimal() +
    theme(legend.position = "none") +
    labs(x = "Year", y = df_prep$metric_label,
         caption = "Source: World Health Organisation")
  
  if (annual_change) {
    plot <- plot +
      scale_y_continuous(labels = percent, trans = trans)
  }else{
    plot <- plot + 
      scale_y_continuous(trans = trans)
  }
  
  if (!is.null(df_prep$facet)) {
    plot <- plot + 
      facet_wrap(df_prep$facet, scales = scales)
  }
  
  if (interactive) {
    plot <- ggplotly(plot)  %>% 
      style(hoverlabel = list(bgcolor = "white"), hoveron = "fill")
  }
  
  return(plot)
}
