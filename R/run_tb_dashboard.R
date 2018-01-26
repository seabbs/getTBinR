#' Run a TB Shiny Dashboard
#'
#' @description This functions runs a TB dashboard that has been built using other
#' package functionality. The dashboard can be used to explore the global burden of TB 
#' interactively. A hosted version of this dashboard is available [here](http://www.seabbs.co.uk/shiny/ExploreGlobalTB). 
#' @return Starts a shiny Tuberculosis dashboard
#' @export
#' @importFrom utils installed.packages
#' @examples
#' 
#' ## Only run the example if in an interative session
#' \dontrun{
#' 
#' ## Run the TB dashboard
#' run_tb_dashboard()
#' }
run_tb_dashboard <- function() {
  
  required_packages <- c("shiny", "shinydashboard", "shinyWidgets", "shinycssloaders",
                         "plotly", "magrittr", "dplyr", "tibble", "getTBinR")
  
  not_present <- sapply(required_packages, function(package) {
    
    not_present <- !(package %in% rownames(installed.packages()))
    
    if (not_present) {
      message(paste0(package,
                  " is required to use run_tb_dashboard, please install it before using this function"))
    }
    
    return(not_present)
  }
  )

  if (any(not_present)) {
    stop("Packages required for this dashboard are not installed, 
         please use the following code to install the required packages \n\n 
         install.packages(c('", paste(required_packages[not_present], collapse = "', '"), "'))")
  }
  
  appDir <- system.file("shiny", "ExploreGlobalTB", package = "getTBinR")
  if (appDir == "") {
    stop("Could not find the ExploreTB directory. Try re-installing `getTBinR`.", call. = FALSE)
  }
  
  shiny::runApp(appDir, display.mode = "normal")
}
