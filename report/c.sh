# compiles report into a pdf
pdflatex --shell-escape --interaction nonstopmode -halt-on-error -file-line-error report.tex
bibtex report.aux
pdflatex --shell-escape --interaction nonstopmode -halt-on-error -file-line-error report.tex
pdflatex --shell-escape --interaction nonstopmode -halt-on-error -file-line-error report.tex
