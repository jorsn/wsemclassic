NAME	:= wsemclassic-test

tmp_dir	:= tmp

LATEX	:= pdflatex -output-directory=$(tmp_dir)
D_LATEX	:= $(LATEX) -draftmode $(NAME)
BIBTEX	:= bibtex $(tmp_dir)/$(NAME)

LATEX	:= $(LATEX) $(NAME)


all: test

test: clean-pdf $(NAME).pdf

tmp-dir:
	test -d $(tmp_dir) || mkdir $(tmp_dir)

$(NAME).pdf: tmp-dir $(NAME).tex expose.bib
	$(D_LATEX)
	grep nobib $(NAME).tex || $(BIBTEX)
	$(D_LATEX)
	$(LATEX)
	mv $(tmp_dir)/$(NAME).pdf .

clean-pdf:
	rm -f $(NAME).pdf

clean: clean-pdf
	rm -rf $(tmp_dir)
