#' Run a TB Shiny Dashboard
#'
#' @description This functions runs a TB dashboard that has been built using other
#' package functionality. The dashboard can be used to explore the global burden of TB 
#' interactively. A hosted version of this dashboard is available [here](http://www.seabbs.co.uk/shiny/ExploreTB). 
#' @return Starts a shiny Tuberculosis dashboard
#' @export
#'
#' @examples
#' 
#' ## Only run the example if in an interative session
#' if (interactive()) {
#' 
#' ## Run the TB dashboard
#' run_tb_dashboard()
#' }
run_tb_dashboard <- function() {
  
  required_packages <- c("shiny", "shinydashboard", "shinyWidgets", "shinycssloaders",
                         "plotly", "magrittr")
  
  lapply(required_packages, function(package) {
    if (!(package %in% rownames(installed.packages()))) {
      stop(paste0(package,
                  " is required to use run_tb_dashboard, please install it before using this function"))
    }
  }
  )

  
  appDir <- system.file("shiny", "ExploreTB", package = "getTBinR")
  if (appDir == "") {
    stop("Could not find the ExploreTB directory. Try re-installing `getTBinR`.", call. = FALSE)
  }
  
  shiny::runApp(appDir, display.mode = "normal")
}