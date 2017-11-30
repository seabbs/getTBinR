#' Get the WHO TB Burden Data
#'
#' @description Get the TB burden data from the WHO, see 
#' [here](http://www.who.int/tb/country/data/download/en/) for details.
#' 
#' @param url Character string, indicating  the url of the TB burden data.
#'  Default is current url.
#' @param path Character string, indicating the folder to save the data into,
#' defaults to \code{data-raw}.
#' @param save Logical, should the data be saved for reuse. Defaults to 
#' \code{TRUE}.
#' @param save_name Character string, name to save the data under. Defaults to
#' \code{TB_burden}.
#' @param return Logical, should the data be returned as a dataframe.
#' Defaults to \code{TRUE}.
#'
#' @return The WHO TB burden data as a tibble.
#' @export
#' @importFrom data.table fread
#' @importFrom tibble as_tibble
#' @seealso search_data_dict
#' @examples
#' 
#' tb_burden <- get_tb_burden()
#' 
#' head(tb_burden)
#' 
get_tb_burden <- function(url = "https://extranet.who.int/tme/generateCSV.asp?ds=estimates", 
                          path = "data-raw",
                          save = TRUE,
                          save_name = "TB_burden",
                          return = TRUE) {
  data_path <- file.path(path, paste0(save_name, ".rds"))
  
  if (!file.exists(data_path) | !save) {
    data <- data.table::fread(url)
    data <- tibble::as_tibble(data)
  }else{
    data <- readRDS(data_path)
  }
  
  if (save) {
    if (!dir.exists(path)) {
      dir.create(path)
    }
    saveRDS(data, data_path)
  }
  
  if (return) {
    return(data)
  }
}