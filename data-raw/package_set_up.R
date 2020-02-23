
# install.packages("devtools")
library(devtools)

# init stuffs
use_data_raw()
use_cran_badge()
use_readme_rmd()
use_testthat()
use_roxygen_md()
use_travis()
use_coverage()
use_appveyor()
# install packages as in description
devtools::install_deps()

# Suggest
use_package("pkgdown", type = "Suggests")
use_package("devtools", type = "Suggests")
use_package("testthat", type = "Suggests")
use_package("gganimiate", type = "Suggests")

# Imports
use_package("data.table", type = "Imports")
use_package("tibble", type = "Imports")
use_package("dplyr", type = "Imports")
use_package("purrr", type = "Imports")
use_package("magrittr", type = "Imports")
use_package("ggplot2", type = "Imports")
use_package("plotly", type = "Imports")

# Vignettes
use_vignette("intro")

## Build site, and make pkgdown
devtools::document()
devtools::build_vignettes()
devtools::install()
pkgdown::build_site()
