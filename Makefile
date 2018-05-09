

default: all


all: build_data package docs README.md build_report site

#Update data
.PHONY: build_data
build_data:
		cd data-raw && make

#build update documents and build package
.PHONY: package
package:
		 R CMD INSTALL --no-multiarch --with-keep.source .

.PHONY: docs		 
docs:
     Rscript -e 'devtools::document(roclets=c('rd', 'collate', 'namespace'))'

#update readme
README.md: README.Rmd
		Rscript -e 'rmarkdown::render("README.Rmd")'
		rm README.html

#generate pknet report
.PHONY: build_report
build_report:
		cd pkgnet && make
		
#build pkgdown site
.PHONY: site
site: 
		 cp -r man/img docs/man/img
		 cp -r man/figure docs/man/figure
     Rscript -e 'pkgdown::build_site()'