all: doc
.PHONY: doc rmobj

# build package documentation
doc:
	R -e 'devtools::document()'
