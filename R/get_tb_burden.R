#' Get the WHO TB Burden Data
#'
#' @description Get the TB burden data, and multi-drug resistant TB (MDR-TB) data from the WHO, see
#' [here](http://www.who.int/tb/country/data/download/en/) for details. This function will first attempt
#' to load the data from the temporary directory (\code{\link[base]{tempdir}}). If that fails, and \code{download_data = TRUE}, it
#' will instead download the data. The MDR TB data is only available for the latest year of data.
#'
#' @param url Character string, indicating  the url of the TB burden data.
#'  Default is current url. This argument is depreciated and will be removed from future releases.
#'  The TB burden URL is now supplied internally - see \code{\link[getTBinR]{available_datasets}} for details.
#' @param add_mdr_data Logical, defaults to \code{TRUE}. Should MDR TB burden data be downloaded and joined
#' to the TB burden data.
#' @param additional_datasets A character vector specifying the names of the additional datasets to import.
#' See \code{\link[getTBinR]{available_datasets}} for available datasets. Use "all" to download all available
#' datasets (experimental datasets such as incidence by age and sex are excluded from this list).
#' @param mdr_save_name Character string, name to save the MDR data under. This argument is depreciated
#' and will be removed from future releases. Dataset naming is now handled internally.
#' @param mdr_url Character string, indicating the url of the MDR TB data. This argument is depreciated
#' and will be removed from future releases.  The MDR-TB burden URL is now supplied internally -
#' see \code{\link[getTBinR]{available_datasets}} for details.
#' @param burden_save_name Character string, name to save the data under. This argument is depreciated
#' and will be removed from future releases. Dataset naming is now handled internally.
#' @param return Logical, should the data be returned as a dataframe.
#' Defaults to \code{TRUE}.
#'
#' @return The WHO TB burden data as a tibble.
#' @inheritParams get_data
#' @importFrom dplyr case_when mutate mutate_if mutate_all left_join full_join filter rename
#' @importFrom tibble as_tibble
#' @importFrom purrr map reduce
#' @export
#' @seealso get_data search_data_dict
#' @examples
#'
#'
#' ## Default datasets
#' tb_burden <- get_tb_burden(additional_datasets = available_datasets$dataset[3])
#'
#' head(tb_burden)
#'
#' ## Add in the latent TB dataset as an additional dataset (see getTBinR::avaiable_datasets)
#' tb_with_latents <- get_tb_burden(additional_datasets = available_datasets$dataset[3])
#'
#' head(tb_with_latents)
get_tb_burden <- function(url = NULL,
                          download_data = TRUE,
                          save = TRUE,
                          burden_save_name = NULL,
                          add_mdr_data = TRUE,
                          additional_datasets = NULL,
                          mdr_save_name = NULL,
                          mdr_url = NULL,
                          return = TRUE,
                          verbose = TRUE,
                          use_utils = FALSE,
                          retry_download = TRUE) {
  g_whoregion <- NULL
  . <- NULL
  best <- NULL
  lo <- NULL
  hi <- NULL
  age_group <- NULL
  sex <- NULL

  if (!is.null(url)) {
    warning("This argument is depreciated and will be removed from future releases. 
            The TB burden URL is now supplied internally.")
  } else {
    url <- getTBinR::available_datasets$url[1]
  }


  if (!is.null(burden_save_name)) {
    warning("This argument is depreciated and will be removed from future releases. 
            The dataset savename is now supplied internally.")
  } else {
    burden_save_name <- "tb_burden"
  }

  if (!is.null(mdr_url)) {
    warning("This argument is depreciated and will be removed from future releases. 
            The MDR-TB burden URL is now supplied internally.")
  } else {
    mdr_url <- getTBinR::available_datasets$url[2]
  }

  if (!is.null(mdr_save_name)) {
    warning("This argument is depreciated and will be removed from future releases. 
            The dataset savename is now supplied internally.")
  } else {
    mdr_save_name <- "mdr_tb"
  }

  trans_burden_data <- function(tb_df) {
    tb_df <- tibble::as_tibble(tb_df)
    tb_df <- mutate_all(tb_df, .funs = list(~ {
      ifelse(. %in% c("NA", "`<NA>`"), NA, .)
    }))
    tb_df <- mutate_if(tb_df, is.numeric, .funs = list(~ {
      ifelse(. %in% c(Inf, NaN), NA, .)
    }))
    tb_df$iso_numeric <- tb_df$iso_numeric %>%
      as.numeric() %>%
      as.integer()

    return(tb_df)
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
      tb_df <- mutate_all(tb_df, .funs = list(~ {
        ifelse(. %in% c("NA", "`<NA>`"), NA, .)
      }))
      tb_df <- mutate_if(tb_df, is.numeric, .funs = list(~ {
        ifelse(. %in% c(Inf, NaN), NA, .)
      }))
      tb_df$iso_numeric <- tb_df$iso_numeric %>%
        as.numeric() %>%
        as.integer()

      return(tb_df)
    }

    mdr_tb <- get_data(
      url = mdr_url,
      download_data = download_data,
      data_trans_fn = trans_mdr_data,
      save = save,
      save_name = mdr_save_name,
      return = return,
      verbose = verbose,
      use_utils = use_utils
    )

    if (verbose) {
      message("Joining TB burden data and MDR TB data.")
    }

    tb_burden <- suppressMessages(left_join(tb_burden, mdr_tb))
  }

  ## Get additional datasets if asked to
  if (!is.null(additional_datasets)) {
    if (additional_datasets == "all") {
      additional_datasets <- getTBinR::available_datasets$dataset[-c(1:3)]
    }

    load_additional_dataset <- function(dataset) {
      if (verbose) {
        message("Getting additional dataset: ", dataset)
      }

      if (!any(grepl(dataset, getTBinR::available_datasets$dataset))) {
        stop(dataset, " is not listed in available_datasets and so cannot be imported.")
      }

      generic_trans <- function(df) {
        df <- tibble::as_tibble(df)
        df <- mutate_all(df, .funs = list(~ {
          ifelse(. %in% c("NA", "`<NA>`"), NA, .)
        }))
        df <- mutate_if(df, is.numeric, .funs = list(~ {
          ifelse(. %in% c(Inf, NaN), NA, .)
        }))
        df$iso_numeric <- df$iso_numeric %>%
          as.numeric() %>%
          as.integer()

        return(df)
      }

      # Use available_datasets for url and get name based on that supplied.
      url <- getTBinR::available_datasets$url[grepl(dataset, getTBinR::available_datasets$dataset)][1]
      name <- tolower(dataset) %>%
        gsub(" ", "_", .)

      ad_df <- get_data(
        url = url,
        download_data = download_data,
        data_trans_fn = generic_trans,
        save = save,
        save_name = name,
        return = return,
        verbose = verbose,
        use_utils = use_utils
      )

      if (grepl("Incidence by age and sex", dataset)) {
        message("Incidence by age and sex data is experimental and may cause issues for other
        datasets. Use with caution!
        Open an issue here if you run into problems: https://github.com/seabbs/getTBinR/issues")
        ad_df <- ad_df %>%
          dplyr::rename(inc_age_sex = best, inc_age_sex_lo = lo, inc_age_sex_hi = hi) %>%
          dplyr::filter(!(age_group %in% c("all", "15plus")), sex != "a")
      }
      return(ad_df)
    }

    # Run data loading function over all supplied additional dataset names
    datasets <- map(additional_datasets, ~ load_additional_dataset(.))


    if (verbose) {
      message("Joining TB burden data and additional datasets.")
    }

    tb_burden <- suppressMessages(
      reduce(datasets, full_join, .init = tb_burden)
    )
  }

  ## Common dataset cleaning
  tb_burden <- mutate(tb_burden, g_whoregion = case_when(
    g_whoregion %in% "AFR" ~ "Africa",
    g_whoregion %in% "AMR" ~ "Americas",
    g_whoregion %in% "EMR" ~ "Eastern Mediterranean",
    g_whoregion %in% "EUR" ~ "Europe",
    g_whoregion %in% "SEA" ~ "South-East Asia",
    g_whoregion %in% "WPR" ~ "Western Pacific",
    TRUE ~ g_whoregion
  ))
  return(tb_burden)
}
