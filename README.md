
Get TB Data in R <img src="man/figure/logo.png" align="right" alt="" width="120" />
===================================================================================

[![CRAN\_Release\_Badge](http://www.r-pkg.org/badges/version-ago/getTBinR)](https://CRAN.R-project.org/package=getTBinR) [![develVersion](https://img.shields.io/badge/devel%20version-0.5.7-blue.svg?style=flat)](https://github.com/getTBinR) [![Travis-CI Build Status](https://travis-ci.org/seabbs/getTBinR.svg?branch=master)](https://travis-ci.org/seabbs/getTBinR) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/seabbs/getTBinR?branch=master&svg=true)](https://ci.appveyor.com/project/seabbs/getTBinR) [![Coverage Status](https://img.shields.io/codecov/c/github/seabbs/getTBinR/master.svg)](https://codecov.io/github/seabbs/getTBinR?branch=master) [![metacran monthly downloads](http://cranlogs.r-pkg.org/badges/getTBinR)](https://cran.r-project.org/package=getTBinR) [![metacran downloads](http://cranlogs.r-pkg.org/badges/grand-total/getTBinR?color=ff69b4)](https://cran.r-project.org/package=getTBinR)

Quickly and easily import analysis ready TB burden data, from the World Health Organisation (WHO), into R. The aim of the package is to speed up access to high quality TB burden data, using a simple R interface. Generic plotting functions are provided to allow for rapid graphical exploration of the WHO TB data. A shiny dashboard is built in to showcase package functionality. See [here](http://www.who.int/about/copyright/en/) for the WHO data permissions. For help getting started see the [Getting Started](https://www.samabbott.co.uk/getTBinR/articles/intro.html) vignette and for a case study using the package see the [Exploring Global Trends in Tuberculosis Incidence Rates](https://www.samabbott.co.uk/getTBinR/articles/case_study_global_trends.html) vignette. See [here](https://www.samabbott.co.uk/getTBinR/dev) for the development documentation.

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
#> Saving data to: /tmp/Rtmpxak0fv/TB_burden.rds
#> Downloading data from: https://extranet.who.int/tme/generateCSV.asp?ds=mdr_rr_estimates
#> Saving data to: /tmp/Rtmpxak0fv/MDR_TB.rds
#> Joining TB burden data and MDR TB data.
#> Joining, by = c("country", "iso2", "iso3", "iso_numeric", "year")
#> Downloading data from: https://extranet.who.int/tme/generateCSV.asp?ds=dictionary
#> Saving data to: /tmp/Rtmpxak0fv/TB_data_dict.rds
#> 1 results found for your variable search for e_inc_100k
```

![](man/figure/map-tb-incidence-eur-1.png)

Then compare TB incidence rates in the UK to TB incidence rates in other countries in the region,

``` r
getTBinR::plot_tb_burden_overview(metric = "e_inc_100k",
                                  countries = "United Kingdom",
                                  compare_to_region = TRUE,
                                  interactive = FALSE)
#> Loading data from: /tmp/Rtmpxak0fv/TB_burden.rds
#> Loading data from: /tmp/Rtmpxak0fv/MDR_TB.rds
#> Joining TB burden data and MDR TB data.
#> Joining, by = c("country", "iso2", "iso3", "iso_numeric", "year")
#> Loading data from: /tmp/Rtmpxak0fv/TB_data_dict.rds
#> 1 results found for your variable search for e_inc_100k
```

![](man/figure/plot-tb-incidence-eur-1.png)

In order to compare the changes in incidence rates over time, in the region, plot the annual percentage change (note that this functionality is currently only available in the development version of the package),

``` r
getTBinR::plot_tb_burden_overview(metric = "e_inc_100k",
                                  countries = "United Kingdom",
                                  compare_to_region = TRUE,
                                  annual_change = TRUE,
                                  interactive = FALSE)
#> Loading data from: /tmp/Rtmpxak0fv/TB_burden.rds
#> Loading data from: /tmp/Rtmpxak0fv/MDR_TB.rds
#> Joining TB burden data and MDR TB data.
#> Joining, by = c("country", "iso2", "iso3", "iso_numeric", "year")
#> Loading data from: /tmp/Rtmpxak0fv/TB_data_dict.rds
#> 1 results found for your variable search for e_inc_100k
#> Warning: Removed 18 rows containing missing values (geom_point).
```

![](man/figure/plot-tb-incidence-eur-per-1.png)

Finally plot TB incidence rates over time in the United Kingdom.

``` r
getTBinR::plot_tb_burden(metric = "e_inc_100k",
                         countries = "United Kingdom",
                         facet = "country",
                         interactive = FALSE)
#> Loading data from: /tmp/Rtmpxak0fv/TB_burden.rds
#> Loading data from: /tmp/Rtmpxak0fv/MDR_TB.rds
#> Joining TB burden data and MDR TB data.
#> Joining, by = c("country", "iso2", "iso3", "iso_numeric", "year")
#> Loading data from: /tmp/Rtmpxak0fv/TB_data_dict.rds
#> 1 results found for your variable search for e_inc_100k
```

![](man/figure/plot-tb-incidence-uk-1.png)

See [Functions](https://www.samabbott.co.uk/getTBinR/reference/index.html) for more details of the functions used (note the fuzzy country matching, `map_tb_burden`, `plot_tb_burden_overview` and `plot_tb_burden` will try to exactly match your country request and if that fails will search for partial matches) and for more package functionality. We could make these plots interactive by specifying `interactive = TRUE`

Shiny Dashboard
---------------

To explore the package functionality in an interactive session, or to investigate TB without having to code extensively in R, a shiny dashboard has been built into the package. This can either be used locally using,

``` r
getTBinR::run_tb_dashboard()
```

Or accessed [online](http://www.seabbs.co.uk/shiny/ExploreGlobalTB). Any metric in the WHO data can be explored, with country selection using the built in map, and animation possible by year.

![](man/img/ExploreGlobalTB.png)

Additional Functionality
------------------------

File an issue [here](https://github.com/seabbs/getTBinR/issues) if there is a feature, or a dataset, that you think is missing from the package, or better yet submit a pull request!

Docker
------

This package has been developed in docker based on the `rocker/tidyverse` image, to access the development environment enter the following at the command line (with an active docker daemon running),

``` bash
docker pull seabbs/gettbinr
docker run -d -p 8787:8787 -e USER=getTBinR -e PASSWORD=getTBinR --name getTBinR seabbs/gettbinr
```

The rstudio client can be accessed on port `8787` at `localhost` (or your machines ip). The default username is getTBinR and the default password is getTBinR.
