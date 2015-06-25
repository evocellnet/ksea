
RSCRIPT = $(shell which Rscript)

all: doc README.md
.PHONY: doc rmobj

# build package documentation
doc:
	R -e 'devtools::document()'

README.md: README.Rmd
	$(RSCRIPT) --vanilla \
	-e "require(knitr)" \
	-e "knit('$<', out='$@')"
