
# Packages ----------------------------------------------------------------

library(dplyr)
library(tibble)
library(magrittr)


# Available data sources --------------------------------------------------

available_datasets <- tibble(
  dataset = "Estimates",
  description = "Generated estimates of TB mortality, incidence, case fatality ratio, and treatment coverage
  (previously called case detection rate). Data available split by HIV status.", 
  url = "https://extranet.who.int/tme/generateCSV.asp?ds=estimates", 
  default = "yes", 
  timespan = "2000-2017"
) %>% 
  add_row(
  dataset = "Estimates",
  description = "Generated estimates for the proportion of TB cases that have rifampicin-resistant TB 
  (RR-TB, which includes cases with multidrug-resistant TB, MDR-TB), RR/MDR-TB among notified
  pulmonary TB cases.", 
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
  description = "TB notification dataset: Very wide with lots of fields linking to TB notifications as raw numbers.
  Age-stratified. Good data dictionary coverage. Wide format.", 
  url = "https://extranet.who.int/tme/generateCSV.asp?ds=notifications", 
  default = "no", 
  timespan = "1980-2017"
  ) %>% 
  add_row(
  dataset = "Drug resistance surveillance",
  description = "Country level drug resistance surveillance: Lists DR data from country level reporting. 
  May overlap with MDR data already included. Good data dictionary coverage.", 
  url = "https://extranet.who.int/tme/generateCSV.asp?ds=dr_surveillance", 
  default = "no", 
  timespan = "2017"
  ) %>% 
  add_row(
  dataset = "Non-routine HIV surveillance",
  description = "Good data dictionary coverage. Lots of missing data.", 
  url = "https://extranet.who.int/tme/generateCSV.asp?ds=tbhivnonroutinesurv", 
  default = "no", 
  timespan = "2007-2017"
  ) %>% 
  add_row(
  dataset = "Outcomes",
  description = "TB outcomes data: List of numeric outcome data, very messy but with good data dictionary coverage.
  Wide format so could be easily linked. Multiple years of coverage.", 
  url = "https://extranet.who.int/tme/generateCSV.asp?ds=outcomes", 
  default = "no", 
  timespan = "1994-2017"
  ) %>% 
  add_row(
  dataset = "Budget",
  description = "Current year budget: Wide format with many cryptic fields but has data dictionary coverage.", 
  url = "https://extranet.who.int/tme/generateCSV.asp?ds=budget", 
  default = "no", 
  timespan = "2018"
  ) %>% 
  add_row(
  dataset = "Expenditure and utilisation",
  description = "Previous year expenditure: Lots of expenditure fields, with good data dictionary coverage.", 
  url = "https://extranet.who.int/tme/generateCSV.asp?ds=expenditure_utilisation", 
  default = "no", 
  timespan = "2017"
  ) %>% 
  add_row(
  dataset = "Policies and services",
  description = "TB policies: see the data dictionary for details. Lists policies that have been implemented.", 
  url = "https://extranet.who.int/tme/generateCSV.asp?ds=policies", 
  default = "no", 
  timespan = "2017"
  ) %>% 
  add_row(
  dataset = "Community engagement",
  description = "Lists community engagement programmes etc. - see the data dictionary for details.", 
  url = "https://extranet.who.int/tme/generateCSV.asp?ds=community", 
  default = "no", 
  timespan = "2013-2017"
  ) %>% 
  add_row(
  dataset = "Laboratories",
  description = "Laboratory data - see the data dictionary for details.", 
  url = "https://extranet.who.int/tme/generateCSV.asp?ds=labs", 
  default = "no", 
  timespan = "2009-2017"
  ) %>% 
  select(dataset, description, timespan, default, url)
  
## Save as raw data
saveRDS(available_datasets, "available_datasets.rds")

## Add to package
usethis::use_data(available_datasets, overwrite = TRUE)



