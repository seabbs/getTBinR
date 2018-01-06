#' Map TB Burden
#'
#' @description Map measures of TB burden by country by specifying a metric from the TB burden data.
#' Specify a country or vector of countries in order to map them (the default is to map all countries).
#' Various other options are available for tuning the plot further.
#' @param year Numeric, indicating the year of data to map. Defaults to 2016.
#' @inheritParams plot_tb_burden
#' @seealso plot_tb_burden plot_tb_burden_overview get_tb_burden search_data_dict
#' @return A plot of TB Incidence Rates by Country
#' @export
#' @import ggplot2
#' @importFrom viridis scale_fill_viridis
#' @importFrom ggthemes theme_map
#' @import magrittr
#' @importFrom dplyr filter left_join
#' @importFrom ggthemes theme_map
#' @importFrom purrr map
#' @importFrom plotly ggplotly
#' @importFrom scales percent
#' @examples
#' 
#' ## Map raw incidence rates
#' map_tb_burden(download_data = TRUE, save = TRUE)
#' 
#' ## Map log scaled incidence rates
#' map_tb_burden(trans = "log")
#' 
#' ## Find variables relating to mortality in the WHO dataset
#' search_data_dict(def = "mortality")
#' 
#' ## Map mortality rates (exc HIV) - without progress messages
#' map_tb_burden(metric = "e_mort_exc_tbhiv_100k", verbose = FALSE)
#' 
map_tb_burden <- function(df = NULL, dict = NULL,
                           metric = "e_inc_100k",
                           metric_label = NULL,
                           countries = NULL,
                           compare_to_region = FALSE,
                           facet = NULL, year = 2016,
                           annual_change = FALSE,
                           trans = "identity",
                           interactive = FALSE, 
                           download_data = FALSE,
                           save = FALSE,
                           burden_save_name = "TB_burden",
                           dict_save_name = "TB_data_dict",
                           verbose = TRUE, ...) {

  sel_year <- year
  
  df_prep <- prepare_df_plot(df = df, dict = dict,
                             metric = metric,
                             metric_label = metric_label,
                             countries = countries,
                             compare_to_region = compare_to_region,
                             facet = facet,
                             download_data = download_data,
                             trans = trans,
                             annual_change = annual_change,
                             save = save,
                             burden_save_name = burden_save_name,
                             dict_save_name = dict_save_name,
                             verbose = verbose)
  
  ## Bind in world data
  df_prep$df <- df_prep$df %>% 
    left_join(getTBinR::who_shapefile, c("iso3" = "id")) %>% 
    filter(year %in% sel_year)
  
   names(df_prep$df)[names(df_prep$df) == metric] <- df_prep$metric_label
   
   country <- NULL
  
  if (compare_to_region) {
    if (length(countries) == 1) {
      df_prep$facet <- NULL
    }
  }
  
  plot <- ggplot(df_prep$df, 
                 aes_string(x = "long", 
                            y = "lat", 
                            text = "country",
                            fill = paste0("`",df_prep$metric_label, "`"))) +
    geom_polygon(aes_string(group = "group")) + 
    coord_equal() +
    ggthemes::theme_map() +
    theme(legend.position = "bottom") 
  
  if (annual_change) {
    plot <- plot +
      scale_fill_viridis(end = 0.95, trans = trans, 
                         direction = -1, discrete = FALSE,
                         labels = percent)
  }else{
    plot <- plot +
      scale_fill_viridis(end = 0.95, trans = trans, 
                         direction = -1, discrete = FALSE)
  }
  if (!is.null(df_prep$facet)) {
    plot <- plot + 
      facet_wrap(df_prep$facet, scales = "fixed")
  }
  
  if (interactive) {
    plot <- plot +
      theme(legend.position = "none")
    
    plot <- plotly::ggplotly(plot)
  }
  
  return(plot)
}