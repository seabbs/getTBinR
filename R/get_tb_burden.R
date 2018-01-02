#' Get the WHO TB Burden Data
#'
#' @description Get the TB burden data from the WHO, see 
#' [here](http://www.who.int/tb/country/data/download/en/) for details.
#' 
#' @param url Character string, indicating  the url of the TB burden data.
#'  Default is current url.
#' @param path Character string, indicating the folder to save the data into,
#' defaults to \code{data-raw}.
#' @param burden_save_name Character string, name to save the data under. Defaults to
#' \code{TB_burden}.
#' @param return Logical, should the data be returned as a dataframe.
#' Defaults to \code{TRUE}.
#'
#' @return The WHO TB burden data as a tibble.
#' @inheritParams get_data
#' @importFrom dplyr case_when mutate
#' @importFrom tibble as_tibble
#' @export
#' @seealso get_data search_data_dict
#' @examples
#' 
#' tb_burden <- get_tb_burden(download_data = TRUE, save = TRUE)
#' 
#' head(tb_burden)
#' 
get_tb_burden <- function(url = "https://extranet.who.int/tme/generateCSV.asp?ds=estimates", 
                          download_data = FALSE,
                          save = TRUE,
                          burden_save_name = "TB_burden",
                          path = "data-raw",
                          return = TRUE,
                          verbose = TRUE) {

  g_whoregion <- NULL
  
  trans_burden_data <- function(df) {
    df <- tibble::as_tibble(df)
    df <- mutate(df, g_whoregion = case_when(g_whoregion %in% "AFR" ~ "Africa",
                                              g_whoregion %in% "AMR" ~ "Americas",
                                              g_whoregion %in% "EMR" ~ "Eastern Mediterranean",
                                              g_whoregion %in% "EUR" ~ "Europe",
                                              g_whoregion %in% "SEAR" ~ "South-East Asia",
                                              g_whoregion %in% "WPR" ~ "Western Pacific")
    )
  }
  
  get_data(
    url = url,
    path = path,
    download_data = download_data,
    data_trans_fn = trans_burden_data,
    save = save,
    save_name = burden_save_name,
    return = return,
    verbose = verbose
  )                                 

}