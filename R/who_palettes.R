#' World Health Organization-inspired palettes
#' 
#' @param palette A character string. the colours of choice, current options are "main" and "light"
#' for mixed colours as well as "purples", "blues", "pinks", "greens", and "browns".
#' @param reverse Logical, defaults to \code{FALSE}. Should the palette be reversed.
#' @param n Number of colours desired. If a specific value is given which corresponds 
#' to the length of a palette used in the 2019 WHO TB report, this palette is returned, 
#' else the number of entries in the palette with the most colour options (up to its 
#' full length) is returned. Defaults to \code{NULL} which returns the longest palette.
#' @param add_missings Add a grey and white colour to the palette, defaults to \code{FALSE}.
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
who_palettes <- function(palette = "main", reverse = FALSE, n = NULL, 
                         add_missings = FALSE,...){
  
  if (!palette %in% c("main", "light", "purple", "turquoise",
                      "blue", "magenta", "brown", "misc", "green", "red"))
    stop("chosen palette not available")
  
  if (palette == "main")
    who_pal <- list(c("#000000", "#EE1A24", "#1591D1", "#90A93D", "#00A56B", "#008ECF"))
  
  if (palette == "light")
    who_pal <- list(c("#BBBDBF", "#FCBEA7", "#BDD5EF", "#D9DDBB", "#99D3BC", "#BCD4EE"))
  
  if (palette == "purple")
    who_pal <- list(c("#6F2B90"),
                    c("#A787BE", "#6F2B90"),
                    c("#E7E1EF", "#C5B1D6", "#9A75B4", "#6F2B90"),
                    c("#F0DFE5", "#E6C3CF", "#B59BC9", "#946CAF", "#6F2B90"),
                    c("#F2E4E8", "#EACED7", "#DAA3B7", "#B59BC9", "#A07EB9", "#6E4B84"))
  
  if (palette == "turquoise")
    who_pal <- list(c("#D1E9EC", "#9AD2DA", "#3AB6C3", "#009CAC"),
                    c("#E2F3F4", "#AEDFE6", "#76CDD9", "#00B7C7", "#00828F"))
  
  if (palette == "blue")
    who_pal <- list(c("#034DA1"),
                    c("#E0E2F1", "#8490C7", "#034DA1"),
                    c("#E0E2F1", "#AEB5DC", "#7080BE", "#034DA1"),
                    c("#E0E2F1", "#98A1D1", "#BBC1E2", "#98A1D1", "#034DA1"))
  
  if (palette == "magenta")
    who_pal <- list(c("#B62170"),
                    c("#F0DFE5", "#E2B8C7", "#CD7D9C", "#B62170"),
                    c("#F2E4E8", "#E6C3CF", "#D79AB0", "#C76B90", "#B62170"))
  
  if (palette == "brown")
    who_pal <- list(c("#82524C"),
                    c("#F7931D", "#82524C"), 
                    c("#DDCFCA", "#CCB1A8", "#AB887F", "#82524C"),
                    c("#FEE5CA", "#FDCA93", "#DC936D", "#CB572C", "#82524C"), 
                    c("#F3DED1", "#EBC4AC", "#E1A280", "#B7988F", "#A07A71", "#82524C"))
  
  if (palette == "misc")
    who_pal <- list(c("#00AABC"),
                    c("#00AABC", "#ED1C24"),
                    c("#00AABC", "#ED1C24", "#F7931D"),
                    c("#00AABC", "#ED1C24", "#F7931D", "#E5DAB8"))
  
  if (palette == "green")
    who_pal <- list(c("#CFE4AD"),
                    c("#90A93D", "#CED4A7"),
                    c("#EAEBD9", "#CED4A7", "#AEBC70"),
                    c("#DEF0E7", "#A6D8C3", "#62C29F", "#00AE70"),
                    c("#EAEBD9", "#D7DBB7", "#C4CC94", "#7FCAAD", "#3FC39A", "#00A66C"))
  
  if (palette == "red")
    who_pal <- list(c("#FFEBD5", "#FCD2C1", "#F8A98F", "#F48365", "#ED1C24", "#B01116"))
  
  len <- sapply(1 : length(who_pal), function(x) length(who_pal[[x]]))
  if (is.null(n)) {
    pal <- who_pal[[which.max(len)]]
  } else {
    if (n > which.max(len))
      stop("n is larger than number of available colours for chosen palette")
    if (n %in% len)
      pal <- who_pal[[which(len == n)]]
  }
  
  if (isTRUE(reverse))
    pal <- rev(pal)
  
  if (isTRUE(add_missings)) {
    if (palette %in% c("light", "misc")) {
      pal <- c(pal, c("#A7A9AB", "#DBDCDE"))
    } else {
      pal <- c(pal, c("#9D9B9C", "#FFFFFF"))
    }
  }
  
  grDevices::colorRampPalette(pal, ...)
}