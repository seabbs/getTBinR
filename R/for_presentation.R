#' Presentation style plots
#'
#' @description This function adjusts the aspect ratio and default font size
#' of a plot to improve readibility when including figures in presentations.
#' @param plot The ggplot2 object to be adjusted.
#' @param aspect_ratio The desired ratio between the height and width of the
#' plot, defaults to 0.5.
#' @param font_increase The amount to increase the font size by, default to
#' 1.5.
#' @return A plot adjusted for presentaion.
#' @export
#' @importFrom ggplot2 theme
#' @author Maria Bekker-Nielsen Dunbar
#' @author Sam Abbott
#' @examples
#'
#' plot <- plot_tb_burden_summary(countries = "United Kingdom",
#' compare_all_regions = FALSE, compare_to_region = TRUE)
#' plot # Original
#' for_presentation(plot) # After adjustments

for_presentation <- function(plot, aspect_ratio = 0.5, font_increase = 1.5, ...){
  plot <- plot + theme(aspect.ratio = aspect_ratio)
  plot <- plot + theme(text = element_text(size = plot$theme$text$size * font_increase))
  
  return(plot)
}
