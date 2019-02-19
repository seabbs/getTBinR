## Start with the shiny docker image
FROM rocker/tidyverse:latest

MAINTAINER "Sam Abbott" contact@samabbott.co.uk

RUN apt-get update -y && \
    apt-get install -y \
    texlive-latex-recommended \
    texlive-fonts-extra \
    texinfo \
    libqpdf-dev \
    libmagick++-dev \
    && apt-get clean

ADD . /home/rstudio/getTBinR

RUN Rscript -e 'devtools::install_github("r-lib/pkgdown")'

RUN Rscript -e 'devtools::install_dev_deps("home/rstudio/getTBinR")'

RUN Rscript -e 'devtools::install("home/rstudio/getTBinR")'