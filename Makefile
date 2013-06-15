NAME		:= wsemclassic
NAME_EXT	:= dtx
TEST_NAME	:= $(NAME)-test
TEST_NAME_EXT	:= tex

tmp_dir	:= tmp

LATEX	:= pdflatex -output-directory=$(tmp_dir)
D_LATEX	= $(LATEX) -draftmode $(FILE).$(FILE_EXT)
BIBTEX	= bibtex $(tmp_dir)/$(FILE)

RUN_LATEX = $(LATEX) $(FILE).$(FILE_EXT)


all: doc test

doc: FILE_EXT	:= $(NAME_EXT)
doc: clean-pdf $(NAME).pdf

test: FILE_EXT	:= $(TEST_NAME_EXT)
test: clean-pdf $(TEST_NAME).pdf

tmp-dir:
	test -d $(tmp_dir) || mkdir $(tmp_dir)

%.pdf: FILE	= $*
%.pdf: tmp-dir $(FILE).$(FILE_EXT) test.bib
	$(D_LATEX)
	if [ '$(FILE)' = '$(TEST_NAME)' ]; then \
		grep nobib $(FILE).tex || $(BIBTEX); \
	else \
		makeindex -s gglo.ist -o $(tmp_dir)/$(FILE).gls $(tmp_dir)/$(FILE).glo; \
		makeindex -s gind.ist -o $(tmp_dir)/$(FILE).ind $(tmp_dir)/$(FILE).idx; \
	fi
	$(D_LATEX)
	$(RUN_LATEX)
	mv $(tmp_dir)/$(FILE).pdf .

clean-pdf:
	rm -f $(TEST_NAME).pdf $(NAME).pdf

clean: clean-pdf
	rm -rf $(tmp_dir)
