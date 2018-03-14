#' Get the WHO TB Burden Data
#'
#' @description Get the TB burden data, and multi-drug resistant TB (MDR-TB) data from the WHO, see 
#' [here](http://www.who.int/tb/country/data/download/en/) for details. This function will first attempt
#' to load the data from the temporary directory (\code{\link[base]{tempdir}}). If that fails, and \code{download_data = TRUE}, it
#' will instead download the data. The MDR TB data is only available for the latest year of data.
#' 
#' @param url Character string, indicating  the url of the TB burden data.
#'  Default is current url.
#' @param add_mdr_data Logical, defaults to \code{TRUE}. Should MDR TB burden data be downloaded and joined
#' to the TB burden data.
#' @param mdr_save_name Character string, name to save the MDR data under. Defaults to "MDR_TB"
#' @param mdr_url Character string, indicating the url of the MDR TB data.
#' @param burden_save_name Character string, name to save the data under. Defaults to
#' "TB_burden".
#' @param return Logical, should the data be returned as a dataframe.
#' Defaults to \code{TRUE}.
#'
#' @return The WHO TB burden data as a tibble.
#' @inheritParams get_data
#' @importFrom dplyr case_when mutate mutate_if
#' @importFrom tibble as_tibble
#' @export
#' @seealso get_data search_data_dict
#' @examples
#' 
#' tb_burden <- get_tb_burden()
#' 
#' head(tb_burden)
#' 
get_tb_burden <- function(url = "https://extranet.who.int/tme/generateCSV.asp?ds=estimates", 
                          download_data = TRUE,
                          save = TRUE,
                          burden_save_name = "TB_burden",
                          add_mdr_data = TRUE,
                          mdr_save_name = "MDR_TB",
                          mdr_url = "https://extranet.who.int/tme/generateCSV.asp?ds=mdr_rr_estimates",
                          return = TRUE,
                          verbose = TRUE,
                          use_utils = FALSE,
                          retry_download = TRUE) {

  g_whoregion <- NULL
  
  trans_burden_data <- function(tb_df) {
    
    tb_df <- tibble::as_tibble(tb_df)
    tb_df <- mutate(tb_df, g_whoregion = case_when(g_whoregion %in% "AFR" ~ "Africa",
                                              g_whoregion %in% "AMR" ~ "Americas",
                                              g_whoregion %in% "EMR" ~ "Eastern Mediterranean",
                                              g_whoregion %in% "EUR" ~ "Europe",
                                              g_whoregion %in% "SEA" ~ "South-East Asia",
                                              g_whoregion %in% "WPR" ~ "Western Pacific",
                                              TRUE ~ g_whoregion)
    )
    
    tb_df <- mutate_if(tb_df, is.numeric, .funs = funs({ifelse(. %in% c(Inf, NaN), NA, .)}))
    tb_df$iso_numeric <- as.integer(tb_df$iso_numeric)
  }
  
  ## Get TB burden data
  tb_burden <- get_data(
    url = url,
    download_data = download_data,
    data_trans_fn = trans_burden_data,
    save = save,
    save_name = burden_save_name,
    return = return,
    verbose = verbose,
    use_utils = use_utils
  )        
  
  ## Get MDR TB data
  if (add_mdr_data) {
    trans_mdr_data <- function(tb_df) {
      
      tb_df <- tibble::as_tibble(tb_df)
      tb_df <- mutate_if(tb_df, is.numeric, .funs = funs({ifelse(. %in% c(Inf, NaN), NA, .)}))
      tb_df$iso_numeric <- as.integer(tb_df$iso_numeric)
    }
    
    mdr_tb <- get_data(
      url = mdr_url,
      download_data = download_data,
      data_trans_fn = trans_mdr_data,
      save = save,
      save_name =  mdr_save_name,
      return = return,
      verbose = verbose,
      use_utils = use_utils
    ) 
    
    if (verbose){
      message("Joining TB burden data and MDR TB data.")
    }
    
    tb_burden <- tb_burden %>% 
      left_join(mdr_tb, by = c("country", "iso2", "iso3", "iso_numeric", "year"))
  }

  return(tb_burden)
}
