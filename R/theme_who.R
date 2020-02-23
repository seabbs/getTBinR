#' World Health Organization-inspired ggplot2 theme
#'
#'
#' @description This theme is inspired by that used in the annual global Tuberculosis report.
#' See the report [here](https://www.who.int/tb/publications/global_report/en/).
#' @export
#' @importFrom ggplot2 element_text theme element_blank margin element_line
#' @seealso bbplot::bbc_style()
#' @author Maria Bekker-Nielsen Dunbar
#' @author Sam Abbott
#' @examples
#'
#' plot_tb_burden_summary(conf = NULL, verbose = FALSE) +
#'   theme_who()
theme_who <- function() {
  font <- "sans"
  sz <- 20
  ggplot2::theme(
    # Text
    ## Title format
    plot.title = ggplot2::element_text(
      family = font,
      size = sz + 8,
      face = "bold",
      colour = "black",
      hjust = 0
    ),
    ## Subtitle format
    plot.subtitle = ggplot2::element_text(
      family = font,
      size = sz + 4,
      margin = ggplot2::margin(9, 0, 9, 0)
    ),
    ## Caption format
    plot.caption = ggplot2::element_text(
      family = font,
      size = sz - 10,
      colour = "black",
      hjust = 1
    ),


    # Axis format
    axis.title = ggplot2::element_text(
      family = font,
      size = sz - 8,
      colour = "black"
    ),
    axis.text = ggplot2::element_text(
      family = font,
      size = sz - 10,
      colour = "black"
    ),
    axis.text.x = ggplot2::element_text(margin = ggplot2::margin(5, b = 10)),
    axis.ticks = ggplot2::element_line(colour = "black"),
    axis.line = ggplot2::element_line(colour = "black"),

    # Gridlines
    ## Remove minor gridlines
    panel.grid.minor = ggplot2::element_blank(),
    ## Remove major y gridlines
    panel.grid.major.y = ggplot2::element_blank(),
    ## Remove major x gridlines
    panel.grid.major.x = ggplot2::element_blank(),

    # Blank background
    panel.background = ggplot2::element_blank(),
    # Strip background
    strip.background = ggplot2::element_blank(),
    # Remove boxes around facet titles
    strip.text = ggplot2::element_text(size = sz + 4, hjust = 0)
  )
}
