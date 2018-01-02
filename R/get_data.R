#' Generic Get Data Function
#'
#' @description If the data is found locally then this function will load the data into R. Otherwise
#' if \code{download_data = TRUE} then the data will be retrieved from the specified URL. Data can then be 
#' saved by specifying \code{save = TRUE}.
#' @param url Character string, indicating  the url of the data to download.
#' @param data_trans_fn Function that takes a data.table as input and returns a single
#' dataframe of any type. If not specified defaults to transforming the data into a tibble.
#' @param path Character string, indicating the folder to save the data into,
#' defaults to \code{data-raw}.
#' @param download_data Logical, defaults to \code{FALSE}. If not found locally should the data be
#'  downloaded from the specified URL?
#' @param save Logical, should the data be saved for reuse. Defaults to 
#' \code{FALSE}.
#' @param save_name Character string, name to save the data under. Defaults to
#' \code{NULL}.
#' @param return Logical, should the data be returned as a dataframe.
#' Defaults to \code{TRUE}.
#' @param verbose Logical, defaults to \code{TRUE}. Should additional status and progress messages
#' be displayed.
#'
#' @return The data loaded from a local copy or downloaded from the given url as a dataframe, exact format specified by data_trans_fn
#' @export
#' @importFrom data.table fread
#' @importFrom tibble as_tibble
#' @seealso get_tb_burden get_data_dict
#' @examples
#' 
#' tb_burden <- get_data(url = "https://extranet.who.int/tme/generateCSV.asp?ds=estimates",
#' save_name = "TB_burden",
#' save = TRUE, 
#' download_data = TRUE)
#' 
#' head(tb_burden)
#' 
get_data <- function(url = NULL, 
                     data_trans_fn = NULL,
                     download_data = FALSE,
                     save = FALSE,
                     save_name = NULL,
                     path = "data-raw",
                     return = TRUE,
                     verbose = TRUE) {
  
  if (is.null(data_trans_fn)) {
    data_trans_fn <- tibble::as_tibble
  }
  
  data_path <- file.path(path, paste0(save_name, ".rds"))
  
  if (!file.exists(data_path) && download_data) {
    if (verbose) {
      message("Downloading data from: ", url)
    }
    
    data <- data.table::fread(url)
    data <- data_trans_fn(data)
    
    if (save) {
      if (!dir.exists(path)) {
        dir.create(path)
      }
      
      if (verbose) {
        message("Saving data to: ", data_path)
      }
      saveRDS(data, data_path)
    }
    
  }else if (!file.exists(data_path) && !download_data) {
    stop("Data not found locally at: ", data_path,
         "\n Permission to download has not been given. 
If the data exists locally, check the path and save_name.
If it does not exist locally then change download_data to TRUE to download the data.
Set save to TRUE to save the data for local use.")
  }else {
    
    if (verbose) {
      message("Loading data from: ", data_path)
    }
    
    data <- readRDS(data_path)
  }
  
  if (return) {
    return(data)
  }
}