## Get WHO TB shapefile from the TB WHo global report repo
download.file("https://github.com/hazimtimimi/global_report/raw/master/Data/gparts.Rdata",
              destfile = "data-raw/who_shapefile.Rdata")

load("data-raw/who_shapefile.Rdata")

who_shapefile <- gworld

## Add to package
devtools::use_data(who_shapefile, overwrite = TRUE)

