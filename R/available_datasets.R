#' Available Datasets
#'
#'Datasets that `getTBinR` supports importing into R, see [here](https://www.who.int/tb/country/data/download/en/) 
#'additional dataset details. This dataset is also used by \code{\link[getTBinR]{get_tb_burden}}. 
#'Use \code{\link[getTBinR]{search_data_dict}} in order to get details of the variables in each dataset.
#' @format A data frame with 7 rows and 5 variables.
#' \describe{
#'   \item{dataset}{Dataset name used by the WHO data dictionary.}
#'   \item{description}{Either the data description supplied by the WHO or a user generated description.}
#'   \item{timespan}{The timespan of the data}
#'   \item{default}{Whether the dataset is downloaded by default or not.}
#'   \item{url}{The URL for downloading the data - used by \code{\link[getTBinR]{get_tb_burden}}}
#' }
"available_datasets"