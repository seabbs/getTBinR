#' Render a Country Level TB Report
#'
#' @description This function renders a country level TB report.
#' @param country Character string, defaults to `"United Kingdom"`. Specify the country to
#' report on.
#' @param format Character string, defaults to `"html_document"`. The format to render the report to.
#' See `?rmarkdown::render` for details.
#' @param interactive Logical, defaults to `FALSE`. When the format allows should graphs be interactive.
#' @param save_dir Character string, defaults to `NULL`.
#'  If not given then the report is rendered to a temporary directory (although only if `filename` is also not given).
#' @param filename Character string defaults `NULL`. Name to save the report under, defaults to `"country_report"`.
#' @return Renders a country level TB report
#' @export
#' @importFrom utils installed.packages
#' @examples
#'
#' ## Only run the example if in an interative session
#' \dontrun{
#'
#' ## Run the TB dashboard
#' render_country_report()
#' }
render_country_report <- function(country = "United Kingdom", format = "html_document",
                                  interactive = FALSE, save_dir = NULL,
                                  filename = NULL) {
  required_packages <- c(
    "rmarkdown", "magrittr", "dplyr", "tibble",
    "ggplot2", "tidyr", "rlang", "getTBinR"
  )

  not_present <- sapply(required_packages, function(package) {
    not_present <- !(package %in% rownames(installed.packages()))

    if (not_present) {
      message(paste0(
        package,
        " is required to use render_country_report, please install it before using this function"
      ))
    }

    return(not_present)
  })

  if (any(not_present)) {
    stop("Packages required for this report are not installed, 
         please use the following code to install the required packages \n\n 
         install.packages(c('", paste(required_packages[not_present], collapse = "', '"), "'))")
  }

  report <- system.file("rmarkdown", "country-report.Rmd", package = "getTBinR")
  if (report == "") {
    stop("Could not find the report. Try re-installing `getTBinR`.", call. = FALSE)
  }

  if (is.null(save_dir) & is.null(filename)) {
    save_dir <- tempdir()

    message("Rendering report to ", save_dir)
  }

  rmarkdown::render(report,
    output_format = format,
    output_file = filename,
    output_dir = save_dir,
    intermediates_dir = save_dir,
    params = list(
      "country" = country,
      "interactive" = interactive
    ),
    envir = new.env(),
    clean = TRUE
  )
}
