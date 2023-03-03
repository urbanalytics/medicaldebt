SOURCES = $(wildcard *.rnw)
FINALS = $(patsubst %.rnw, %.pdf, $(SOURCES))
TEX = $(patsubst %.rnw, %.tex, $(SOURCES))
# tex versions of the files, just to clean up

## run in parallel using 50% of available threads
PARALLEL := $(shell expr $(shell nproc) / 2 )
$(info using $(PARALLEL)-fold parallelism)
MAKEFLAGS += -j$(PARALLEL)


all: $(FINALS)

%.tex: %.rnw
	Rscript -e "knitr::knit('$<', quiet=FALSE)"

# keep TEX for debugging
.PRECIOUS: %.tex

%.pdf: %.tex
	latexmk -xelatex -f -interaction=nonstopmode $<

clean:
	rm -vf $(TEX) *.aux *.fdb_latexmk *.fls *.log *.out *.vrb *~ *.xdv *.nav *.toc\
	 *.snm *.tex &&\
	rm -rf figure
# -v : verbose
# -f: ignore non-existent files

## claim all pdf-s are updated.
## useful after diving into history and surfacing again
pdf-timestamp:
	touch *.pdf
