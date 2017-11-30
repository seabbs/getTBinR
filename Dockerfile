## Start with the shiny docker image
FROM rocker/tidyverse:latest

MAINTAINER "Sam Abbott" contact@samabbott.co.uk

ADD . /home/rstudio/getTBinR

RUN Rscript -e 'devtools::install_github("tidyverse/ggplot2")'

RUN Rscript -e 'devtools::install_dev_deps("home/rstudio/getTBinR")'

RUN Rscript -e 'devtools::install("home/rstudio/getTBinR")'
