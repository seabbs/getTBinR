#' Map TB Burden
#'
#' @description Map measures of TB burden by country by specifying a metric from the TB burden data.
#' Specify a country or vector of countries in order to map them (the default is to map all countries).
#' Various other options are available for tuning the plot further.
#' @param year Numeric, indicating the year of data to map. Defaults to the latest year in the data.
#' If \code{interactive = TRUE} then multiple years may be passed as a vector, the result will then be animated over years.
#' @param fill_var_type A character string, defaults to \code{NULL}. To set the fill variable type to be
#' discrete use "discrete" and to be continuous use "continuous".
#' @param legend Character string, defaults to `"bottom"`. Position of the legend see `?ggplot2::theme` for defaults but known
#' options are: `"none"`, `"top"`, `"right"` and `"bottom"`.
#' @inheritParams plot_tb_burden
#' @seealso plot_tb_burden plot_tb_burden_overview get_tb_burden search_data_dict
#' @return A plot of TB Incidence Rates by Country
#' @export
#' @importFrom ggplot2 ggplot aes geom_polygon coord_equal theme labs facet_wrap
#' @importFrom rlang .data
#' @importFrom viridis scale_fill_viridis
#' @importFrom ggthemes theme_map
#' @import magrittr
#' @importFrom dplyr filter left_join rename
#' @importFrom ggthemes theme_map
#' @importFrom purrr map
#' @importFrom plotly ggplotly style
#' @importFrom scales percent
#' @examples
#'
#' ## Map raw incidence rates
#' map_tb_burden()
#' \dontrun{
#' #' ## Map raw incidence rates
#' map_tb_burden(year = 2014:2017, facet = "year")
#'
#' ## Map log10 scaled incidence rates
#' map_tb_burden(trans = "log10")
#'
#' ## Map percentage annual change in incidence rates
#' map_tb_burden(annual_change = TRUE)
#'
#' ## Find variables relating to mortality in the WHO dataset
#' search_data_dict(def = "mortality")
#'
#' ## Map mortality rates (exc HIV) - without progress messages
#' map_tb_burden(metric = "e_mort_exc_tbhiv_100k", verbose = FALSE)
#'
#' ## Can also use a discrete metric if one is available
#' map_tb_burden(metric = "g_whoregion", metric_label = "WHO world region")
#' }
map_tb_burden <- function(df = NULL, dict = NULL,
                          metric = "e_inc_100k",
                          metric_label = NULL,
                          fill_var_type = NULL,
                          countries = NULL,
                          compare_to_region = FALSE,
                          facet = NULL,
                          legend = "bottom",
                          year = NULL,
                          annual_change = FALSE,
                          trans = "identity",
                          interactive = FALSE,
                          download_data = TRUE,
                          save = TRUE,
                          viridis_palette = "viridis",
                          viridis_direction = -1,
                          viridis_end = 0.9,
                          verbose = FALSE, ...) {
  long <- NULL
  lat <- NULL
  Year <- NULL
  if (!is.null(facet) && facet %in% "year") {
    facet <- "Year"
  }

  if (!interactive && length(year) > 1 && !facet %in% "Year") {
    stop("When not producing interactive plots only a single year of data must be used. 
         Please specify a single year (i.e 2016). Alternatively facet over year using facet = 'year'")
  }

  df_prep <- prepare_df_plot(
    df = df, dict = dict,
    metric = metric,
    metric_label = metric_label,
    countries = countries,
    years = year,
    compare_to_region = compare_to_region,
    facet = facet,
    download_data = download_data,
    trans = trans,
    annual_change = annual_change,
    save = save,
    verbose = verbose,
    ...
  )

  ## Guess at variable type for filling
  if (is.null(fill_var_type)) {
    if (is.numeric(df_prep$df[[metric]])) {
      fill_var_type <- FALSE
    } else {
      fill_var_type <- TRUE
    }
  } else {
    if (fill_var_type %in% "discrete") {
      fill_var_type <- TRUE
    } else if (fill_var_type %in% "continuous") {
      fill_var_type <- FALSE
    } else {
      stop('fill_var_type must be either NULL, "discrete" or "continuous"')
    }
  }
  ## Get latest data year
  if (is.null(year)) {
    sel_year <- df_prep$df$year %>%
      max()
  } else {
    sel_year <- year
  }

  ## Bind in world data
  df_prep$df <- df_prep$df %>%
    left_join(getTBinR::who_shapefile, c("iso3" = "id")) %>%
    filter(year %in% sel_year)

  country <- NULL
  group <- NULL

  if (compare_to_region) {
    if (length(countries) == 1) {
      df_prep$facet <- NULL
    }
  }

  ## Check if variable is discrete or continous
  plot <- ggplot(
    df_prep$df,
    aes(
      x = long,
      y = lat,
      text = country,
      fill = .data[[metric]],
      key = country,
      frame = Year
    )
  ) +
    geom_polygon(aes(group = group),
      color = "black", size = 0.3, na.rm = TRUE
    ) +
    coord_equal() +
    ggthemes::theme_map() +
    theme(legend.position = legend) +
    labs(
      fill = df_prep$metric_label,
      caption = "Source: World Health Organization"
    )

  if (annual_change) {
    if (fill_var_type) {
      plot <- plot +
        scale_fill_viridis(
          end = viridis_end,
          direction = viridis_direction, discrete = TRUE,
          labels = percent,
          option = viridis_palette
        )
    } else {
      plot <- plot +
        scale_fill_viridis(
          end = viridis_end, trans = trans,
          direction = viridis_direction, discrete = FALSE,
          labels = percent,
          option = viridis_palette
        )
    }
  } else {
    if (fill_var_type) {
      plot <- plot +
        scale_fill_viridis(
          end = viridis_end,
          direction = viridis_direction, discrete = TRUE,
          option = viridis_palette
        )
    } else {
      plot <- plot +
        scale_fill_viridis(
          end = viridis_end, trans = trans,
          direction = viridis_direction, discrete = FALSE,
          option = viridis_palette
        )
    }
  }
  if (!is.null(df_prep$facet)) {
    plot <- plot +
      facet_wrap(df_prep$facet, scales = "fixed")
  }

  if (interactive) {
    plot <- plot +
      theme(legend.position = "none")

    plot <- plotly::ggplotly(plot, source = "WorldMap") %>%
      style(hoverlabel = list(bgcolor = "white"), hoveron = "fill")

    plot$x$frames <- lapply(
      plot$x$frames, function(f) {
        f$data <- lapply(f$data, function(d) d[!names(d) %in% c("x", "y")])
        f
      }
    )
  }

  return(plot)
}
