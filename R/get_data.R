#' Generic Get Data Function
#'
#' @param url Character string, indicating  the url of the data to download.
#' @param data_trans_fn Function that takes a data.table as input and returns a single
#' dataframe of any type. If not specified defaults to transforming the data into a tibble.
#' @param path Character string, indicating the folder to save the data into,
#' defaults to \code{data-raw}.
#' @param save Logical, should the data be saved for reuse. Defaults to 
#' \code{TRUE}.
#' @param save_name Character string, name to save the data under. Defaults to
#' \code{NULL}.
#' @param return Logical, should the data be returned as a dataframe.
#' Defaults to \code{TRUE}.
#'
#' @return The data downloaded from the given url as a dataframe, exact format specified by data_trans_fn
#' @export
#' @importFrom data.table fread
#' @importFrom tibble as_tibble
#' @seealso get_tb_burden get_data_dict
#' @examples
#' 
#' tb_burden <- get_data(url = "https://extranet.who.int/tme/generateCSV.asp?ds=estimates",
#' save_name = "TB_burden")
#' 
#' head(tb_burden)
#' 
get_data <- function(url = NULL, 
                          data_trans_fn = NULL,
                          path = "data-raw",
                          save = TRUE,
                          save_name = NULL,
                          return = TRUE) {
  
  if (is.null(data_trans_fn)) {
    data_trans_fn <- tibble::as_tibble
  }
  
  data_path <- file.path(path, paste0(save_name, ".rds"))
  
  if (!file.exists(data_path) | !save) {
    data <- data.table::fread(url)
    data <- data_trans_fn(data)
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