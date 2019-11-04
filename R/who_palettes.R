#' World Health Organization-inspired palettes
#' 
#' @param palette A character string. the colours of choice, current options are "main" and "light".
#' @param reverse Logical, defaults to \code{FALSE}. Should the palette be reversed. 
#' @param ... Pass additional arguments to \code{colorRampPalette}.
#' @author Maria Bekker-Nielsen Dunbar
#' @author Sam Abbott
#' @export
#' 
#' @importFrom grDevices colorRampPalette
#' @seealso scale_colour_who scale_fill_who
#' @examples
#' 
#' # Set up the main palette but reversed.
#' who_palettes(palette = "main", reverse = TRUE)
who_palettes <- function(palette = "main", reverse = FALSE, ...){
  
  who_pal <- list("main" = c("#000000", "#EE1A24", "#1591D1"),
                  "light" = c("#000000", "#FCBEA7", "#BDD5EF"))
  
  pal <- who_pal[[palette]]
  if (reverse) pal <- rev(pal)
  grDevices::colorRampPalette(pal, ...)
}