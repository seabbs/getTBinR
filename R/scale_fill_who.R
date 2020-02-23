#' Adds World Health Organization-inspired colours as fills to plots
#'
#'
#' @description Applies WHO inspired colours as a fill for \code{ggplot2} plots. Currently a continuous
#' palette has not been implemented so the \code{viridis} palettes will be used as a fallback in this situation.
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
#' plot_tb_burden_summary(
#'   countries = "United Kingdom", compare_all_regions = FALSE,
#'   compare_to_region = TRUE, verbose = FALSE
#' ) +
#'   theme_who() +
#'   scale_colour_who(reverse = TRUE) +
#'   scale_fill_who(reverse = TRUE)
scale_fill_who <- function(palette = "light", discrete = TRUE,
                           reverse = FALSE, n = NULL, add_missings = FALSE, ...) {
  pal <- getTBinR::who_palettes(palette = palette, reverse = reverse)

  if (isTRUE(discrete)) {
    ggplot2::discrete_scale("fill", paste0("who_", palette), palette = pal, ...)
  } else {
    ggplot2::scale_fill_viridis_c(...)
  }
}
