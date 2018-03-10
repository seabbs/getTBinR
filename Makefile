

default: all


all: build_data package docs README.md site


#Update data
.PHONY: build_data
build_data:
		cd data-raw && make

#build update documents and build package
package:
		 R CMD INSTALL --no-multiarch --with-keep.source .
		 
docs:
     Rscript -e 'devtools::document(roclets=c('rd', 'collate', 'namespace'))'

#update readme
README.md: README.Rmd
		Rscript -e 'rmarkdown::render("README.Rmd")'
		rm README.html

#build pkgdown site
site: 
     Rscript -e 'pkgdown::build_site()'