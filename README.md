
getTBinR: Access and Summarise World Health Organisation Tuberculosis Data <img src="man/figures/logo.png" align="right" alt="" width="120" />
==============================================================================================================================================

[![CRAN\_Release\_Badge](http://www.r-pkg.org/badges/version-ago/getTBinR)](https://CRAN.R-project.org/package=getTBinR) [![develVersion](https://img.shields.io/badge/devel%20version-0.5.8-blue.svg?style=flat)](https://github.com/getTBinR) [![Documentation via pkgdown](https://img.shields.io/badge/Documentation-click%20here!-lightgrey.svg?style=flat)](https://www.samabbott.co.uk/getTBinR/) [![Development documentation via pkgdown](https://img.shields.io/badge/Development%20Documentation-click%20here!-lightblue.svg?style=flat)](https://www.samabbott.co.uk/getTBinR/dev) [![badge](https://img.shields.io/badge/launch-getTBinR-579ACA.svg?logo=data:image/png;base64,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)](https://mybinder.org/v2/gh/seabbs/getTBinR/master?urlpath=rstudio) [![Travis-CI Build Status](https://travis-ci.org/seabbs/getTBinR.svg?branch=master)](https://travis-ci.org/seabbs/getTBinR) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/seabbs/getTBinR?branch=master&svg=true)](https://ci.appveyor.com/project/seabbs/getTBinR) [![Coverage Status](https://img.shields.io/codecov/c/github/seabbs/getTBinR/master.svg)](https://codecov.io/github/seabbs/getTBinR?branch=master) [![metacran monthly downloads](http://cranlogs.r-pkg.org/badges/getTBinR)](https://cran.r-project.org/package=getTBinR) [![metacran downloads](http://cranlogs.r-pkg.org/badges/grand-total/getTBinR?color=ff69b4)](https://cran.r-project.org/package=getTBinR) [![DOI](https://zenodo.org/badge/112591837.svg)](https://zenodo.org/badge/latestdoi/112591837)

Quickly and easily import analysis ready Tuberculosis (TB) burden data, from the World Health Organisation (WHO), into R. The aim of `getTBinR` is to allow researchers, and other interested individuals, to quickly and easily gain access to a detailed TB data set and to start using it to derive key insights. It provides a consistent set of tools that can be used to rapidly evaluate hypotheses on a widely used data set before they are explored further using more complex methods or more detailed data. These tools include: generic plotting and mapping functions; a data dictionary search tool; an interactive shiny dashboard; and an automated, country level, TB report. For newer R users, this package reduces the barrier to entry by handling data import, munging, and visualisation. All plotting and mapping functions are built with `ggplot2` so can be readily extended. See [here](http://www.who.int/about/copyright/en/) for the WHO data permissions. For help getting started see the [Getting Started](https://www.samabbott.co.uk/getTBinR/articles/intro.html) vignette and for a case study using the package see the [Exploring Global Trends in Tuberculosis Incidence Rates](https://www.samabbott.co.uk/getTBinR/articles/case_study_global_trends.html) vignette.

Installation
------------

Install the CRAN version:

``` r
install.packages("getTBinR")
```

Alternatively install the development version from GitHub:

``` r
# install.packages("devtools")
devtools::install_github("seabbs/getTBinR")
```

Quick start
-----------

Lets get started quickly by mapping and then plotting TB incidence rates in the United Kingdom. First map the most recently available global TB incidence rates (this will also download and save both the TB burden data and its data dictionary, if they are not found locally, to R's temporary directory),

``` r
getTBinR::map_tb_burden(metric = "e_inc_100k")
#> Downloading data from: https://extranet.who.int/tme/generateCSV.asp?ds=estimates
#> Saving data to: /tmp/RtmpbrM7rc/TB_burden.rds
#> Downloading data from: https://extranet.who.int/tme/generateCSV.asp?ds=mdr_rr_estimates
#> Saving data to: /tmp/RtmpbrM7rc/MDR_TB.rds
#> Joining TB burden data and MDR TB data.
#> Downloading data from: https://extranet.who.int/tme/generateCSV.asp?ds=dictionary
#> Saving data to: /tmp/RtmpbrM7rc/TB_data_dict.rds
#> 1 results found for your variable search for e_inc_100k
```

![](man/figures/map-tb-incidence-eur-1.png)

Then compare TB incidence rates in the UK to TB incidence rates in other countries in the region,

``` r
getTBinR::plot_tb_burden_overview(metric = "e_inc_100k",
                                  countries = "United Kingdom",
                                  compare_to_region = TRUE,
                                  interactive = FALSE)
#> Loading data from: /tmp/RtmpbrM7rc/TB_burden.rds
#> Loading data from: /tmp/RtmpbrM7rc/MDR_TB.rds
#> Joining TB burden data and MDR TB data.
#> Loading data from: /tmp/RtmpbrM7rc/TB_data_dict.rds
#> 1 results found for your variable search for e_inc_100k
```

![](man/figures/plot-tb-incidence-eur-1.png)

In order to compare the changes in incidence rates over time, in the region, plot the annual percentage change,

``` r
getTBinR::plot_tb_burden_overview(metric = "e_inc_100k",
                                  countries = "United Kingdom",
                                  compare_to_region = TRUE,
                                  annual_change = TRUE,
                                  interactive = FALSE)
#> Loading data from: /tmp/RtmpbrM7rc/TB_burden.rds
#> Loading data from: /tmp/RtmpbrM7rc/MDR_TB.rds
#> Joining TB burden data and MDR TB data.
#> Loading data from: /tmp/RtmpbrM7rc/TB_data_dict.rds
#> 1 results found for your variable search for e_inc_100k
```

![](man/figures/plot-tb-incidence-eur-per-1.png)

Now plot TB incidence rates over time in the United Kingdom, compared to TB incidence rates in Europe and globally.

``` r
getTBinR::plot_tb_burden_summary(metric = "e_inc_num",
                                 metric_label = "e_inc_100k",
                                 countries = "United Kingdom",
                                 legend = "top",
                                 compare_all_regions = FALSE,
                                 compare_to_region = TRUE,
                                 compare_to_world = TRUE,
                                 interactive = FALSE)
#> Loading data from: /tmp/RtmpbrM7rc/TB_data_dict.rds
#> 1 results found for your variable search for e_inc_100k
#> Extracting data for specified countries
#> Loading data from: /tmp/RtmpbrM7rc/TB_burden.rds
#> Loading data from: /tmp/RtmpbrM7rc/MDR_TB.rds
#> Joining TB burden data and MDR TB data.
#> Loading data from: /tmp/RtmpbrM7rc/TB_data_dict.rds
#> 1 results found for your variable search for e_inc_num
#> Loading data from: /tmp/RtmpbrM7rc/TB_burden.rds
#> Loading data from: /tmp/RtmpbrM7rc/MDR_TB.rds
#> Joining TB burden data and MDR TB data.
#> Loading data from: /tmp/RtmpbrM7rc/TB_data_dict.rds
#> 1 results found for your variable search for e_inc_num
#> Loading data from: /tmp/RtmpbrM7rc/TB_burden.rds
#> Loading data from: /tmp/RtmpbrM7rc/MDR_TB.rds
#> Joining TB burden data and MDR TB data.
#> Loading data from: /tmp/RtmpbrM7rc/TB_data_dict.rds
#> 1 results found for your variable search for e_inc_num
```

![](man/figures/plot-tb-incidence-uk-compare-1.png)

Finally we repeat the above plot but this time only for the UK - this allows us to get a clear picture of trends in TB incidence rates in the UK.

``` r
getTBinR::plot_tb_burden(metric = "e_inc_100k",
                         countries = "United Kingdom",
                         interactive = FALSE)
#> Loading data from: /tmp/RtmpbrM7rc/TB_burden.rds
#> Loading data from: /tmp/RtmpbrM7rc/MDR_TB.rds
#> Joining TB burden data and MDR TB data.
#> Loading data from: /tmp/RtmpbrM7rc/TB_data_dict.rds
#> 1 results found for your variable search for e_inc_100k
```

![](man/figures/plot-tb-incidence-uk-1.png)

See [Functions](https://www.samabbott.co.uk/getTBinR/reference/index.html) for more details of the functions used (note the fuzzy country matching, `map_tb_burden`, `plot_tb_burden_overview`, `plot_tb_burden_summary` and `plot_tb_burden` will try to exactly match your country request and if that fails will search for partial matches) and for more package functionality. We could make these plots interactive by specifying `interactive = TRUE`

Shiny Dashboard
---------------

To explore the package functionality in an interactive session, or to investigate TB without having to code extensively in R, a shiny dashboard has been built into the package. This can either be used locally using,

``` r
getTBinR::run_tb_dashboard()
```

Or accessed [online](http://www.seabbs.co.uk/shiny/ExploreGlobalTB). Any metric in the WHO data can be explored, with country selection using the built in map, and animation possible by year.

![Snapshot of the integrated dashboard.](man/figures/ExploreGlobalTB.png)

Country Report
--------------

To get a detailed overview of TB in a country of your choice run the following, alternatively available from the built in dashboard above.

``` r
## Code saves report into your current working directory
render_country_report(country = "United Kingdom", save_dir = ".")
```

![Example report for the United Kingdom.](man/figures/ExampleCountryReport.png)

Contributing
------------

File an issue [here](https://github.com/seabbs/getTBinR/issues) if there is a feature, or a dataset, that you think is missing from the package, or better yet submit a pull request!

Please note that the `getTBinR` project is released with a [Contributor Code of Conduct](.github/CODE_OF_CONDUCT.md). By contributing to this project, you agree to abide by its terms.

Citing
------

If using `getTBinR` please consider citing the package in the relevant work. Citation information can be generated in R using the following (after installing the package),

``` r
citation("getTBinR")
#> 
#> To cite getTBinR in publications use:
#> 
#>   Sam Abbott (2019). getTBinR: an R package for accessing and
#>   summarising the World Health Organisation Tuberculosis data
#>   Journal of Open Source Software, 40(3), 1-25. doi:
#> 
#> A BibTeX entry for LaTeX users is
#> 
#>   @Article{,
#>     title = {getTBinR: an R package for accessing and summarising the World Health Organisation Tuberculosis data},
#>     author = {Sam Abbott},
#>     journal = {Journal of Open Source Software},
#>     year = {2019},
#>     volume = {40},
#>     number = {3},
#>     pages = {1--25},
#>   }
```

Docker
------

This package has been developed in docker based on the `rocker/tidyverse` image, to access the development environment enter the following at the command line (with an active docker daemon running),

``` bash
docker pull seabbs/gettbinr
docker run -d -p 8787:8787 -e USER=getTBinR -e PASSWORD=getTBinR --name getTBinR seabbs/gettbinr
```

The rstudio client can be accessed on port `8787` at `localhost` (or your machines ip). The default username is getTBinR and the default password is getTBinR. Alternatively, access the development environment via [binder](https://mybinder.org/v2/gh/seabbs/getTBinR/master?urlpath=rstudio).
