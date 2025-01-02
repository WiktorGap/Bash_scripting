#!/bin/bash

pliktex="pierwszy.tex"
plikpdf="pierwsz.pdf"

touch $pliktex



echo "\documentclass{article}" >  $pliktex
echo  "\begin{document}" >> $pliktex
echo "\begin{center} " >> $pliktex
echo "{\Large\textbf\{hello bejbe}}" >> $pliktex
echo "\end{center}" >> $pliktex
echo "\end{document}" >> $pliktex

pdflatex $pliktex
pdflatex $pliktex

evince $pliktex
