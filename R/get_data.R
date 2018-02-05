#' Generic Get Data Function
#'
#' @description If the data is found locally in the temporary directory then this function will load the data into R.
#'  Otherwise if \code{download_data = TRUE} then the data will be retrieved from the specified URL. Data can then be 
#'  saved  to the temporary directory by specifying \code{save = TRUE}.
#' @param url Character string, indicating  the url of the data to download.
#' @param data_trans_fn Function that takes a data.table as input and returns a single
#' dataframe of any type. If not specified defaults to transforming the data into a tibble.
#' @param download_data Logical, defaults to \code{TRUE}. If not found locally should the data be
#'  downloaded from the specified URL?
#' @param save Logical, should the data be saved for reuse during the current R session. Defaults to 
#' \code{TRUE}. If \code{TRUE} then the data is saved to the temporary directory specified by \code{\link[base]{tempdir}}.
#' @param save_name Character string, name to save the data under. Defaults to
#' \code{NULL}.
#' @param return Logical, should the data be returned as a dataframe.
#' Defaults to \code{TRUE}.
#' @param verbose Logical, defaults to \code{TRUE}. Should additional status and progress messages
#' be displayed.
#' @param use_utils Logical, defaults to \code{FALSE}. Used for testing alternative
#' data download function. When \code{TRUE} data is downloaded using \code{read.csv}.
#' @param retry_download Logical defaults to \code{TRUE}. When \code{TRUE}, if downloading
#' fails, the function will try repeatedly to download the data within 5 seconds, up
#' to 5 times.
#'
#' @return The data loaded from a local copy or downloaded from the given url as a dataframe, exact format specified by data_trans_fn
#' @export
#' @importFrom data.table fread
#' @importFrom utils read.csv
#' @importFrom tibble as_tibble
#' @importFrom stats runif
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
                     download_data = TRUE,
                     save = TRUE,
                     save_name = NULL,
                     return = TRUE,
                     verbose = TRUE,
                     use_utils = FALSE,
                     retry_download = TRUE) {
    path <- tempdir()
  
  if (is.null(data_trans_fn)) {
    data_trans_fn <- tibble::as_tibble
  }
  
  data_path <- file.path(path, paste0(save_name, ".rds"))
  
  if (!file.exists(data_path) && download_data) {
  
    tries <- 1
    failed <- FALSE
    
    if (!retry_download) {
      tries <- 5
    }
    
    while (tries < 6) {
      
      if (verbose) {
        message("Downloading data from: ", url)
      }
      
      if (!use_utils) {
        ddata <- try(data.table::fread(url), silent = TRUE)
        
        if ("try-error" %in% class(ddata)) {
          use_utils <- TRUE
          failed <- TRUE
        }
      }
      
      if (use_utils) {
        if (verbose) {
          message("Downloading the data using fread::data.table has failed. Trying
                again using utils::read.csv")
        }
        ddata <- try(read.csv(url, stringsAsFactors = FALSE), silent = TRUE)
        
        if ("try-error" %in% class(ddata)) {
          failed <- TRUE
          }else{
          failed <- FALSE
        }
      }
      
      if (failed) {
        
        message("Downloading data has failed after ", tries, " tries.")
        
        tries <- tries + 1
        
        pause_time <- runif(1, 0.5, 5)
        pause_time <- round(pause_time, digits = 1)
        
        message("Attempting data download in ", pause_time, " seconds.")
        
        Sys.sleep(pause_time)
      }
      
      if(!failed) {
        break
      }
      
    }

    if (failed || is.null(ddata)) {
      stop("Data downloading has failed, check your internet connection.
           If this issue is not resolved, contact the package author.")
    }
    
    ddata <- data_trans_fn(ddata)
    
    if (save) {
      if (!dir.exists(path)) {
        dir.create(path)
      }
      
      if (verbose) {
        message("Saving data to: ", data_path)
      }
      saveRDS(ddata, data_path)
    }
    
  }else if (!file.exists(data_path) && !download_data) {
    stop("Data not found locally at: ", data_path, "Permission to download has 
not been given. 
If the data exists locally, check the path and save_name.
If it does not exist locally then change download_data to TRUE to download the data.
Set save to TRUE to save the data for local use.")
  }else {
    
    if (verbose) {
      message("Loading data from: ", data_path)
    }
    
    ddata <- readRDS(data_path)
  }
  
  if (return) {
    return(ddata)
  }
}
