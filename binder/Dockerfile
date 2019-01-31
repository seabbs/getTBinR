FROM rocker/binder:latest

USER root
COPY . ${HOME}
RUN chown -R ${NB_USER} ${HOME}

RUN apt-get update -y && \
    apt-get install -y \
    texlive-latex-recommended \
    texlive-fonts-extra \
    texinfo \
    libqpdf-dev \
    libmagick++-dev \
    && apt-get clean
    
## Become normal user again
USER ${NB_USER}
    
RUN R -e "devtools::install_github('seabbs/getTBinR', dependencies = TRUE);"