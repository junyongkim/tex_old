----------------------------------------------------------------------------------------------------
readme.txt
Junyong Kim
February 11th, 2019
----------------------------------------------------------------------------------------------------
190211 2357

1. I downloaded 7 files from "https://www.larson-group.com/ajsmith4/latex.php"

UWMthesis.cls
natbib.sty
UWM_masters_thesis.tex
ametsoc.bst
mybibabbr.bib
nov11_sndg_qcm_compare_t61_bw.eps
scatter_eqn23_F_psdep.eps

2. I downloaded 1 file from "http://faculty.haas.berkeley.edu/stanton/texintro/"

texintro.zip

I unzipped this file and added "jf.bst" to the folder

3. I changed "UWM_masters_thesis.tex" as follows

L262: "../thesis_figures/" was removed
L289: [ht] altered [h]
L291: "../thesis_figures/" was removed
L538: "jf" altered "./ametsoc"
L541: "./" was removed

4. Compile as follows: pdfLaTeX, BibTeX, pdfLaTeX, and pdfLaTeX

5. "oneside" is assumed by default, but must be changed to "twoside"
----------------------------------------------------------------------------------------------------