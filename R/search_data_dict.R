#' Search the WHO TB Data Dictionary by Variable Name.
#'
#' @description Searches the WHO data dictionary for TB burden data. When run for the first time
#' it will download the data dictionary into the default path as specified by \code{\link[getTBinR]{get_data_dict}}.
#' To modify this behaviour pass arguements to \code{\link[getTBinR]{get_data_dict}}.
#' @param var A character vector of variable names.
#' @param def A character vector of terms to use to search the variable definitions
#' for partial matches
#' @param verbose Logical, defaults to \code{TRUE}. Should search information be returned.
#' @param ... Additional parameters to pass to \code{\link[getTBinR]{get_data_dict}}.
#' @seealso get_data_dict
#' @return A tibble containing the information in the data dictionary matching the variables
#' searched for.
#' @export
#' @importFrom dplyr filter distinct
#' @importFrom purrr map
#' @importFrom dplyr bind_rows
#' @examples
#' 
#' ## Search for a known variable
#' search_data_dict(var = "country")
#' 
#' ## Search for all variables mentioning mortality in their definition
#' search_data_dict(def = "mortality")
#' 
#' ## Search for both a known variable and for mortality being mentioned in there definition
#' ## Duplicate entries will be omitted.
#' search_data_dict(var = "e_mort_exc_tbhiv_100k", def = "mortality")
#' 
search_data_dict <- function(var = NULL, def = NULL, verbose = TRUE, ...) {
  if (is.null(var) && is.null(def)) {
    stop("At least one variable name  or definition fragment should be supplied")
  }
  
  dict <- get_data_dict(...)
  
  if (!is.null(var)) {
    variable_name <- NULL
    
    vars_of_interest <- dplyr::filter(dict, 
                                      variable_name %in% var)
    results_var <- nrow(vars_of_interest)
  }else{
    results_var <- 0
  }

  if (!is.null(def)) {
    defs_positions <- purrr::map(def, ~grep(., dict$definition, fixed = FALSE))
    def_positions <- unlist(defs_positions)
                                   
    defs_of_interest <- dict[def_positions,]
    
    results_def <- nrow(defs_of_interest)
  }else{
    results_def <- 0
  }
  

  
  if (verbose) {
    if (results_var == 0 && results_def == 0) {
      stop("No results found for your variable search for ", paste0(var, collapse = ", "))
      stop("No results found for your definition search for ", paste0(def, collapse = ", "))
    }else{
      message(results_var, " results found for your variable search for ", paste0(var, collapse = ", "))
      message(results_def, " results found for your definition search for ", paste0(def, collapse = ", "))
    }
  }
  
  if (!is.null(var) && !is.null(def)) {
    df_interest <- bind_rows(vars_of_interest,
                             defs_of_interest)
  }else if (!is.null(var)) {
    df_interest <- vars_of_interest
  }else if (!is.null(def)) {
    df_interest <- defs_of_interest
  }
  
  df_interest <- distinct(df_interest)
  
  return(df_interest)
}
  
