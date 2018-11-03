# compiles report into a pdf
pdflatex --shell-escape template.tex
bibtex template.aux
pdflatex --shell-escape template.tex
pdflatex --shell-escape template.tex
