# getTBinR 0.5.2.0

## Feature updates

* Improved plotly tool tips in all interactive plots.
* Added option to pass multiple years for interactive maps using the built in plotly frame functionality.

## Package updates

* Added retry download option to deal with possible API rate limits in response to [this issue](https://github.com/seabbs/getTBinR/issues/24).
* Added downloads badge to readme.


# getTBinR 0.5.1.0

## Feature updates

* Added `annual_change` arguement to all plotting/mapping functions. Passed to `prepare_df_plot`. Returns the percentage annual change for the supplied metric.
* Added `trans` arguement to all plotting functions to allow scaling using any `ggplot2::continous_scale` `trans` arguement.
* Added adaptive axis and legend labels to properly show annual percentage change.
* Added `run_tb_dashboard` to launch a shiny dashboard for exploring global tuberculosis
* Changed function defaults so that data is automatically downloaded and saved into the temporary
directory when `get_data` functions are called.

## Package updates

* Added new examples to display new functionality
* Updated readme with new functionality
* Updated intro vignette with new functionality
* Added a new case studies vignette section
* Added a case study exploring global trends in Tuberculosis incidence rates
* Added a work around using `utils::read.csv` for downloading the data when `fread::data.table` fails. Related to this [issue](https://github.com/seabbs/getTBinR/issues/18).

# getTBinR 0.5.0.0

## Feature updates

* Added `download_data` arguement to all functions to make downloading data explicit.
* Added `save` arguement to all functions to make saving the data explicit.
* Added `save_name` and `path` arguements to all functions to make location of saving explicit.

## Package updates

* Updated documentation to reflect above changes.
* Updated tests to reflect changes.
* Doc improvements ready for CRAN.
* Switched Imported packages from github versions to CRAN versions.
* Switched to saving data only to temporary directory (`tempdir()`)

# getTBinR 0.1.0.0

## Feature updates

* Added `map_tb_burden` function to map TB metrics.

## Package updates

* Added a `NEWS.md` file to track changes to the package.

# getTBinR 0.0.5.0

## Feature updates

* Added `plot_tb_burden_overview` function to plot an overview of the TB burden.

## Package updates

* Updated the package site.
* Refactored plotting code.

# getTBinR 0.0.1.0

## Feature updates

* Added `plot_tb_burden` function to plot TB burden

## Package updates

* Set up package infractstructure

