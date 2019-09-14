FROM rocker/binder:latest

USER root
COPY . ${HOME}
RUN chown -R ${NB_USER} ${HOME}

## Become normal user again
USER ${NB_USER}

RUN R -e "options(repos = 'https://cloud.r-project.org/'); install.packages('getTBinR')"

RUN R -e "devtools::install_dev_deps()"
