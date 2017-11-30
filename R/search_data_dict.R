#' Search the WHO TB Data Dictionary by Variable Name.
#'
#' @description Searches the WHO data dictionary for TB burden data. When run for the first time
#' it will download the data dictionary into the default path as specified by \code{\link[getTBinR]{get_data_dict}}.
#' To modify this behaviour pass arguements to \code{\link[getTBinR]{get_data_dict}}.
#' @param var A character vector of variable names.
#' @param verbose Logical, defaults to \code{TRUE}. Should search information be returned.
#' @param ... Additional parameters to pass to \code{\link[getTBinR]{get_data_dict}}.
#' @seealso get_data_dict
#' @return A tibble containing the information in the data dictionary matching the variables
#' searched for.
#' @export
#'
#' @examples
#' 
#' search_data_dict(var = "country")
#' 
search_data_dict <- function(var = NULL, verbose = TRUE, ...) {
  if (is.null(var)) {
    stop("At least one variable name should be supplied")
  }
  
  dict <- get_data_dict(...)
  
  vars_of_interest <- dplyr::filter(dict, variable_name %in% var)
  
  results <- nrow(vars_of_interest)
  
  if (verbose) {
    if (results == 0) {
      stop("No results were found for your variable search for ", var)
    }else{
      message(results, " results were found for your variable search for", var)
    }
  }
  
  return(vars_of_interest)
}
  
