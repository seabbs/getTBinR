#' World Health Organization-inspired ggplot2 theme
#' 
#' @rdname theme_who
#' @export
#' 
#' @seealso [bbplot::bbc_style()]
theme_who <- function(){
  font <- "sans" 
  sz <- 20
  ggplot2::theme(
    # Text
    ## Title format
    plot.title = ggplot2::element_text(family = font,
                                       size = sz + 8,
                                       face = "bold",
                                       colour = "black",
                                       hjust = 0),
    ## Subtitle format
    plot.subtitle = ggplot2::element_text(family = font,
                                          size = sz + 4,
                                          margin = ggplot2::margin(9, 0, 9, 0)),
    ## Caption format
    plot.caption = ggplot2::element_text(family = font,
                                         size = sz - 10,
                                         colour = "black",
                                         hjust = 1),
    
    # Legend
    legend.position = "none",
    legend.text.align = 0,
    legend.background = ggplot2::element_blank(),
    legend.title = ggplot2::element_blank(),
    legend.key = ggplot2::element_blank(),
    legend.text = ggplot2::element_blank(),
    
    # Axis format
    axis.title = ggplot2::element_text(family = font,
                                       size = sz - 8,
                                       colour = "black"),
    axis.text = ggplot2::element_text(family = font,
                                      size = sz - 10,
                                      colour = "black"),
    axis.text.x = ggplot2::element_text(margin=ggplot2::margin(5, b = 10)),
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

who_pal <- list("main" = c("#000000", "#EE1A24", "#1591D1"),
                "light" = c("#000000", "#FCBEA7", "#BDD5EF"))

#' World Health Organization-inspired palettes
#' 
#' @param palette The colours of choice, current options are main and light
#' @param reverse 
#' 
#' @export
#' 
#' @seealso scale_colour_who scale_fill_who
who_palettes <- function(palette = "main", reverse = FALSE, ...){
  pal <- who_pal[[palette]]
  if (reverse) pal <- rev(pal)
  colorRampPalette(pal, ...)
}

#' World Health Organization-inspired colours
#' 
#' @param palette The colours of choice, current options are main and light
#' @param reverse 
#' 
#' @rdname scale_colour_who
#' @export
#' 
#' @seealso [scale_colour_who() scale_fill_who() who_palettes()]
scale_colour_who <- function(palette = "main", discrete = TRUE,
                             reverse = FALSE, ...) {
  pal <- who_palettes(palette = palette, reverse = reverse)
  if (isTRUE(discrete)){
    ggplot2::discrete_scale("colour", paste0("who_", palette), palette = pal, ...)
  } else {
    ggplot2::scale_colour_viridis_c(...)
  }
}

#' @rdname scale_colour_who
#' @export
#' @usage NULL

scale_color_who <- scale_colour_who

#' @rdname scale_colour_who
#' @export

scale_fill_who <- function(palette = "light", discrete = TRUE, reverse = FALSE, ...) {
  pal <- who_palettes(palette = palette, reverse = reverse)
  
  if (isTRUE(discrete)){
    ggplot2::discrete_scale("fill", paste0("who_", palette), palette = pal, ...)
  } else {
    ggplot2::scale_fill_viridis_d(...)
  }
}