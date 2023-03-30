## -------------------- folders --------------------
PROJECTDIR = $(HOME)/projects/afbiz
CODEDIR = $(PROJECTDIR)/code
FIGSDIR = $(PROJECTDIR)/figs
FIGS1802DIR = $(FIGSDIR)/2018-02
SCRIPTSDIR = $(CODEDIR)/shellscripts
ifeq ($(HOSTNAME),is-xavi)
LOGSDIR = $(HOME)/logs
else
LOGSDIR = $(PROJECTDIR)/logs
endif
MODULESDIR = $(CODEDIR)/modules
DATADIR = $(PROJECTDIR)/data
MAPDIR = $(DATADIR)/map
ifeq ($(HOSTNAME),is-messi)
BIGDATADIR = $(HOME)/data
endif
GEODIR = $(DATADIR)/geographic
GEOPANELDIR=$(DATADIR)/geopanel
VIOLENCEDIR = $(DATADIR)/violence
WRITINGDIR = $(PROJECTDIR)/writing
CONFIDENTIAL_DATADIR = $(HOME)/data
PCA_HEATMAPDIR = $(PROJECTDIR)/pca_heatmaps
ACSOR_MAP_DIR = $(PROJECTDIR)/acsor_insecurity_maps
PRESENTATIONS = $(PROJECTDIR)/presentations

## ---------- Targets ----------
RMD = $(wildcard *.rmd)
RNW = $(wildcard *.rnw)
PDF = $(patsubst %.rmd, %.pdf, $(RMD)) $(patsubst %.rnw, %.pdf, $(RNW))
TEX = $(patsubst %.rmd, %.tex, $(RMD)) $(patsubst %.rnw, %.tex, $(RNW))
HTML = $(patsubst %.rmd, %.html, $(RMD))
# tex versions of the files, just to clean up
$(info "pdf files: $(PDF)")

%.tex: %.rnw
	Rscript -e "knitr::knit('$<', quiet=FALSE)"

# keep TEX for debugging
.PRECIOUS: %.tex

%.pdf: %.tex
	latexmk -xelatex -f -interaction=nonstopmode $<

$(DESCRIPTIVES): $(WRITINGDIR)/descriptives.rnw $(CODEDIR)/conf.R \
 $(CODEDIR)/classes.R  $(CODEDIR)/dataClasses.R $(CODEDIR)/methods.R \
 $(CODEDIR)/utils.R $(CODEDIR)/tools.R\
 $(CODEDIR)/loadData.R $(CODEDIR)/plots.R $(CODEDIR)/towers.R $(CODEDIR)/analyze.R \
 $(GOOGLE_MAPS) $(ACCOUNT_AGGREGATES) $(DISTRICT_AGGREGATES_24) $(CELL_DIVISION)\
 $(INPUT_DATA_DESCRIPTION)\
 $(MONTHLY_ACCOUNTS)\
 $(GP3_ALL_DISTRICT_MONTH) $(GP3_CORP_D_M) $(GP3_P_SW)\
 $(GP2V_D_M)\
 $(NIGHTLIGHTS)
	Rscript -e "knitr::knit2pdf('$<', quiet=FALSE)" && mv descriptives.pdf $(WRITINGDIR)/ && rm -vf descriptives.{aux,tex}



all: $(PDF)

clean:
	rm -vf $(TEX) *.rnw~ *.aux *.bbl *.blg *.fdb_latexmk \
 *.fls *.log *.out *.xdv
# -v : verbose
# -f: ignore non-existent files
