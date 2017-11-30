## Start with the shiny docker image
FROM rocker/tidyverse:latest

MAINTAINER "Sam Abbott" contact@samabbott.co.uk

RUN apt-get update -qq \
  && apt-get -y --no-install-recommends install \
    default-jdk \
    default-jre \
  && R CMD javareconf

EXPOSE 54321

ADD . /home/rstudio/h2ohelper

RUN Rscript -e 'devtools::install_dev_deps("home/rstudio/h2ohelper")'

RUN Rscript -e 'devtools::install("home/rstudio/h2ohelper")'
