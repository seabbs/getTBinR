
# Packages ----------------------------------------------------------------

library(dplyr)
library(tibble)
library(magrittr)


# Available data sources --------------------------------------------------

available_datasets <- tibble(
  dataset = "Estimates",
  description = "Generated estimates of TB mortality, incidence, case fatality ratio, and treatment coverage (previously called case detection rate). Data available split by HIV status.", 
  url = "https://extranet.who.int/tme/generateCSV.asp?ds=estimates", 
  default = "yes", 
  timespan = "2000-2017"
) %>% 
  add_row(
  dataset = "Estimates",
  description = "Generated estimates for the proportion of TB cases that have rifampicin-resistant TB (RR-TB, which includes cases with multidrug-resistant TB, MDR-TB), RR/MDR-TB among notified pulmonary TB cases.", 
  url = "https://extranet.who.int/tme/generateCSV.asp?ds=mdr_rr_estimates", 
  default = "yes", 
  timespan = "2017"
  ) %>% 
  add_row(
  dataset = "Latent TB infection",
  description = "Generated estimates incidence of latent TB stratified by age.", 
  url = "https://extranet.who.int/tme/generateCSV.asp?ds=ltbi_estimates", 
  default = "no", 
  timespan = "2017"
  ) %>% 
  add_row(
  dataset = "Notification",
  description = "TB notification dataset linking to TB notifications as raw numbers. Age-stratified, with good data dictionary coverage but has large amounts of missing data.", 
  url = "https://extranet.who.int/tme/generateCSV.asp?ds=notifications", 
  default = "no", 
  timespan = "1980-2017"
  ) %>% 
  add_row(
  dataset = "Drug resistance surveillance",
  description = "Country level drug resistance surveillance. Lists drug resistance data from country level reporting. Good data dictionary coverage but has large amounts of missing data.", 
  url = "https://extranet.who.int/tme/generateCSV.asp?ds=dr_surveillance", 
  default = "no", 
  timespan = "2017"
  ) %>% 
  add_row(
  dataset = "Non-routine HIV surveillance",
  description = "Country level, non-routine HIV surveillance data. Good data dictionary coverage but with a large amount of missing data.", 
  url = "https://extranet.who.int/tme/generateCSV.asp?ds=tbhivnonroutinesurv", 
  default = "no", 
  timespan = "2007-2017"
  ) %>% 
  add_row(
  dataset = "Outcomes",
  description = "Country level TB outcomes data. Lists numeric outcome data, very messy but with good data dictionary coverage.", 
  url = "https://extranet.who.int/tme/generateCSV.asp?ds=outcomes", 
  default = "no", 
  timespan = "1994-2017"
  ) %>% 
  add_row(
  dataset = "Budget",
  description = "Current year TB intervention budgets per country. Many of the data fields are cryptic but has good data dictionary coverage.", 
  url = "https://extranet.who.int/tme/generateCSV.asp?ds=budget", 
  default = "no", 
  timespan = "2018"
  ) %>% 
  add_row(
  dataset = "Expenditure and utilisation",
  description = "Previous year expenditure on TB interventions. Highly detailed, with good data dictionary coverage but lots of missing data.", 
  url = "https://extranet.who.int/tme/generateCSV.asp?ds=expenditure_utilisation", 
  default = "no", 
  timespan = "2017"
  ) %>% 
  add_row(
  dataset = "Policies and services",
  description = "Lists TB policies that have been implemented per country. Highly detailed, with good data dictionary coverage but lots of missing data.", 
  url = "https://extranet.who.int/tme/generateCSV.asp?ds=policies", 
  default = "no", 
  timespan = "2017"
  ) %>% 
  add_row(
  dataset = "Community engagement",
  description = "Lists community engagement programmes. Highly detailed, with good data dictionary coverage but lots of missing data.", 
  url = "https://extranet.who.int/tme/generateCSV.asp?ds=community", 
  default = "no", 
  timespan = "2013-2017"
  ) %>% 
  add_row(
  dataset = "Laboratories",
  description = "Country specific laboratory data. Highly detailed, with good data dictionary coverage but lots of missing data.", 
  url = "https://extranet.who.int/tme/generateCSV.asp?ds=labs", 
  default = "no", 
  timespan = "2009-2017"
  ) %>% 
  select(dataset, description, timespan, default, url)
  
## Save as raw data
saveRDS(available_datasets, "available_datasets.rds")

## Add to package
usethis::use_data(available_datasets, overwrite = TRUE)



