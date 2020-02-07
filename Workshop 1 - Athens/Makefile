SRCR = $(wildcard *.Rmd)
SRCM = $(wildcard *.knit.md)

MD    = $(SRCR:.Rmd=.knit.md)
PDF   = $(SRCM:.knit.md=.pdf)
HTML  = $(SRCM:.knit.md=.html)

KNIT =  @Rscript -e "rmarkdown::render('$<', run_pandoc=FALSE, clean=FALSE)"
RENDER_H = @Rscript -e "rmarkdown::render('$<', 'html_document'); sp<-file.remove(gsub('.Rmd','.log','$<',fixed=TRUE))"
RENDER_P = @Rscript -e "rmarkdown::render('$<'); sp<-file.remove(gsub('.Rmd','.log','$<',fixed=TRUE))"

%.knit.md:%.Rmd
	$(KNIT)
%.html:%.knit.md
	$(RENDER_H)
%.pdf:%.knit.md
	$(RENDER_P)
	
#pdf:	$(PDF)
#html:	$(HTML)
#all: $(PDF) $(HTML)
all: $(MD) $(HTML)