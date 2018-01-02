#' Get the WHO Data Dictionary for TB Data
#'
#' @description Get the data dictionary for TB burden data from the WHO, see 
#' [here](http://www.who.int/tb/country/data/download/en/) for details.
#' 
#' @param url Character string, indicating  the url of the data 
#' dictionary. Default is current url.
#' @param path Character string, indicating the folder to save the data into,
#' defaults to \code{data-raw}.
#' @param dict_save_name Character string, name to save dictionary under. Defaults to
#' \code{TB_data_dict}.
#' @param return Logical, should the data  dictionary be returned as a dataframe.
#' Defaults to \code{TRUE}.
#' @inheritParams get_data
#' @return The WHO TB data dictionary as a tibble with 4 variables:
#' variable_name, dataset, code_list, definition.
#' @export
#' @seealso get_data search_data_dict
#' @examples
#' 
#' dict <- get_data_dict(download_data = TRUE, save = TRUE)
#' 
#' head(dict)
#' 
get_data_dict <- function(url = "https://extranet.who.int/tme/generateCSV.asp?ds=dictionary", 
                          download_data = FALSE,
                          save = FALSE,
                          dict_save_name = "TB_data_dict",
                          path = "data-raw",
                          return = TRUE,
                          verbose = TRUE) {

  get_data(url = url,
           path = path,
           download_data = download_data,
           save = save,
           save_name = dict_save_name,
           return = return,
           verbose = verbose)
}