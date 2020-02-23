

default: all


all: build_data update_deps styling package docs man/figures/logo.png README.md check_package git_commit

#Update data
.PHONY: build_data
build_data:
		cd data-raw && make

## Update dependencies based on those installed
.PHONY: update_deps
update_deps:
		 Rscript -e "usethis::use_tidy_versions(overwrite = TRUE)"
	
## Update package styling
.PHONY: styling
styling: 
		Rscript -e 'styler::style_pkg(".", style = styler::tidyverse_style, strict = TRUE)'
		
#build update documents and build package
.PHONY: package
package:
		 R CMD INSTALL --no-multiarch --with-keep.source .

.PHONY: docs		 
docs:
     Rscript -e 'devtools::document(roclets=c('rd', 'collate', 'namespace'))'

#update logo
man/figures/logo.png: inst/scripts/generate_hex_sticker.R
		Rscript inst/scripts/generate_hex_sticker.R
		
#update readme
README.md: README.Rmd
		Rscript -e 'rmarkdown::render("README.Rmd")' && \
		rm README.html

## Check package locally
.PHONY: check_package
check_package: 
		Rscript -e "devtools::check()"
			
			
#Commit updates
.PHONY: git_commit
git_commit:
		git add --all
		git commit -m "$(message)"
		git push
