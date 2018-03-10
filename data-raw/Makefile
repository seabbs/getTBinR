default: all
RDIR = .

all: who_shapefile.Rdata

## Update incidence rate data
who_shapefile.Rdata: get_who_shapefile.R
			Rscript get_who_shapefile.R
