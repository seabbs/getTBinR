#' World Health Organization-inspired palettes
#' 
#' @param palette A character string. the colours of choice, current options are "main" and "light"
#' for mixed colours as well as "purples", "blues", "pinks", "greens", and "browns".
#' @param reverse Logical, defaults to \code{FALSE}. Should the palette be reversed.
#' @param n Number of colours desired, defaults to NULL which returns the entire palette.
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
who_palettes <- function(palette = "main", reverse = FALSE, n = NULL, ...){
  
  who_pal <- list("main" = c("#000000", "#EE1A24", "#1591D1", "#90A93D"),
                  "light" = c("#000000", "#FCBEA7", "#BDD5EF", "#D9DDBB"),
                  "purples" = c("#F0DFE5", "#E6C3CF", "#B59BC9", "#946CAF",
                                "#6F2B90"),
                  "blues" = c("#E2F3F4", "#AEDFE6", "#76CDD9", "#00B7C7",
                              "#00828F"),
                  "pinks" = c("#F2E4E8", "#E6C3CF", "#D79AB0", "#C76B90",
                              "#B62170"),
                  "greens" = c("#EAEBD9", "#D9DDBB", "#D9DDBB", "#C4CC94",
                                "#7FCAAD", "#3DBA93", "#00A66C"),
                  "browns" = c("#F3DED1", "#EBC4AC", "#E1A280", "#B7988F",
                               "#A07A71", "#82524C"))
  
  pal <- who_pal[[palette]]
  if (n > length(pal))
    stop("n is larger than number of available colours for chosen palette")
  if(isFALSE(is.null(n)))
    pal <- pal[1 : n]
  if (reverse)
    pal <- rev(pal)
  grDevices::colorRampPalette(pal, ...)
}