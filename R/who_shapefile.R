#' WHO shapefile
#'
#'The shapefile used in the WHO TB report, see [here](https://github.com/hazimtimimi/global_report/raw/master/Data/gparts.Rdata) 
#'for the original source. This shapefile is used in \code{\link[getTBinR]{map_tb_burden}}.
#' @format A data frame with 15243 rows and 7 variables.
#' \describe{
#'   \item{long}{Longitude}
#'   \item{lat}{Latitude}
#'   \item{order}{The shape order.}
#'   \item{hole}{}
#'   \item{piece}{}
#'   \item{group}{The country group}
#'   \item{id}{The country acronym}
#' }
"who_shapefile"