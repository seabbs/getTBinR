#' Adds World Health Organization-inspired colours as fills to plots
#' 
#' 
#' @description Applies WHO inspired colours as a fill for \code{ggplot2} plots. Currently a continuous
#' palette has not been implemented so the \code{viridis} palettes will be used as a fallback in this situation.
#' @param palette A character string. the colours of choice, current options are 
#' "main", "light" and "misc" for mixed colours as well as "purple", "turquoise",
#' "blue", "magenta", "brown", "misc", "green", and "red".
#' @param discrete Logical, defaults to \code{TRUE}. Should the palette be discrete or continuous.
#' @param reverse Logical, defaults to \code{FALSE}. Should the colour palette be reversed.
#' @param n Number of colours desired. If a specific value is given which corresponds 
#' to the length of a palette used in the 2019 WHO TB report, this palette is returned, 
#' else the number of entries in the palette with the most colour options (up to its 
#' full length) is returned. Defaults to \code{NULL} which returns the longest palette.
#' @param add_missings Add a grey and white colour to the palette, defaults to \code{FALSE}.
#' @param ... Pass additional arguments to \code{ggplot2::discrete_scale} or \code{ggplot2::scale_colour_viridis_c}
#' depending on the \code{discrete} setting.
#' @export
#' @importFrom ggplot2 discrete_scale scale_fill_viridis_c
#' @inheritParams scale_colour_who
#' @seealso scale_colour_who who_palettes
#' @author Maria Bekker-Nielsen Dunbar
#' @author Sam Abbott
#' 
#' @examples 
#' 
#' 
#' plot_tb_burden_summary(countries = "United Kingdom", compare_all_regions = FALSE,
#'                        compare_to_region = TRUE, verbose = FALSE) +
#' theme_who() +
#' scale_colour_who(reverse = TRUE) +
#' scale_fill_who(reverse = TRUE)
scale_fill_who <- function(palette = "light", discrete = TRUE, 
                           reverse = FALSE, n = NULL, add_missings = FALSE, ...) {
  
  pal <- getTBinR::who_palettes(palette = palette, reverse = reverse)
  
  if (isTRUE(discrete)){
    ggplot2::discrete_scale("fill", paste0("who_", palette), palette = pal, ...)
  } else {
    ggplot2::scale_fill_viridis_c(...)
  }
}