#' Adds World Health Organization-inspired colours to plots
#' 
#' 
#' @description Applies WHO inspired colours for \code{ggplot2} plots. Currently a continuous
#' palette has not been implemented so the \code{viridis} palettes will be used as a fallback in this situation.
#' @param discrete Logical, defaults to \code{TRUE}. Should the palette be discrete or continuous.
#' @param reverse Logical, defaults to \code{FALSE}. Should the colour palette be reversed.
#' @param ... Pass additional arguments to \code{ggplot2::discrete_scale} or \code{ggplot2::scale_colour_viridis_c}
#' depending on the \code{discrete} setting.
#' 
#' @export
#' @importFrom ggplot2 discrete_scale scale_fill_viridis_c
#' @inheritParams who_palettes
#' @aliases scale_color_who
#' @seealso scale_colour_who scale_fill_who who_palettes
#' @author Maria Bekker-Nielsen Dunbar
#' @author Sam Abbott
#' @examples 
#' 
#' plot_tb_burden_summary(countries = "United Kingdom", compare_all_regions = FALSE,
#'                        compare_to_region = TRUE, conf = NULL, verbose = FALSE) +
#' theme_who() +
#' scale_colour_who(reverse = TRUE)
scale_colour_who <- function(palette = "main", discrete = TRUE,
                             reverse = FALSE, ...) {
  pal <- getTBinR::who_palettes(palette = palette, reverse = reverse)
  if (isTRUE(discrete)){
    ggplot2::discrete_scale("colour", paste0("who_", palette), palette = pal, ...)
  } else {
    ggplot2::scale_colour_viridis_c(...)
  }
}


#' @export
#' @rdname scale_colour_who
#' @usage NULL
scale_color_who <- scale_colour_who