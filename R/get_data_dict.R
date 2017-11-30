#' Get the WHO Data Dictionary for TB Data
#'
#' @description Get the data dictionary for TB burden data from the WHO, see 
#' [here](http://www.who.int/tb/country/data/download/en/) for details.
#' 
#' @param url Character string, indicating  the url of the data 
#' dictionary. Default is current url.
#' @param path Character string, indicating the folder to save the data into,
#' defaults to \code{data-raw}.
#' @param save Logical, should the dictionary be saved for reuse. Defaults to 
#' \code{TRUE}.
#' @param save_name Character string, name to save dictionary under. Defaults to
#' \code{TB_data_dict}.
#' @param return Logical, should the data  dictionary be returned as a dataframe.
#' Defaults to \code{TRUE}.
#'
#' @return The WHO TB data dictionary as a tibble with 4 variables:
#' variable_name, dataset, code_list, definition.
#' @export
#' @importFrom data.table fread
#' @importFrom tibble as_tibble
#' @seealso search_data_dict
#' @examples
#' 
#' dict <- get_data_dict()
#' 
#' head(dict)
#' 
get_data_dict <- function(url = "https://extranet.who.int/tme/generateCSV.asp?ds=dictionary", 
                          path = "data-raw",
                          save = TRUE,
                          save_name = "TB_data_dict",
                          return = TRUE) {
  dict_path <- file.path(path, paste0(save_name, ".rds"))
  
  if (!file.exists(dict_path) | !save) {
    dict <- data.table::fread(url)
    dict <- tibble::as_tibble(dict)
  }else{
    dict <- readRDS(dict_path)
  }
  
  if (save) {
    if (!dir.exists(path)) {
      dir.create(path)
    }
    saveRDS(dict, dict_path)
  }
  
  if (return) {
    return(dict)
  }
}