# compiles report into a pdf
pdflatex --shell-escape --interaction nonstopmode -halt-on-error -file-line-error template.tex
bibtex template.aux
pdflatex --shell-escape --interaction nonstopmode -halt-on-error -file-line-error template.tex
pdflatex --shell-escape --interaction nonstopmode -halt-on-error -file-line-error template.tex
