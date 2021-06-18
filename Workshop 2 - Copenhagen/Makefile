SRC = $(wildcard *.Rmd)

PDF   = $(SRC:.Rmd=.pdf)
HTML  = $(SRC:.Rmd=.html)

RENDER_H = @Rscript -e "rmarkdown::render('$<', 'html_document', params=list(presentation=FALSE))"
RENDER_P = @Rscript -e "rmarkdown::render('$<', 'beamer_presentation', params=list(presentation=TRUE))"
RENDER_B = @Rscript -e "rmarkdown::render('$<', 'all')"

%.html:%.Rmd
	$(RENDER_H)
	-rm -rf Session*.log
%.pdf:%.Rmd
	$(RENDER_P)
	-rm -rf Session*.log

.PHONY: clean
.PHONY: tidy
.PHONY: pdf
.PHONY: html
.PHONY: all
	
all: 	$(PDF) $(HTML)
pdf:	$(PDF)
html:	$(HTML)
clean:
	-rm -rf Session*.md
	-rm -rf Session*.tex
	-rm -rf Session*.pdf
	-rm -rf Session*.html
	-rm -rf Session*.log
	-rm -rf Session*_files
tidy:
	-rm -rf Session*.md
	-rm -rf Session*.tex
	-rm -rf Session*.log
	-rm -rf Session*_files
