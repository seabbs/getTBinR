---
title: 'getTBinR: an R package for accessing and summarising the World Health Organisation Tuberculosis data'
tags:
  - R
  - rstats
  - World Health Organisation
  - Open Data
  - Visualisation
  - Infectious Disease
  - Tuberculosis
authors:
  - name: Sam Abbott
    orcid: 0000-0001-8057-8037
    affiliation: "1"
affiliations:
  - name:  'Bristol Medical School: Population Health Sciences, University of Bristol, Bristol, UK'
    index: 1
date: 29 January 2019
bibliography: paper.bib
---
  

# Summary
  
Developing tools for rapidly accessing and exploring data sets benefits the public health research community by enabling multiple data sets to be combined in a consistent manner, increasing the visibility of key data sets, and providing a framework that can be used to explore key questions of interest. Tooling also reduces the barriers to entry, allowing non-specialists to explore data sets that would otherwise be inaccessible. This widening of access may also lead to new insights and wider interest for key public health issues.
  
``getTBinR`` is an R package [@RCoreTeam2019] to facilitate working with the data [@WHO:2018] collected by the World Health Organisation (WHO) on the country level epidemiology of Tuberculosis (TB). All data is freely available from the [WHO](https://www.who.int/tb/country/data/download/en/) and the package code is archived on Zenodo [@Abbott:2019] and [Github](https://www.samabbott.co.uk/getTBinR/). The aim of ``getTBinR`` is to allow researchers, and other interested individuals, to quickly and easily gain access to a detailed TB data set and to start using it to derive key insights. It provides a consistent set of tools that can be used to rapidly evaluate hypotheses on a widely used data set before they are explored further using more complex methods or more detailed data. The functions provided in this package were developed to have sensible defaults to allow those new to the field to quickly gain key insights but also allow sufficient customisation so that experienced users may rapidly prototype new ideas. 

The data sourced by ``getBTinR`` is collected by the WHO, via member governments, and used to compile the yearly global TB report [@WHO:2018]. Data collection encompasses TB incidence, TB mortality rates, the age distribution of TB cases, the proportion of drug resistant cases, case detection rates, and treatment rates. For a complete description of the data and data collection process, see [@WHO:2018]. These data are used by the WHO, governmental organisations and researchers to summarise country level TB epidemiology, as well as the wider global and regional picture.

The ``getTBinR`` package facilitates downloading the most up-to-date version of multiple TB relevant data sources from the WHO, along with the accompanying data dictionaries. It also contains functions to allow easy exploration of the data via searching data dictionaries, summarising key metrics on a regional and global level, and visualising the data in a variety of highly customisable ways. In addition, it provides both a dashboard and an automated country level report that enables the global, regional, and country level picture to be quickly summarised. An example of a potential use of the package is to explore estimates of the TB case fatality ratio [@Abbott:2018]. In a few lines of code, using only built in package tooling, large regional differences can be discovered. Further insights can then be found by linking to other publicly available data sets or using a model based analysis. See https://www.samabbott.co.uk/getTBinR/ for documentation. 

# Acknowledgements

Thanks to the staff at the World Health Organisation for compiling the data sets used in this package. SA is funded by the National Institute for Health Research Health Protection Research Unit (NIHR HPRU) in Evaluation of Interventions at University of Bristol in partnership with Public Health England (PHE). The views expressed are those of the author and not necessarily those of the NHS, the NIHR, the Department of Health or Public Health England.


# References
