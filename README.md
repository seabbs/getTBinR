
Get TB Data in R
================

[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/getTBinR)](https://cran.r-project.org/package=getTBinR) [![Travis-CI Build Status](https://travis-ci.org/%3CUSERNAME%3E/%3CREPO%3E.svg?branch=master)](https://travis-ci.org/%3CUSERNAME%3E/%3CREPO%3E) [![Coverage Status](https://img.shields.io/codecov/c/github/%3CUSERNAME%3E/%3CREPO%3E/master.svg)](https://codecov.io/github/%3CUSERNAME%3E/%3CREPO%3E?branch=master)

This package contains functions to download and clean data made available by the World Health Organisation (WHO), see [here](http://www.who.int/about/copyright/en/) for permissions.

Installation
------------

You can install getTBinR from github with:

``` r
# install.packages("devtools")
devtools::install_github("seabbs/getTBinR")
```

### Docker

This package has been developed in docker based on the `rocker/tidyverse` image, to access the development environment enter the following at the command line (with an active docker daemon running),

``` bash
docker pull seabbs/getTBinR
docker run -d -p 8787:8787 -p 54321:54321 -e USER=getTBinR -e PASSWORD=getTBinR --name getTBinR seabbs/getTBinR
```

The rstudio client can be accessed on port `8787` at `localhost` (or your machines ip). The default username is getTBinR and the default password is getTBinR.
