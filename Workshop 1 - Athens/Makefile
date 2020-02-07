SRC = $(wildcard *.Rmd)

MD    = $(SRC:.Rmd=.md)
PDF   = $(SRC:.Rmd=.pdf)
HTML  = $(SRC:.Rmd=.html)

KNIT =  @Rscript -e "rmarkdown::render('$<', run_pandoc=FALSE, clean=FALSE); sp<-file.rename(gsub('.Rmd','.knit.md','$<', fixed=TRUE), gsub('.Rmd','.md','$<', fixed=TRUE)); sp<-file.remove(gsub('.Rmd','.utf8.md','$<',fixed=TRUE))"

SETUP = @Rscript -e "sp<-file.copy('$<', gsub('.md','_tmp.md','$<', fixed=TRUE))"
RENDER_H = @Rscript -e "rmarkdown::render(gsub('.md','_tmp.md','$<',fixed=TRUE), 'html_document'); sp<-file.rename(gsub('.md','_tmp.html','$<', fixed=TRUE), gsub('.md','.html','$<', fixed=TRUE))"
RENDER_P = @Rscript -e "rmarkdown::render(gsub('.md','_tmp.md','$<',fixed=TRUE)); sp<-file.rename(gsub('.md','_tmp.pdf','$<', fixed=TRUE), gsub('.md','.pdf','$<', fixed=TRUE))"
TIDYUP = @Rscript -e "sp<-file.remove(gsub('.md','_tmp.md','$<', fixed=TRUE))"

%.md:%.Rmd
	$(KNIT)
%.html:%.md
	$(SETUP)
	$(RENDER_H)
	$(TIDYUP)
%.pdf:%.md
	$(SETUP)
	$(RENDER_P)
	$(TIDYUP)

.PHONY: clean
.PHONY: all
	
all: 	$(MD) $(PDF) $(HTML)
md:		$(MD)
pdf:	$(MD) $(PDF)
html:	$(MD) $(HTML)
clean:
	-rm -rf Adv*.md
	-rm -rf Adv*.pdf
	-rm -rf Adv*.html
	-rm -rf Adv*_files
