SRC = $(wildcard *.Rmd)

PDF   = $(SRC:.Rmd=.pdf)
HTML  = $(SRC:.Rmd=.html)

RENDER_H = @Rscript -e "rmarkdown::render('$<', 'html_document', params=list(presentation=FALSE))"
RENDER_P = @Rscript -e "rmarkdown::render('$<', 'beamer_presentation', params=list(presentation=TRUE))"
RENDER_B = @Rscript -e "rmarkdown::render('$<', 'all')"

%.html:%.Rmd
	$(RENDER_H)
	-rm -rf Adv*.log
%.pdf:%.Rmd
	$(RENDER_P)
	-rm -rf Adv*.log

.PHONY: clean
.PHONY: tidy
.PHONY: pdf
.PHONY: html
.PHONY: all
	
all: 	$(PDF) $(HTML)
pdf:	$(PDF)
html:	$(HTML)
clean:
	-rm -rf Adv*.md
	-rm -rf Adv*.tex
	-rm -rf Adv*.pdf
	-rm -rf Adv*.html
	-rm -rf Adv*.log
	-rm -rf Adv*_files
tidy:
	-rm -rf Adv*.md
	-rm -rf Adv*.tex
	-rm -rf Adv*.log
	-rm -rf Adv*_files
