default: all
RDIR = .

all: who_shapefile.Rdata available_datasets.rds

## Update shape file
who_shapefile.Rdata: get_who_shapefile.R
			Rscript get_who_shapefile.R
			
## Update dataset data			
available_datasets.rds: available_datasets.R
			Rscript available_datasets.R
			