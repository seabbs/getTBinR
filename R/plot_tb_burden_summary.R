#' Plot Summaries of TB Burden - By Region, Globally and for Custom Groups
#'
#'
#' @description Plot summaries  of TB burden metrics by region, globally, and for custom groupings. For variables with 
#' uncertainty represented by confidence intervals bootstrapping can be used (assuming a normal distribution) to 
#' include this in any estimated summary measures. Currently four statistics are supported; the mean (with 
#' 95\% confidence intervals) and the median (with 95\% interquartile range), rates and proportions.
#' @inherit  plot_tb_burden
#' @inheritParams summarise_tb_burden
#' @seealso search_data_dict plot_tb_burden summarise_tb_burden
#' @return A plot of TB Incidence Rates by Country
#' @export
#'
#' @examples
#' 
#' ## Get an overview of incidence rates regionally and globally compared to the UK
#' plot_tb_burden_summary(metric = "e_inc_num",
#'                        metric_label = "e_inc_100k",
#'                        stat = "rate",
#'                        countries = "United Kingdom", 
#'                        compare_to_world = TRUE, 
#'                        compare_all_regions = TRUE,
#'                        verbose = FALSE,
#'                        scales = "free_y",
#'                        facet = "Area") 
#' \dontrun{
#' 
#' 
#' ## Get summary data for the UK, Europe and the world
#' ## Bootstrapping CI's 
#' plot_tb_burden_summary(metric = "e_inc_num",
#'                        samples = 100,
#'                        stat = "mean",
#'                        countries = "United Kingdom", 
#'                        compare_to_world = TRUE, 
#'                        compare_to_region = TRUE,
#'                        verbose = FALSE,
#'                        facet = "Area",
#'                        scales = "free_y")
#'                     
#'}                     
plot_tb_burden_summary <- function(df = NULL,
                                   dict = NULL, 
                                   metric = "e_inc_100k",
                                   metric_to_use_as_label = NULL,
                                   metric_label = NULL,
                                   conf = c("_lo", "_hi"),
                                   years = NULL,
                                   samples = 1000,
                                   countries = NULL,
                                   compare_to_region = FALSE,
                                   compare_to_world = FALSE,
                                   custom_compare = NULL,
                                   compare_all_regions = FALSE,
                                   stat = "mean",
                                   denom = "e_pop_num",
                                   rate_scale = 1e5,
                                   denominator = NULL,
                                   truncate_at_zero = TRUE,
                                   annual_change = FALSE,
                                   smooth = FALSE,
                                   facet = NULL, 
                                   trans = "identity",
                                   scales = "fixed",
                                   interactive = FALSE,
                                   viridis_palette = "viridis",
                                   viridis_direction = -1,
                                   viridis_end = 0.9,
                                   download_data = TRUE,
                                   save = TRUE,
                                   burden_save_name = "TB_burden",
                                   dict_save_name = "TB_data_dict",
                                   verbose = TRUE){
  
  
  if (is.null(metric_to_use_as_label)) {
    metric_to_use_as_label <- metric
  }
  
  if (is.null(metric_label)) {
    metric_label <- getTBinR::search_data_dict(var = metric_to_use_as_label, 
                                     dict = dict,
                                     download_data = download_data,
                                     save = save,
                                     dict_save_name = dict_save_name,
                                     verbose = verbose)
    
    metric_label <- metric_label$definition
  }

  sum_df <- summarise_tb_burden(df = df,
                                dict = dict, 
                                metric = metric,
                                metric_label = metric_label,
                                conf = conf,
                                years = years,
                                samples = samples,
                                countries = countries,
                                compare_to_region = compare_to_region,
                                compare_to_world = compare_to_world,
                                custom_compare = custom_compare,
                                compare_all_regions = compare_all_regions,
                                stat = stat,
                                denom = denom,
                                rate_scale = rate_scale,
                                denominator = denominator,
                                truncate_at_zero = truncate_at_zero,
                                annual_change = annual_change,
                                download_data = download_data,
                                save = save,
                                burden_save_name = burden_save_name,
                                dict_save_name = dict_save_name,
                                verbose = verbose) %>% 
    rename(Area = area)
  
  
  
  area <- NULL
  
  plot <- ggplot(sum_df, aes_string(x = "year", 
                                    y = paste0("`", metric, "`"),
                                    col = "Area", fill = "Area"))
  
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
    theme(legend.position = "top") +
    labs(x = "Year", y = metric_label,
         caption = "Source: World Health Organisation")
  
  if (annual_change) {
    plot <- plot +
      scale_y_continuous(labels = percent, trans = trans)
  }else{
    plot <- plot + 
      scale_y_continuous(trans = trans)
  }
  
  if (!is.null(facet)) {
    plot <- plot + 
      facet_wrap(facet, scales = scales)
  }
  
  if (interactive) {
    plot <- ggplotly(plot)  %>% 
      style(hoverlabel = list(bgcolor = "white"), hoveron = "fill")
  }
  
  return(plot)
}