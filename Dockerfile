## Start with the shiny docker image
FROM rocker/tidyverse:latest

MAINTAINER "Sam Abbott" contact@samabbott.co.uk

RUN apt-get install -y \
    texlive-latex-recommended \
    texinfo \
    libqpdf-dev \
    && apt-get clean
    
ADD . /home/rstudio/getTBinR

RUN Rscript -e 'devtools::install_github("hadley/pkgdown")'

RUN Rscript -e 'devtools::install_dev_deps("home/rstudio/getTBinR")'

RUN Rscript -e 'devtools::install("home/rstudio/getTBinR")'