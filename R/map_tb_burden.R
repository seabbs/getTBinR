#' Map TB Burden
#'
#' @description Map measures of TB burden by country by specifying a metric from the TB burden data.
#' Specify a country or vector of countries in order to map them (otherwise it will map all countries).
#' Various other options are available for tuning the plot further.
#' @param year Numeric, indicating the year of data to map. Defaults to 2016.
#' @param trans A character string specifying the transform to use on the mapped metric. Defaults to no 
#' transform ("identity"). Other options include log scaling ("log") and log base 10 scaling
#' ("log10"). For a complete list of options see \code{ggplot2::continous_scale}.
#' @inheritParams plot_tb_burden
#' @seealso plot_tb_burden plot_tb_burden_overview get_tb_burden search_data_dict
#' @return A plot of TB Incidence Rates by Country
#' @export
#' @import ggplot2
#' @importFrom ggthemes theme_map
#' @import magrittr
#' @importFrom dplyr filter left_join rename_at funs
#' @importFrom ggthemes theme_map
#' @importFrom purrr map
#' @importFrom plotly ggplotly
#' @examples
#' 
#' map_tb_burden(download_data = TRUE, save = TRUE)
#' 
map_tb_burden <- function(df = NULL, dict = NULL,
                           metric = "e_inc_100k",
                           metric_label = NULL,
                           countries = NULL,
                           compare_to_region = FALSE,
                           facet = NULL, year = 2016,
                           trans = "identity",
                           interactive = FALSE, 
                           download_data = FALSE,
                           save = FALSE,
                           burden_save_name = "TB_burden",
                           dict_save_name = "TB_data_dict",
                           path = "data-raw", 
                           verbose = TRUE, ...) {

  sel_year <- year
  
  df_prep <- prepare_df_plot(df = df, dict = dict,
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
  
  ## Bind in world data
  if (trans != "identity") {
    df_prep$metric_label <- paste0(df_prep$metric_label, "(", trans, ")")
  }
  
  df_prep$df <- df_prep$df %>% 
    left_join(getTBinR::who_shapefile, c("iso3" = "id")) %>% 
    filter(year %in% sel_year) %>% 
    rename_at(.vars = metric, .funs = funs(df_prep$metric_label))
  
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
    scale_fill_viridis_c(end = 0.95, trans = trans, direction = -1) +
    coord_equal() +
    ggthemes::theme_map() +
    theme(legend.position = "bottom") 
  
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