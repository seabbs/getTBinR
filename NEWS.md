# getTBinR 0.7.1

## Feature updates

* Switched dashboard to default to 2018 data.
* Added a new WHO inspired `{ggplot2}` theme (`theme_who`) and colour palette (`who_palettes`) resolving issue [#86](https://github.com/seabbs/getTBinR/issues/86). Plus `scale_colour` and `scale_fill_who` functions for using the palette. Thanks to [@mariabnd](https://github.com/mariabnd) for implementing this.
* Added a new function - `for_presentation` - to switch plots to presentation mode.

## Package updates

* Additional testing and examples to support the new WHO inspired theme and colour palettes.
* Additional documentation for the new WHO inspired theme and colour palettes.
* Updated the spelling of organisation to organization in all uses relating to the World Health Organization. Thanks to [@mariabnd](https://github.com/mariabnd) for spotting this.
* Added [@mariabnd](https://github.com/mariabnd) as a package contributor.
* Changed `verbose` to default to `FALSE` package wide.
* Bumped data availability to 2018.
* Standarised legend to be bottom aligned across the package.
* Dropped `tidyverse` from suggests as per this [issue](https://github.com/seabbs/getTBinR/issues/96).
* Fixed legend types as per this [issue](https://github.com/seabbs/getTBinR/issues/87)

Thanks to [@mariabnd](https://github.com/mariabnd) for contributing to this release.

# getTBinR 0.7.0

## Feature updates

* Added experimental support for incidence data stratified by age and sex. Current implementation requires data cleaning before use. See the release post for details.

## Package updates

* Fixed a bug that was preventing `render_country_report` from producing a country level report. Added tests to flag this in the future.
* Updated the packages requested for installation by `run_tb_dashboard` so that `render_country_report` runs without errors.
* Switched to using `ggplot2` best practises ([#77](https://github.com/seabbs/getTBinR/issues/77)).
* Updated the README to make identifying types of badges easier.

# getTBinR 0.6.1

## Package updates

* Fixed a joining bug for additional datasets that was removing all new data.
* Fixed a joining bug for budgets data that was removing all budgets data.
* Fixed a bug with `summarise_tb_burden` that caused an error when confidence intervals were not 
wanted and rates were estimated for countries.

# getTBinR 0.6.0

## Feature updates


* Added a new `summarise_metric` function to the package. This function was previously used internally by the TB report. For a given year it returns the value of given metric, along with the regional and global rankings. The average change over the last decade is also supplied. Linked to #57.
* `search_data_dict` can now be used to search for a dataset by name. All variables in this dataset are then returned.
* Added a new dataframe, `available_datasets`, that lists the datasets available to be imported into R using the package. This dataframe also gives a short description of each dataset, details the timespan of the dataset, and whether or not it is downloaded by default. Used by `get_tb_burden` as a URL source for downloading the datasets. Linked to #58.
* `get_tb_burden` can now import additional datasets (listed in `available_datasets`), clean them, and then link them with the core dataset. This adds over 400 new variables to the package and provides a near complete list of data used in the WHO Tuberculosis global report. Please open an issue if you find an issue with this dataset.

## Package updates

* Jumped to `0.6.0` to signal a major release.
* Updated earliest supported R version based on travis testing - now `3.3.0`. 
* Added the [JOSS paper](https://doi.org/10.21105/joss.01260) as the preferred citation for `getTBinR` and also added this information to the README.
* URL and data save names have been deprecated from all functions and will be removed in a future release. This allows the number of arguments for many functions to be reduced with no loss of functionality (as data is only saved temporally by package functions).
* `search_data_dict` has improved messaging and no longer returns an error when nothing is found in the data dictionary. From #65.
* `search_data_dict` has expanded testing to account for new dataset searching and for failing to find results. Linked to #60.
* Dropped usage of `dplyr::funs` as soft deprecated.
* Added tests for `summarise_metric` and added to documentation.
* Added tests for additional dataset import in `get_tb_burden`. #58
* Added `available_datasets` and new data import to the README and to the getting started vignette.

# getTBinR 0.5.8

## Package updates

* Added package information to license file - suggested during review for JOSS submission by @[rrrlw](https://github.com/rrrlw).
* Updated README introduction to better explain package aim -  suggested during review for JOSS submission by @[strengejacke](https://github.com/strengejacke)
* Improved package DESCRIPTION for CRAN only users - suggested during review for JOSS submission by @[rrrlw](https://github.com/rrrlw).
* Used `usethis::use_tidy_description` to improve DESCRIPTION formatting.
* Added development documentation badge to the README + website.
* Moved to automated pkgdown deployment using travis. Based on [this](https://pkgdown.r-lib.org/reference/deploy_site_github.html) and the `dplyr` implementation.
* Expanded travis testing grid based on `dplyr` implementation.
* Updated earliest supported R version based on travis testing - now `3.2.0`. 
* Used `usethis::use_tidy_versions()` to set package to dependent on package versions used during development work. Added this to makefile to make automated.
* Added a git commit step to the `Makefile` use with `make message="your commit message". This will automatically run all build steps that are required and then commit any changes. 

# getTBinR 0.5.7

## Feature updates

* Added support for `annual_change` to `summarise_tb_burden` and added validating tests.
* Added support for rates and proportions to  `summarise_tb_burden` and added validating tests.
* Added a new function - `plot_tb_burden_summary`. Function wraps `summarise_tb_burden` and allows all in one 
summary plotting. Inspired by [this](https://www.samabbott.co.uk/getTBinR/articles/case_study_global_trends.html) case study.
* Added a `rmarkdown` parameterised country level report on TB.
* Added a report generating button to the dashboard generated by `run_tb_dashboard`.
* Added `render_country_report` to generate a TB report for a given country.
* Tweaked `map_tb_burden` to not use `geom_path` for country outlines.
* Added a `smooth` argument to `plot_tb_burden` to allow smooth trend lines to be plotted (derived using `ggplot2::geom_smooth`).
* Tweaked line thickness in `plot_tb_burden` to improve plot appearance.
* Added `legend` argument to all plotting functions to allow control of the legend appearance.
* Added spell checking and list of allowed words.
* Automated package styling using `usethis::use_tidy_style()` via the `styler` package. Based on this [issue](https://github.com/seabbs/getTBinR/issues/89).

## Package updates

* Added script to generate hexsticker
* Added hexsticker to README
* Added DOI link to Zenodo.
* Updated tests to account for `dplyr` 8.0 release and `vdiffr` updates.
* Added `itdepends` to package report functionality.

# getTBinR 0.5.6

## Feature updates

* No new features in this release

## Package updates

* Updated custom legend setting in `map_tb_burden` to work with new version of rlang.
* Updated `map_tb_burden` tests to work with new version of R lang.
* Added dev to pkgdown site yml for docs prior to release.

# getTBinR 0.5.5

## Feature updates

* Added a years filter to `plot_tb_burden` and `plot_tb_burden_overview`. This allows a range of years to be plotted. The default is all years which was the previous de-facto default.  

## Package updates

* Updated docs to reflect new year of data.
* Updated examples to use the new year of data as standard.
* Updated README to always use the current year of data.
* Updated all vignettes to reflect new data or be fixed to historic data as appropriate.
* Update site with links out to blog posts using the newest version of [`pkgdown`](http://pkgdown.r-lib.org).

# getTBinR 0.5.4

## Feature updates

* Added MDR-TB data for 2016, see [here](http://www.who.int/tb/country/data/download/en/) for the dataset. The MDR-TB data is automatically joined to the WHO TB burden data.
* Aesthetic updates to `map_tb_burden`.
* Added new `summarise_tb_burden` function for summarising metrics across regions, across custom groups and globally.

## Package updates

* Improved data cleaning, converting `Inf` and `NaN` values to `NA` when the data is read in.
* Added `pgknet` report.
* Improved test robustness and scope
* Added `vdiffr` to test plots when not on CRAN.
* Fixed bug for `map_tb_burden` which was adding duplicate variables which caused map build to fail.

# getTBinR 0.5.3

## Feature updates

* Added `viridis_palette` option to all plotting functions to allow the colour scheme to be set by the user.
* Added ability to handle categories in the legend for `map_tb_burden`
* Added new case study exploring case fatality rates.

## Package updates

* Added improved tests in response to WHO data updates. See [here](https://github.com/seabbs/getTBinR/issues/28)
* Added an additional method for downloading data in response to test failures
on CRAN. See [here](https://github.com/seabbs/getTBinR/issues/29)
* Added skip on CRAN for data backend related tests.
* Added `Makefile` at top level and for `data-raw` to build the package.


# getTBinR 0.5.2

## Feature updates

* Improved plotly tool tips in all interactive plots.
* Added option to pass multiple years for interactive maps using the built in plotly frame functionality.

## Package updates

* Added retry download option to deal with possible API rate limits in response to [this issue](https://github.com/seabbs/getTBinR/issues/24).
* Added downloads badge to readme.


# getTBinR 0.5.1

## Feature updates

* Added `annual_change` argument to all plotting/mapping functions. Passed to `prepare_df_plot`. Returns the percentage annual change for the supplied metric.
* Added `trans` argument to all plotting functions to allow scaling using any `ggplot2::continous_scale` `trans` argument.
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

# getTBinR 0.5.0

## Feature updates

* Added `download_data` argument to all functions to make downloading data explicit.
* Added `save` argument to all functions to make saving the data explicit.
* Added `save_name` and `path` arguments to all functions to make location of saving explicit.

## Package updates

* Updated documentation to reflect above changes.
* Updated tests to reflect changes.
* Doc improvements ready for CRAN.
* Switched Imported packages from github versions to CRAN versions.
* Switched to saving data only to temporary directory (`tempdir()`)

# getTBinR 0.1.0

## Feature updates

* Added `map_tb_burden` function to map TB metrics.

## Package updates

* Added a `NEWS.md` file to track changes to the package.

# getTBinR 0.0.5

## Feature updates

* Added `plot_tb_burden_overview` function to plot an overview of the TB burden.

## Package updates

* Updated the package site.
* Refactored plotting code.

# getTBinR 0.0.1

## Feature updates

* Added `plot_tb_burden` function to plot TB burden

## Package updates

* Set up package infrastructure

